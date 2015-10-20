TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# deployment of qml files to target for mklauncher use:

EXP_DIR = $$system("find * -maxdepth 0 -type d")

target.path = /home/machinekit/projects/$$TARGET
toupload.path = /home/machinekit/projects/$$TARGET

toupload.files = $$EXP_DIR/*.*

INSTALLS += target toupload

