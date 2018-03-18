#include "compiler.h"
#include <QPoint>
#include <cmath>
#include <QDebug>
#include <QWidget>
#include <QPainter>
#include <QString>

/************************construction********************************/
Compiler::Compiler(QWidget *parent) :
    QWidget(parent)
{
    Origin_x = 0;
    Origin_y = 0;
    Scale_x = 1;
    Scale_y = 1;
    Step = 0;
    RotAngle = 0;
    Parameter = 0;
    Indent = 0;
    p1 = p2 = 0;
    hasError = false;
    Lex = new Lexical();
    pointlist.clear();
    errList.clear();
}

QVector<ERRORINFO> Compiler::GetErrorInfoList()
{
    return errList;
}
void Compiler::paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    QPen pen(Qt::red, 1);
    painter.setPen(pen);
//    qDebug() << "Compiler::paintEvent test: " << pointlist.count() ;
    foreach (QPoint t, pointlist) {
        painter.drawPoint(t);
    }
}

/***********************assistant functions*****************************/
void Compiler::SyntaxError(Token_Type tt)
{
    if(tt == ERRTOKEN){
        qDebug("token error");
    }
    else{
        qDebug() << "Compiler::SyntaxError Debug: Syntax Error:" << tt;
    }
}
void Compiler::PrintToken(const ExprNode *t, int indent)
{
    switch(t->OpType){
    case PLUS:
        emit GTreeInfo("+", indent);
        break;
    case MINUS:
        emit GTreeInfo("-", indent);
        break;
    case MUL:
        emit GTreeInfo("*", indent);
        break;
    case DIV:
        emit GTreeInfo("/", indent);
        break;
    case CONST_ID:
        emit GTreeInfo(QString::number(t->Content.ConstType), indent);
        break;
    case T:
        emit GTreeInfo("T", indent);
        break;
    case POWER:
        emit GTreeInfo("**", indent);
        break;
    case FUNC:
        for(int i = 3; i < 9; i++){
            if(t->Content.FuncType.MathFuncPtr == TokenTab[i].FuncPtr){
                emit GTreeInfo(TokenTab[i].lexeme, indent);
                break;
            }
        }
        break;
    default:
        break;
    }
    return ;
}
void Compiler::MatchToken(Token_Type tt)
{
    if(tokens.type == tt){
        p1 = Lex->GetP();
//        qDebug() << "Compiler::MatchToken debug: P1: " << p1;
        tokens = Lex->GetToken();
    }
    else if(tokens.type == ERRTOKEN){
        hasError = true;
        Lex->GoBack();
        p2 = Lex->GetP();
        QString tmp = Lex->GetErrorString(p1, p2);
        int currentlineNumber = Lex->GetCurrentLineNumber();
        ERRORINFO errtmp;
        errtmp.errString = tmp;
        errtmp.line = currentlineNumber;
        errtmp.errorType = 0;
        errList.append(errtmp);
//        qDebug() << "Compiler::MatchToken debug: P2: " << p2;
        tokens = Lex->GetToken();               //get next token after go back
    }
    else{
        int currentlineNumber = Lex->GetCurrentLineNumber();
        ERRORINFO errtmp;
        errtmp.errString = tokens.lexeme;
        if(tt == SEMICO)
            currentlineNumber++;
        errtmp.line = currentlineNumber;
        errtmp.errorType = 1;
        errList.append(errtmp);
        SyntaxError(tokens.type);
    }
}
void Compiler::appendPoint(QPoint t)
{
    pointlist.append(t);
}

/**************************recursive descent**************************/

void Compiler::Parser(QString st)
{
    s = Lex->InitParser(st);
    Lex->GetString(s);
    tokens = Lex->GetToken();
        ERRORINFO errtmp;
    switch (tokens.type) {
    case NONTOKEN:
        break;
    case ERRTOKEN:
        hasError = true;
        errtmp.errorType = 1;
        errtmp.line = 1;
        errtmp.errString = tokens.lexeme;
//        qDebug() << "Compiler::Parser Debug: " << tokens.lexeme;
        errList.append(errtmp);
        break;
    default:
        Program();
        break;
    }
    return ;
}

void Compiler::Program()
{
    while(tokens.type != NONTOKEN && tokens.type != ERRTOKEN){
        Statement();
        MatchToken(SEMICO);
    }
}

void Compiler::Statement()
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
        SyntaxError(tokens.type);
        break;
    }
}

void Compiler::ForStatement()
{
        ExprNode* StartPtr, *EndPtr, *StepPtr, *xPtr, *yPtr;
        double StartValue, EndValue, StepValue;
        MatchToken(FOR);
        MatchToken(T);
        MatchToken(FROM);
        StartPtr = Expression();
        emit GTreeInfo("START Grammar Tree:", -1);
        PrintSyntaxTree(StartPtr, 0);
        StartValue = GetExprValue(StartPtr);
        DelExprTree(StartPtr);
        MatchToken(TO);
        EndPtr = Expression();
        emit GTreeInfo("END Grammar Tree:", -1);
        PrintSyntaxTree(EndPtr, 0);
        EndValue  = GetExprValue(EndPtr);
        DelExprTree(EndPtr);
        MatchToken(STEP);
        StepPtr = Expression();
        emit GTreeInfo("STEP Grammar Tree:", -1);
        PrintSyntaxTree(StepPtr, 0);
        StepValue = GetExprValue(StepPtr);
        DelExprTree(StepPtr);
        MatchToken(DRAW);
        MatchToken(L_BRACKET);
        xPtr = Expression();
        emit GTreeInfo("DRAW_X Grammar Tree:", -1);
        PrintSyntaxTree(xPtr, 0);
        MatchToken(COMMA);
        yPtr = Expression();
        emit GTreeInfo("DRAW_Y Grammar Tree:", -1);
        PrintSyntaxTree(yPtr, 0);
        MatchToken(R_BRACKET);
        if(!hasError)
            DrawLoop(StartValue, EndValue, StepValue, xPtr, yPtr);
        DelExprTree(xPtr);
        DelExprTree(yPtr);
}

void Compiler::OriginStatement()
{
    ExprNode* tmp;
    MatchToken(ORIGIN);
    MatchToken(IS);
    MatchToken(L_BRACKET);
//    qDebug() << "Compiler::OriginStatement Debug: " << Lex->GetP();
    tmp = Expression();
    emit GTreeInfo("ORIGIN_X Grammar Tree:", -1);
    PrintSyntaxTree(tmp, 0);
    Origin_x = GetExprValue(tmp);
    DelExprTree(tmp);
    MatchToken(COMMA);
    tmp = Expression();
    emit GTreeInfo("ORIGIN_Y Grammar Tree:", -1);
    PrintSyntaxTree(tmp, 0);
    Origin_y = GetExprValue(tmp);
    DelExprTree(tmp);
    MatchToken(R_BRACKET);
}

void Compiler::ScaleStatement()
{
    ExprNode* tmp;
    MatchToken(SCALE);
    MatchToken(IS);
    MatchToken(L_BRACKET);
    tmp = Expression();
    emit GTreeInfo("SCALE_X Grammar Tree:", -1);
    PrintSyntaxTree(tmp, 0);
    Scale_x = GetExprValue(tmp);
    DelExprTree(tmp);
    MatchToken(COMMA);
    tmp = Expression();
    emit GTreeInfo("SCALE_Y Grammar Tree:", -1);
    PrintSyntaxTree(tmp, 0);
    Scale_y = GetExprValue(tmp);
    MatchToken(R_BRACKET);
}

void Compiler::RotStatement()
{
    ExprNode* tmp;
    MatchToken(ROT);
    MatchToken(IS);
    tmp = Expression();
    emit GTreeInfo("ROT Grammar Tree:", -1);
    PrintSyntaxTree(tmp, 0);
    RotAngle = GetExprValue(tmp);
    DelExprTree(tmp);
}

ExprNode* Compiler::Expression()
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

ExprNode* Compiler::Term()
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

ExprNode* Compiler::Factor()
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

ExprNode* Compiler::Component()
{
    ExprNode *LeftPtr, *RightPtr;
    LeftPtr = Atom();
    if(tokens.type == POWER){
        MatchToken(POWER);
//        qDebug() << "Compiler::Component Debug: " << tokens.type;
        RightPtr = Component();
        LeftPtr = MakeExprNode(POWER, LeftPtr, RightPtr);
    }
    return LeftPtr;
}

ExprNode* Compiler::Atom()
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
        SyntaxError(tokens.type);
    }
    return Address;
}

/*********************functions about syntaxtree**********************/
ExprNode* Compiler::MakeExprNode(Token_Type optype, ...)
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

void Compiler::PrintSyntaxTree(const ExprNode* root, int indent){
    PrintToken(root, indent);
    if(root->OpType == FUNC){
        PrintSyntaxTree(root->Content.FuncType.Child, ++indent);
    }
    else if(root->OpType != CONST_ID && root->OpType != T){
        PrintSyntaxTree(root->Content.OperatorType.Left, ++indent);
        PrintSyntaxTree(root->Content.OperatorType.Right, indent);
    }
    return;
}

void Compiler::DelExprTree(ExprNode * root)
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

double Compiler::GetExprValue(ExprNode *root)
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
}

QPoint Compiler::CalcFinalPoint(ExprNode *HorPtr, ExprNode *VerPtr)
{
    double hx = GetExprValue(HorPtr);
    double vy = GetExprValue(VerPtr);

    hx *= Scale_x;
    vy *= Scale_y;

    double hTmp = hx * cos(RotAngle) + vy * sin(RotAngle);
    vy = vy * cos(RotAngle) - hx * sin(RotAngle);
    hx = hTmp;

    hx += Origin_x;
    vy += Origin_y;
    QPoint p;
    p.setX(hx);
    p.setY(vy);
    return p;
}

void Compiler::DrawLoop(double start, double end, double step, ExprNode *HorPtr, ExprNode *VerPtr)
{
    QPoint tmp;
    for(Parameter = start; Parameter <= end; Parameter += step){
        tmp = CalcFinalPoint(HorPtr, VerPtr);
        appendPoint(tmp);
    }

}

void Compiler::ClearData()
{
    Origin_x = 0;
    Origin_y = 0;
    Scale_x = 1;
    Scale_y = 1;
    Step = 0;
    RotAngle = 0;
    Parameter = 0;
    Indent = 0;
    hasError = false;
    pointlist.clear();
    errList.clear();
    Lex->ClearData();

}
