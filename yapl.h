typedef enum { typeCon, typeId, typeOpr } nodeEnum;

/* constants */
typedef struct {
    int value;
} conNodeType;

/* identifiers */
typedef struct {
    int i;
} idNodeType;

/* operators */
typedef struct {
    int oper;
    int nops;
    struct nodeTypeTag *op[1];
} oprNodeType;

typedef struct nodeTypeTag {
    nodeEnum type;

    union {
        conNodeType con;
        idNodeType id;
        oprNodeType opr;
    };
} nodeType;

extern int sym[26];
