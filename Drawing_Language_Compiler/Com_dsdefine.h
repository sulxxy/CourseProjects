#ifndef COM_DSDEFINE_H
#define COM_DSDEFINE_H
typedef double (* FuncPtr)(double);
typedef struct ExprNode{
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
}ExprNode;
typedef struct {
    int line;
    QString errString;
    int errorType;
}ERRORINFO;

#endif // COM_DSDEFINE_H
