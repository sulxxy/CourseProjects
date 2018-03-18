#include "ide.h"
#include <QTextStream>
#include <QAction>
#include <QMessageBox>
#include <QFile>
#include <QFileDialog>
#include <QStyle>
#include <QDebug>
#include <QStatusBar>
#include <QHeaderView>

IDE::IDE(QWidget *parent) :
    QMainWindow(parent)
{
    CenterWidget = new QWidget(this);
    toolbar = new QToolBar(this);
    CreateBasicLayout();

    connect(text->document(), SIGNAL(contentsChanged()), this, SLOT(documentWasModified()));
    setCurrentFile("");

    connect(comp, SIGNAL(GTreeInfo(QString,int)), this, SLOT(DrawGTree(QString, int)));

}

bool IDE::MaybeSave()
{
    if(text->document()->isModified()){
        QMessageBox::StandardButton ret;
        ret = QMessageBox::warning(this,
                                   tr("warning"),
                                   tr("The text is modified, save or not?"),
                                   QMessageBox::Save | QMessageBox::Cancel | QMessageBox::Discard);
        if(ret == QMessageBox::Save){
            return save();
        }
        else if(ret == QMessageBox::Cancel){
            return false;
        }
    }
    return true;
}

void IDE::CreateDocks()
{
    dock  = new QDockWidget(tr("graphic"), this);
    dock->setAllowedAreas(Qt::LeftDockWidgetArea | Qt::RightDockWidgetArea);
    comp = new Compiler(dock);
    dock->setWidget(comp);
    addDockWidget(Qt::RightDockWidgetArea, dock);
    dock->setFixedSize(500, 500);
    ViewMenu->addAction(dock->toggleViewAction());

    dock = new QDockWidget(tr("GTree"), this);
    dock->setAllowedAreas(Qt::RightDockWidgetArea | Qt::RightDockWidgetArea);
    GTree = new QPlainTextEdit(dock);
    dock->setWidget(GTree);
    addDockWidget(Qt::RightDockWidgetArea, dock);
    dock->setFixedWidth(500);
    ViewMenu->addAction(dock->toggleViewAction());

    dock = new QDockWidget(tr("Error Infomation"), this);
    ErrorInfo = new QTableWidget(dock);
    ErrorInfo->setColumnCount(2);
    ErrorInfo->setHorizontalHeaderLabels(QStringList() << tr("Line") << tr("Detail"));
    ErrorInfo->horizontalHeader()->setStretchLastSection(true);
    ErrorInfo->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ErrorInfo->setSelectionMode(QAbstractItemView::SingleSelection);
    ErrorInfo->setSelectionBehavior(QAbstractItemView::SelectRows);
    dock->setFixedHeight(300);
    dock->setWidget(ErrorInfo);
    ViewMenu->addAction(dock->toggleViewAction());
}

void IDE::CreateActions()
{
    OpenAct = new QAction(QIcon(":/images/open.png"), tr("&open..."), this);
    connect(OpenAct, SIGNAL(triggered()), this,SLOT(open()));

    NewAct = new QAction(QIcon(":/images/new.png"), tr("&new"), this);
    connect(NewAct, SIGNAL(triggered()), this, SLOT(newFile()));

    SaveAct = new QAction(QIcon(":/images/save.png"), tr("&save"), this);
    connect(SaveAct, SIGNAL(triggered()), this, SLOT(save()));

    SaveasAct = new QAction(tr("Save &As..."), this);
    connect(SaveasAct, SIGNAL(triggered()), this, SLOT(saveAs()));

    CloseFileAct = new QAction(QIcon(":/images/close.png"), tr("&Close"), this);
    connect(CloseFileAct, SIGNAL(triggered()), this, SLOT(CloseFile()));

    ExitAct = new QAction(tr("E&xit"), this);
    connect(ExitAct, SIGNAL(triggered()), this, SLOT(close()));

    CutAct = new QAction(QIcon(":/images/cut.png"), tr("&Cut"), this);
    CutAct->setDisabled(true);
    connect(text, SIGNAL(copyAvailable(bool)), CutAct, SLOT(setEnabled(bool)));
    connect(CutAct, SIGNAL(triggered()), text, SLOT(cut()));

    CopyAct = new QAction(QIcon(":/images/copy.png"), tr("&Copy"), this);
    CopyAct->setDisabled(true);
    connect(text, SIGNAL(copyAvailable(bool)), CopyAct, SLOT(setEnabled(bool)));
    connect(CopyAct, SIGNAL(triggered()), text, SLOT(copy()));

    PasteAct = new QAction(QIcon(":/images/paste.png"), tr("&Paste"), this);
    connect(PasteAct, SIGNAL(triggered()), text, SLOT(paste()));

    RunAct = new QAction(style()->standardIcon(QStyle::SP_MediaPlay), tr("&Run"), this);
    connect(RunAct, SIGNAL(triggered()), this, SLOT(runProgram()));

}

void IDE::CreateMenus()
{
    FileMenu = menuBar()->addMenu(tr("&File"));
    FileMenu->addAction(NewAct);
    FileMenu->addAction(OpenAct);
    FileMenu->addAction(SaveAct);
    FileMenu->addAction(SaveasAct);
    FileMenu->addSeparator();
    FileMenu->addAction(CloseFileAct);
    FileMenu->addAction(ExitAct);

    EditMenu = menuBar()->addMenu((tr("&Edit")));
    EditMenu->addAction(CutAct);
    EditMenu->addAction(CopyAct);
    EditMenu->addAction(PasteAct);

    BuildMenu = menuBar()->addMenu(tr("&Build"));
    BuildMenu->addAction(RunAct);

    ViewMenu = menuBar()->addMenu(tr("&View"));

}

void IDE::CreateToolBar()
{
    toolbar = addToolBar(tr("File"));
    toolbar->addAction(NewAct);
    toolbar->addAction(OpenAct);
    toolbar->addAction(SaveAct);

    toolbar->addSeparator();

    toolbar->addAction(CutAct);
    toolbar->addAction(CopyAct);
    toolbar->addAction(PasteAct);

    toolbar->addSeparator();

    toolbar->addAction(RunAct);
    toolbar->addAction(CloseFileAct);

}

void IDE::CreateStatusBar()
{
    statusBar()->showMessage("ready");

}

void IDE::CreateBasicLayout()
{
    text = new Editor(this);
    setCentralWidget(CenterWidget);
    CreateActions();
    CreateMenus();
    CreateToolBar();
    CreateStatusBar();
    CreateDocks();
    layout = new QVBoxLayout(this);
    layout->addWidget(text);
    layout->addWidget(dock);
    CenterWidget->setLayout(layout);
}

void IDE::DrawGTree(QString s, int indent)
{
    if(!comp->JudgeError()){
        QString tmp;
        for(int i = 0; i < indent; i++){
            tmp.append("#");
        }
        tmp.append(s);
        GTree->appendPlainText(tmp);
    }
}

void IDE::runProgram()
{
    clearData();
    save();
    Code = text->toPlainText();
    Code.append('\n');
    comp->show();
    comp->Parser(Code);
    PrintErrorInfo();
    comp->update();
}

void IDE::closeEvent(QCloseEvent *event)
{
    if(MaybeSave()){
        event->accept();
    }
    else{
        event->ignore();
    }
}

void IDE::newFile()
{
    if(MaybeSave()){
        text->clear();
        setCurrentFile("");
    }
}

bool IDE::saveFile(const QString &filename)
{
    QFile file(filename);
    if(!file.open(QFile::WriteOnly | QFile::Text)){
        QMessageBox::warning(this,
                             tr("warning"),
                             tr("Cannot write %1:\n%2.")
                             .arg(filename)
                             .arg(file.errorString()));
        return false;
    }
    QTextStream out(&file);
    out << text->toPlainText();
    setCurrentFile(filename);
    return true;
}

void IDE::loadFile(const QString &filename)
{
    QFile file(filename);
    if(!file.open(QFile::ReadOnly | QFile::Text)){
        QMessageBox::warning(this,
                             tr("warning"),
                             tr("Cannot read file %1: %2\n")
                             .arg(filename)
                             .arg(file.errorString()));
        return ;
    }
    QTextStream in(&file);
    text->setPlainText(in.readAll());
    setCurrentFile(filename);
}

void IDE::CloseFile()
{
    text->clear();
    clearData();
}

void IDE::setCurrentFile(const QString &filename)
{
    curFile = filename;
    text->document()->setModified(false);
    setWindowModified(false);
    QString showname = curFile;
    if(showname.isEmpty()){
        showname = "untitled.txt";
    }
    setWindowFilePath(showname);
}

void IDE::PrintErrorInfo()
{
    if(comp->GetErrorInfoList().isEmpty()){
        ErrorInfo->insertRow(0);
        QTableWidgetItem *item0 = new QTableWidgetItem;
        QTableWidgetItem *item1 = new QTableWidgetItem;
        item0->setText(QString::number(0));
        item1->setText("Run Successfully");
        ErrorInfo->setItem(0, 0, item0);
        ErrorInfo->setItem(0, 1, item1);
        return ;
    }
    for(int j = 0; j < comp->GetErrorInfoList().size(); j++){
        ErrorInfo->insertRow(j);
        ERRORINFO tmp = comp->GetErrorInfoList().at(j);
//        qDebug() << "IDE::PrintErrorInfo Debug:" << tmp.errString;
        QTableWidgetItem *item0 = new QTableWidgetItem;
        QTableWidgetItem *item1 = new QTableWidgetItem;
        item0->setText(QString::number(tmp.line));
        switch(tmp.errorType){
        case 0:
            item1->setText("Unknown token: " + tmp.errString);
            break;
        case 1:
            item1->setText("Improper token: " + tmp.errString);
        }
//        item1->setText(tmp.errString);
        ErrorInfo->setItem(j, 0, item0);
        ErrorInfo->setItem(j, 1, item1);
    }
    return ;
}

void IDE::clearData()
{
    GTree->clear();
    comp->ClearData();
    comp->update();
    ErrorInfo->clearContents();
    while(ErrorInfo->rowCount() > 0){
        ErrorInfo->removeRow(ErrorInfo->rowCount() - 1);
    }
}

void IDE::open()
{
    if(MaybeSave()){
        QString filename = 	QFileDialog::getOpenFileName(this);
        if(!filename.isEmpty()){
            loadFile(filename);
        }
    }

}

bool IDE::save()
{
   if(curFile.isEmpty()){
       return saveAs();
   }
   else{
       return saveFile(curFile);
   }

}

bool IDE::saveAs()
{
   QString filename = QFileDialog::getOpenFileName(this);
   if(filename.isEmpty()){
       return false;
   }
   else{
       return saveFile(filename);
   }
}

void IDE::documentWasModified()
{
    setWindowModified(text->document()->isModified());
}


