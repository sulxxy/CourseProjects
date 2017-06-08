#-------------------------------------------------
#
# Project created by QtCreator 2014-11-18T21:55:54
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

QMAKE_CXXFLAGS += -std=c++11

TARGET = Draw_Compiler
TEMPLATE = app


SOURCES += main.cpp\
    lexical.cpp \
    compiler.cpp \
    ide.cpp \
    editor.cpp \
    highlight.cpp

HEADERS  += \
    lexical.h \
    compiler.h \
    L_dsdefine.h \
    Com_dsdefine.h \
    ide.h \
    editor.h \
    highlight.h

RESOURCES += \
    images.qrc
