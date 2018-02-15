# Yet Another Programming Language

This is a basic interpreter built using `bison` and `flex` for the a programming language defined by the following grammar:

```
<expr> := [ <op> <expr> <expr> ] | 
                 <symbol> | <value>
<symbol> := [a-zA-Z]+
<value> := [0-9]+
<op> := ‘+’ | ‘*’ | ‘==‘ | ‘<‘
<prog> := [ = <symbol> <expr> ] |
          [ ; <prog> <prog> ] |
          [ if <expr> <prog> <prog> ] |
          [ while <expr> <prog> ] |
          [ return <expr> ]
```

## Requirements

To build the interpreter you need `flex` and `bison` installed.

For installing bison and flex on Ubuntu, use the following command:

```bash
sudo apt install build-essential bison flex
```

## Building the Interpreter

To build the interpreter use the following command:

```bash
bash build
```

To clear the build files for a new build, use the following:

```bash
bash clean
```

## License

This repository is licensed under the [MIT License](https://github.com/MJ10/Yet-Another-Programming-Language/blob/master/LICENSE.md)