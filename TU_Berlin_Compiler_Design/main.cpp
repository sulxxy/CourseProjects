#include <QApplication>
#include <QTextStream>
#include <QFile>
#include <QDebug>
#include "compiler.h"
#include "ide.h"
//#include "editor.h"
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
//    QFile file("/home/lxxy/scanner.txt");
//    Compiler *C = new Compiler();
//    C->show();
//    C->Parser(s);
    IDE *ide = new IDE;
    ide->showMaximized();
    ide->show();
//    Editor ed;
//    ed.show();
    return a.exec();
}
