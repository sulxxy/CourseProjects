#ifndef LEXICAL_H
#define LEXICAL_H
#include "L_dsdefine.h"
#include <QString>
#include <QTextStream>
#include <QFile>
#include <cmath>
#include <QVector>
#include <QLinkedList>
#include <QStringList>

class Lexical{
private:
    QString s;
    QString sOrigin;
    int p ;
    int precord;
    QStringList file;
    struct CodeComment{
        bool iscomment;
        QString lineString;
    };
    QVector<CodeComment> CC;
    int linenumberflag;
    int CurrentLineNumber;

signals:

public:
    Lexical();
    QString PreDispose(QString &);
    int IsToken(QString );
    QChar GetChar(QString, bool flag=true);
    void GetString(QString tmp){ s = tmp; }
    void GetOriginString(QString tmp){ sOrigin = tmp;}
    Token GetToken();
    void GoBack();                       //go back while matching an error token
    QString InitParser(QString);
    void ClearData();
    int GetP(){return p;}
    QString GetErrorString(int p1, int p2);
    void DisposeFileStringList();
    int GetLineNumber();
    int GetCurrentLineNumber(){return CurrentLineNumber;}
};
#endif // LEXICAL_H
