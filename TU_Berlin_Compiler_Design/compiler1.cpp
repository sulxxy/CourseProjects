/*#include "compiler1.h"
#include <cmath>
#include <QPoint>

Compiler1::Compiler1(QWidget *parent) :
    QWidget(parent)
{
    Lex = new Lexical();
    Paint = new Draw();
    connect(this, SIGNAL(DrawUpdate(QPoint)), Paint, SIGNAL(DrawUpdate(QPoint)));
}
void Compiler1::SyntaxError()
{
    qFatal("ERROR");
}
void Compiler1::MatchToken(Token_Type tt)
{
    if(tokens.type == tt){
        //tokens = Lex->GetToken();
    }
    else
        SyntaxError();
}

void Compiler1::Parser(QFile file)
{
    s = Lex->InitParser(file);
    tokens = Lex->GetToken();
    Program();
    return ;
}
void Compiler1::Program()
{
    while(tokens.type != NONTOKEN){
        Statement();
        MatchToken(SEMICO);
    }
}
void Compiler1::Statement()
{
    switch (tokens.type) {
    case FOR:
        ForStatement();
        break;
    case ORIGIN:
        OriginStatement();
        break;
    case SCALE:
        ScaleStatement();
        break;
    case ROT:
        RotStatement();
        break;
    default:
        SyntaxError();
        break;
    }
}
void Compiler1::ForStatement()
{
    ExprNode* StartPtr, *EndPtr, *StepPtr, *xPtr, *yPtr;
    double StartValue, EndValue, StepValue;
    MatchToken(FOR);
    MatchToken(T);
    MatchToken(FROM);
    StartPtr = Expression();
    StartValue = GetExprValue(StartPtr);
    DelExprTree(StartPtr);
    MatchToken(TO);
    EndPtr = Expression();
    EndValue  = GetExprValue(EndPtr);
    DelExprTree(EndPtr);
    MatchToken(STEP);
    StepPtr = Expression();
    StepValue = GetExprValue(StepPtr);
    DelExprTree(StepPtr);
    MatchToken(DRAW);
    MatchToken(L_BRACKET);
    xPtr = Expression();
    MatchToken(COMMA);
    yPtr = Expression();
    MatchToken(R_BRACKET);
    DrawLoop(StartValue, EndValue, StepValue, xPtr, yPtr);
    DelExprTree(xPtr);
    DelExprTree(yPtr);
}
void Compiler1::OriginStatement()
{
    ExprNode* tmp;
    MatchToken(ORIGIN);
    MatchToken(IS);
    MatchToken(L_BRACKET);
    tmp = Expression();
    Origin_x = GetExprValue(tmp);
    DelExprTree(tmp);
    MatchToken(COMMA);
    tmp = Expression();
    Origin_y = GetExprValue(tmp);
    DelExprTree(tmp);
    MatchToken(R_BRACKET);
    MatchToken(SEMICO);
}
void Compiler1::ScaleStatement()
{
    ExprNode* tmp;
    MatchToken(SCALE);
    MatchToken(IS);
    MatchToken(L_BRACKET);
    tmp = Expression();
    Scale_x = GetExprValue(tmp);
    DelExprTree(tmp);
    MatchToken(COMMA);
    tmp = Expression();
    Scale_y = GetExprValue(tmp);
    MatchToken(R_BRACKET);
    MatchToken(SEMICO);

}
void Compiler1::RotStatement()
{
    ExprNode* tmp;
    MatchToken(ROT);
    MatchToken(IS);
    MatchToken(L_BRACKET);
    tmp = Expression();
    RotAngle = GetExprValue(tmp);
    DelExprTree(tmp);
    MatchToken(R_BRACKET);
    MatchToken(SEMICO);
}
ExprNode* Compiler1::Expression()
{
    ExprNode *LeftPtr, *RightPtr;
    Token_Type token_tmp;
    LeftPtr = Term();
    while(tokens.type == PLUS || tokens.type == MINUS){
        token_tmp = tokens.type;
        MatchToken(token_tmp);
        RightPtr = Term();
        LeftPtr = MakeExprNode(token_tmp, LeftPtr, RightPtr);
    }
    return LeftPtr;
}
ExprNode* Compiler1::Term()
{
    ExprNode *LeftPtr, *RightPtr;
    Token_Type token_tmp;
    LeftPtr = Factor();
    while(tokens.type == MUL || tokens.type == DIV){
        token_tmp = tokens.type;
        MatchToken(token_tmp);
        RightPtr = Factor();
        LeftPtr = MakeExprNode(token_tmp, LeftPtr, RightPtr);
    }
    return LeftPtr;
}
ExprNode* Compiler1::Factor()
{
    ExprNode *LeftPtr, *RightPtr;
    if(tokens.type == PLUS){
        MatchToken(PLUS);
        RightPtr = Factor();
    }
    else if(tokens.type == MINUS){
        MatchToken(MINUS);
        RightPtr = Factor();
        LeftPtr = new ExprNode;
        LeftPtr->OpType = CONST_ID;
        LeftPtr->Content.ConstType = 0.0;
        RightPtr = MakeExprNode(MINUS, LeftPtr, RightPtr);
    }
    else
        RightPtr = Component();
    return RightPtr;

}
ExprNode* Compiler1::Component()
{
    ExprNode *LeftPtr, *RightPtr;
    LeftPtr = Atom();
    if(tokens.type == POWER){
        MatchToken(POWER);
        RightPtr = Component();
        LeftPtr = MakeExprNode(POWER, LeftPtr, RightPtr);
    }
    return LeftPtr;
}
ExprNode* Compiler1::Atom()
{
    Token t = tokens;
    ExprNode *Address, *tmp;
    switch(tokens.type){
    case CONST_ID:
        MatchToken(CONST_ID);
        Address = MakeExprNode(CONST_ID, t.value);
        break;
    case T:
        MatchToken(T);
        Address = MakeExprNode(T);
        break;
    case FUNC:
        MatchToken(FUNC);
        MatchToken(L_BRACKET);
        tmp = Expression();
        Address = MakeExprNode(FUNC, t.FuncPtr, tmp);
        MatchToken(R_BRACKET);
        break;
    case L_BRACKET:
        MatchToken(L_BRACKET);
        Address = Expression();
        MatchToken(R_BRACKET);
        break;
    default:
        SyntaxError();
    }
    return Address;
}

ExprNode* Compiler1::MakeExprNode(Token_Type optype, ...)
{
    ExprNode *ExprPtr = new ExprNode;
    ExprPtr->OpType = optype;
    va_list ArgPtr;
    va_start(ArgPtr, optype);
    switch(optype){
    case CONST_ID:
        ExprPtr->Content.ConstType = (double)va_arg(ArgPtr,double);
        break;
    case T:
        ExprPtr->Content.ParmPtrType = &Parameter;
        break;
    case FUNC:
        ExprPtr->Content.FuncType.MathFuncPtr = (FuncPtr)va_arg(ArgPtr, FuncPtr);
        ExprPtr->Content.FuncType.Child = (ExprNode*)va_arg(ArgPtr, ExprNode*);
        break;
    default:
        ExprPtr->Content.OperatorType.Left = (ExprNode*)va_arg(ArgPtr, ExprNode*);
        ExprPtr->Content.OperatorType.Right = (ExprNode*)va_arg(ArgPtr, ExprNode*);
        break;
    }
    va_end(ArgPtr);
    return ExprPtr;
}
void PrintSyntaxTree(ExprNode* root){

}
void Compiler1::DelExprTree(ExprNode * root)
{
    if(!root){
        return ;
    }
    switch (root->OpType) {
    case PLUS:
    case MINUS:
    case MUL:
    case DIV:
    case POWER:
        DelExprTree(root->Content.OperatorType.Left);
        DelExprTree(root->Content.OperatorType.Right);
        break;
    case FUNC:
        DelExprTree(root->Content.FuncType.Child);
        break;
    default:
        break;
    }
}
double Compiler1::GetExprValue(ExprNode *root)
{
    if(!root){
        return 0.0;
    }
    switch(root->OpType){
    case PLUS:
        return GetExprValue(root->Content.OperatorType.Left) + GetExprValue(root->Content.OperatorType.Right);
    case MINUS:
        return GetExprValue(root->Content.OperatorType.Left) - GetExprValue(root->Content.OperatorType.Right);
    case MUL:
        return GetExprValue(root->Content.OperatorType.Left) * GetExprValue(root->Content.OperatorType.Right);
    case DIV:
        return GetExprValue(root->Content.OperatorType.Left) / GetExprValue(root->Content.OperatorType.Right);
    case POWER:
        return pow(GetExprValue(root->Content.OperatorType.Left), GetExprValue(root->Content.OperatorType.Right));
    case FUNC:
        return (*root->Content.FuncType.MathFuncPtr)(GetExprValue(root->Content.FuncType.Child));
    case CONST_ID:
        return root->Content.ConstType;
    case T:
        return *(root->Content.ParmPtrType);
    default:
        return 0.0;
    }
}*/
