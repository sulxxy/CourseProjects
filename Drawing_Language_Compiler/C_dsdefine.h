#ifndef C_DSDEFINE_H
#define C_DSDEFINE_H
#include "lexical.h"
Token tokens;
double Origin_x = 0, Origin_y = 0, Scale_x = 1, Scale_y = 1;
double Step = 0;
double RotAngle = 0;
double Parameter = 0;

typedef double (* FuncPtr)(double);
struct ExprNode{
    enum Token_Type OpType;
    union {
        struct {
            ExprNode *Left;
            ExprNode *Right;
        }OperatorType;
        struct{
            ExprNode *Child;
            FuncPtr MathFuncPtr;
        }FuncType;
        double ConstType;
        double *ParmPtrType;
    }Content;
};

#endif // C_DSDEFINE_H
