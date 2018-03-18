#ifndef IDE_H
#define IDE_H
#include <QPlainTextEdit>
#include <QMainWindow>
#include <QMenuBar>
#include <QLayout>
#include <QDockWidget>
#include <QTableWidget>
#include <QToolBar>
#include "compiler.h"
#include "editor.h"

class IDE : public QMainWindow
{
    Q_OBJECT
private:
    QWidget *CenterWidget;
    QLayout *layout;
    QString curFile;
    QString Code;
//    QMenuBar *menubar;
    QToolBar *toolbar;
    QMenu *FileMenu;
    QMenu *EditMenu;
    QMenu *BuildMenu;
    QMenu *ViewMenu;
//    QMenu *help;
    QAction *OpenAct;
    QAction *NewAct;
    QAction *SaveAct;
    QAction *SaveasAct;
    QAction *CloseFileAct;
    QAction *ExitAct;
    QAction *CutAct;
    QAction *CopyAct;
    QAction *PasteAct;
    QAction *RunAct;

    Compiler *comp;
    Editor *text;
    QPlainTextEdit *GTree;
    QDockWidget *dock;
    QTableWidget *ErrorInfo;


public:
    explicit IDE(QWidget *parent = 0);
    bool MaybeSave();
    void CreateDocks();
    void CreateActions();
    void CreateMenus();
    void CreateToolBar();
    void CreateStatusBar();
    void CreateBasicLayout();
    bool saveFile(const QString &filename);
    void loadFile(const QString &filename);
    void setCurrentFile(const QString &filename);
    void PrintErrorInfo();
    void clearData();

signals:

public slots:
    void open();
    bool save();
    bool saveAs();
    void CloseFile();
    void newFile();
    void documentWasModified();
    void runProgram();
    void DrawGTree(QString , int);

protected:
    void closeEvent(QCloseEvent *);

};

#endif // IDE_H
