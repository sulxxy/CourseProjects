#include "lexical.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QRegExp>
#include <QChar>

Lexical::Lexical()
{
    p = 0;
    linenumberflag = 1;
    s.clear();
    file.clear();
    CC.clear();
}

QString Lexical::InitParser(QString st)
{
    file = st.split("\n");
    DisposeFileStringList();
    GetString(st);
    PreDispose(s);
//    qDebug() << "Lexical::InitParser: The text after predisposed: " << s;
    return s;

}

Token Lexical::GetToken()
{
    int tag = 0;
    if(p < s.length())
        precord = p;
    Token tokens;
    QString temp;
    int TokenFlag;
    QChar c = GetChar(s);
    if((c >= 'A' && c <= 'Z') || (c >= 'a'  && c <= 'z')){
        tag++;
        temp += c;
        TokenFlag = IsToken(temp);
        for(;;){
            if(TokenFlag != -1){
                if(tag == 1){
                    c = GetChar(s);                              //get "T", judge "TO" or "T"
                    GetChar(s, false);
                    if(c != 'O'){
                        return TokenTab[TokenFlag];
                    }
                }
                else{
//                    qDebug() << "Lexical::GetToken Debug: TokenTab[TokenFlag].lexeme" << TokenTab[TokenFlag].lexeme;
                    return TokenTab[TokenFlag];
                }
            }
            c = GetChar(s);
            temp += c;
            tag++;
            if(tag >= s.length() - precord){
                CurrentLineNumber = GetLineNumber();
                tokens.type = ERRTOKEN;
//    qDebug() << "Lexical::GetToken Debug: precord :" << precord;
//                GoBack(flag);
                return tokens;
            }
            TokenFlag = IsToken(temp);
        }
    }
    else if(c >= '0' && c <= '9'){
        while((c >= '0' && c<= '9') || c == '.' ){
            temp += c;
            c = GetChar(s);
        }
        GetChar(s, false);
        tokens.type = CONST_ID;
        tokens.value = temp.toDouble();
//        qDebug() << "Lexical::GetToken Debug: tokens.value:" << tokens.value;
//        qDebug() << "Lexical::GetToken Debug: P:" << p;
        return tokens;
    }
    else if(c == '#'){
        tokens.type = NONTOKEN;
        return tokens;
    }
    else{
        switch (c.toLatin1()) {
        case '(':
            tokens.type = L_BRACKET;
            return tokens;
        case ')':
            tokens.type = R_BRACKET;
            return tokens;
        case ';':
            linenumberflag++;
            tokens.type = SEMICO;
            return tokens;
        case ',':
            tokens.type = COMMA;
            return tokens;
        case '+':
            tokens.type = PLUS;
            return tokens;
        case '-':
            tokens.type = MINUS;
            return tokens;
        case '*':
            c = GetChar(s, false);
            if(c == '*'){
                GetChar(s);
                GetChar(s);                 //keep static var P points to the next unknown  location
                tokens.type = POWER;
                return tokens;
            }
            else{
                GetChar(s);
                tokens.type = MUL;
                return tokens;
            }
        case '/':
            tokens.type = DIV;
            return tokens;
        default:
            CurrentLineNumber = GetLineNumber();
            tokens.type = ERRTOKEN;
            return tokens;
        }
    }
}

void Lexical::GoBack()
{
    int tmp = precord;
    p = precord + 1;
//    qDebug() << "Lexical::Goback Debug: P:" << p;
    while(tmp < s.length() && GetToken().type == ERRTOKEN && p <= s.length()){
        p = ++tmp;
    }
    p = tmp ;
}

int Lexical::IsToken(QString s)
{
//    qDebug() <<  "Lexical::IsToken Debug:" << s;
    for(int i = 0; i < sizeof(TokenTab) / sizeof(TokenTab[0]); i++){
        if(s==TokenTab[i].lexeme){
            return i;
        }
    }
    return -1;
}

QString Lexical::PreDispose(QString& s)
{
    s.chop(1);                                     //delete '\n'
    QRegExp C_Comment("\/\\*[\\w\\W]*\\*\/");
    C_Comment.setMinimal(true);
    s.remove(C_Comment);
    QRegExp Cpp_Comment("\/\/[\\w\\W]*\\n{1,1}");
    Cpp_Comment.setMinimal(true);                            //closest match
    s.remove(Cpp_Comment);
    QRegExp Line_Break("\\n");
    s.remove(Line_Break);
    QRegExp WhiteSpace("\\s");
    s.remove(WhiteSpace);
    s.append("#");
    GetOriginString(s);
    s = s.toUpper();
    return s;

}

QChar Lexical::GetChar(QString s, bool flag)
{
//    qDebug() << "Lexical::GetChar Debug:"  << "p:" << p << "sp:" << s.at(p) << s.length() << flag;
    if(p < s.length()){
        if(flag)
            return s.at(p++);
        else
            return s.at(p--);
    }
    else{
        qDebug() << "GetChar over flow";
        return '@';                                   //a special termintation, magic number -_-///
    }
}

void Lexical::ClearData()
{
    p = 0;
    linenumberflag = 1;
    s.clear();
    file.clear();
    CC.clear();

}

QString Lexical::GetErrorString(int p1, int p2)
{
    QString tmp;
    for(int i = p1 ; i < p2 ; i++)
        tmp += sOrigin.at(i);
//    qDebug() << "Lexical::GetSubString debug:" << tmp;
    return tmp;

}

void Lexical::DisposeFileStringList()
{
    static bool flagCComment = false;
    foreach(QString tmp, file){
        CodeComment c;
        if(tmp.left(2) == "//"){
            c.iscomment = true;
            c.lineString = tmp;
        }
        else if(tmp.left(2) == "/*"){
            c.iscomment = true;
            c.lineString = tmp;
            flagCComment = true;
        }
        else if(tmp.right(2) == "*/"){
            c.iscomment = true;
            c.lineString = tmp;
            flagCComment = false;
        }
        else{
            if(flagCComment){
                c.iscomment = true;
                c.lineString = tmp;
            }
            else{
                c.iscomment = false;
                c.lineString = tmp;
            }
        }
        CC.append(c);
    }

}

int Lexical::GetLineNumber()
{
    int j = 0, i = 1;
    foreach (CodeComment tmp, CC) {
        if(i <= linenumberflag){
            if(tmp.iscomment){
                j++;
            }
            else{
                i++;
                j++;
            }
        }
    }
//    qDebug() << "Lexical::GetLineNumber Debug(): " << j << linenumberflag;
    return j;

}
