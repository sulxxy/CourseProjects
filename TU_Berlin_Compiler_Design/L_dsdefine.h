#ifndef DSDEFINE_H
#define DSDEFINE_H
#include <cmath>
#include <QString>
#include <iostream>

typedef double(*FuncPtr)(double);
enum Token_Type{
    ORIGIN, SCALE, ROT, IS, TO, STEP, DRAW, FOR, FROM,
    T,
    SEMICO, L_BRACKET, R_BRACKET, COMMA,
    PLUS, MINUS, MUL, DIV, POWER,
    FUNC,
    CONST_ID,
    NONTOKEN,
    ERRTOKEN
};

struct Token{
    Token_Type type;
    QString    lexeme;
    double value;
    double (*FuncPtr)(double);
};

static Token TokenTab[] = {
    { CONST_ID,    "PI",      3.1415926,    NULL },
    { CONST_ID,    "E",       2.71828,      NULL },
    { T,           "T",       0.0,          NULL },
    { FUNC,        "SIN",     0.0,          sin  },
    { FUNC,        "COS",     0.0,          cos  },
    { FUNC,        "TAN",     0.0,          tan  },
    { FUNC,        "LN",      0.0,          log  },
    { FUNC,        "EXP",     0.0,          exp  },
    { FUNC,        "SQRT",    0.0,          sqrt },
    { ORIGIN,      "ORIGIN",  0.0,          NULL },
    { SCALE,       "SCALE",   0.0,          NULL },
    { ROT,         "ROT",     0.0,          NULL },
    { FOR,         "FOR",     0.0,          NULL },
    { IS,          "IS",      0.0,          NULL },
    { FROM,        "FROM",    0.0,          NULL },
    { TO,          "TO",      0.0,          NULL },
    { STEP,        "STEP",    0.0,          NULL },
    { DRAW,        "DRAW",    0.0,          NULL }
};


#endif // DSDEFINE_H
