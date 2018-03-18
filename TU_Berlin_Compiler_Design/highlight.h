#ifndef HIGHLIGHT_H
#define HIGHLIGHT_H

#include <QSyntaxHighlighter>
#include <QTextCharFormat>

class HighLight : public QSyntaxHighlighter
{
    Q_OBJECT
public:
    explicit HighLight(QTextDocument *parent = 0);

protected:
    void highlightBlock(const QString &text);

signals:

public slots:

private:
    QStringList patterns;
    QTextCharFormat KeyWordFormat;
    QTextCharFormat TypeFormat;
    QTextCharFormat DigitFormat;
    struct HightingRule{
        QRegExp pattern;
        QTextCharFormat myFormat;
    };
    QVector<HightingRule> hightingrules;

};

#endif // HIGHLIGHT_H
