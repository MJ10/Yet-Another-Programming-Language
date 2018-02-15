%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "yapl.h"

/* prototypes */
nodeType *opr(int oper, int nops, ...);
nodeType *id(int i);
nodeType *con(int value);
void freeNode(nodeType *p);
int ex(nodeType *p);
int yylex(void);

void yyerror(char *s);
int sym[26];                    /* symbol table */
%}

%union {
    int number;                 /* integer value */
    char sIndex;                /* symbol table index */
    nodeType *nPtr;             /* node pointer */
};

%token <number> INTEGER
%token <sIndex> VARIABLE
%token WHILE IF RETURN PRINT EQ

%type <nPtr> prog expr

%%

start:
        prog    { ex($1); freeNode($1); } start
        | expr            { printf("%d\n\n", ex($1)); } start
        | /* NULL */
        ;

prog:
         '[' ';' prog prog ']'          { $$ = opr(';', 2, $3, $4); }
        | '[' RETURN expr ']'                 { $$ = opr(PRINT, 1, $3); }
        | '[' '=' VARIABLE expr ']'          { $$ = opr('=', 2, id($3), $4); }
        | '[' WHILE expr prog ']'        { $$ = opr(WHILE, 2, $3, $4); }
        | '[' IF expr prog prog ']' { $$ = opr(IF, 3, $3, $4, $5); }
        ;

expr:
        INTEGER               { $$ = con($1); }
        | VARIABLE              { $$ = id($1); }
        | '[' '+' expr expr ']'         { $$ = opr('+', 2, $3, $4); }
        | '[' '*' expr expr ']'         { $$ = opr('*', 2, $3, $4); }
        | '[' '<' expr expr ']'        { $$ = opr('<', 2, $3, $4); }
        | '[' EQ expr expr ']'        { $$ = opr(EQ, 2, $3, $4); }
        ;

%%

nodeType *con(int value) {
    nodeType *p;

    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");
    p->type = typeCon;
    p->con.value = value;

    return p;
}

nodeType *id(int i) {
    nodeType *p;
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");
    p->type = typeId;
    p->id.i = i;

    return p;
}

nodeType *opr(int oper, int nops, ...) {
    va_list ap;
    nodeType *p;
    int i;

    if ((p = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) == NULL)
        yyerror("out of memory");

    p->type = typeOpr;
    p->opr.oper = oper;
    p->opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, nodeType*);
    va_end(ap);
    return p;
}

void freeNode(nodeType *p) {
    int i;

    if (!p) return;
    if (p->type == typeOpr) {
        for (i = 0; i < p->opr.nops; i++)
            freeNode(p->opr.op[i]);
    }
    free (p);
}

void yyerror(char *s) {
    extern char* yytext;
    extern int yylineno;
    fprintf(stdout, "%s\nLine No: %d\nAt char: %c\n", s, yylineno,*yytext);
}

int main(void) {
    yyparse();
    return 0;
}
