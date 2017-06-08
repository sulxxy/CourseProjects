#include "highlight.h"
#include <QDebug>

HighLight::HighLight(QTextDocument *parent) :
    QSyntaxHighlighter(parent)
{
    HightingRule rule;
    KeyWordFormat.setForeground(Qt::darkGray);
//    KeyWordFormat.setFontWeight(QFont::Bold);
    patterns << "\\bORIGIN\\b" << "\\bSCALE\\b"
                << "\\bIS\\b" << "\\bROT\\b"
                << "\\bTO\\b" << "\\bFOR\\b"
                << "\\bFROM\\b" << "\\bSTEP\\b"
                << "\\bDRAW\\b" ;
    foreach(QString s, patterns){
        rule.myFormat = KeyWordFormat;
        rule.pattern = QRegExp(s);
        hightingrules.append(rule);
    }

    TypeFormat.setForeground(Qt::red);
    TypeFormat.setFontWeight(QFont::Bold);
    rule.myFormat = TypeFormat;
    rule.pattern = QRegExp("\\bT\\b");
    hightingrules.append(rule);

    DigitFormat.setForeground(Qt::green);
//    DigitFormat.setFontWeight(QFont::Bold);
    rule.myFormat = DigitFormat;
    rule.pattern = QRegExp("\\b[\\d]+\\\.?[\\d]*\\b");
    hightingrules.append(rule);

    rule.pattern = QRegExp("\\bPI\\b");
    hightingrules.append(rule);

    rule.pattern = QRegExp("\\bE\\b");
    hightingrules.append(rule);
}

void HighLight::highlightBlock(const QString &tmp)
{
    QString text = tmp.toUpper();
    foreach(const HightingRule &rule, hightingrules){
        QRegExp expression(rule.pattern);
        int index = expression.indexIn(text);
        while(index >= 0){
            int length = expression.matchedLength();
            setFormat(index, length, rule.myFormat  );
            index = text.indexOf(expression, index + length);
        }
    }

}
