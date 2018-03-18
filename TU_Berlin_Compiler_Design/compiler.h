#ifndef COMPILER_H
#define COMPILER_H
#include <cstdarg>
#include "lexical.h"
#include "Com_dsdefine.h"
#include <QWidget>
#include <QLinkedList>
class Compiler : public QWidget{
    Q_OBJECT
private:
    QString s;
    Lexical* Lex;
    Token tokens;
    double Origin_x, Origin_y, Scale_x, Scale_y;
    double Step;
    double RotAngle;
    double Parameter;
    QList<QPoint> pointlist;

    int Indent;

    int p1,p2;    //record the false string [p1, p2]

    QVector<ERRORINFO> errList;

    bool hasError;

protected:
    void paintEvent(QPaintEvent *);

signals:
    void DrawUpdate(QPoint);
    void GTreeInfo(QString, int);
//    void StartDraw();

public slots:
    void appendPoint(QPoint);
public:
    explicit Compiler(QWidget *parent = 0);
    QVector<ERRORINFO> GetErrorInfoList();
    void MatchToken(Token_Type tt);
    void SyntaxError(Token_Type tt);
    void PrintToken(const ExprNode *, int indent);
    void PrintSyntaxTree(const ExprNode *, int indent);

    void Parser(QString);
    void Program();
    void Statement();
    void ForStatement();
    void OriginStatement();
    void ScaleStatement();
    void RotStatement();
    ExprNode* Expression();
    ExprNode* Term();
    ExprNode* Factor();
    ExprNode* Component();
    ExprNode* Atom();
    ExprNode* MakeExprNode(Token_Type optype, ...);
    void DelExprTree(ExprNode*);
    double GetExprValue(ExprNode*);
    QPoint CalcFinalPoint(ExprNode* HorPtr, ExprNode* VerPtr);
    void DrawLoop(double start, double end, double step, ExprNode* Horptr, ExprNode* VerPtr);
    void ClearData();
    bool JudgeError(){ return hasError;}
};
#endif // COMPILER_H
