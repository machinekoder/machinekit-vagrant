#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive
export DISPLAY=:0

query-package () {
    dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

CORES=`nproc`
# Install Qt SDK to ~/Qt
ARCH=`uname -m`
if [ "$ARCH" == "x86_64" ]; then 
   HOST=linux-x64
elif [ "$ARCH" == "i686" ]; then
   HOST=linux-x86
else
   echo "unsupported CPU architecture"
   exit 1
fi

export DISPLAY=:0
QT_BASE_VERSION=5.6
QT_VERSION=5.6.0

cd /home/vagrant/
QT_INSTALL=1
if [ -e ./Qt/components.xml ]; then
    echo "Qt already installed"
    cd Qt
    VERSION=`grep '<ApplicationVersion' components.xml | cut -f2 -d">"|cut -f1 -d"<"`
    if [ $VERSION == $QT_VERSION ]; then
        echo "Qt version up to date"
        QT_INSTALL=0
    else
        echo "Update Qt version"
        echo -e "Remove all components to prepare Qt update" > qt-uninstall-instructions.txt
        bash -c "sleep 1; leafpad qt-uninstall-instructions.txt; rm qt-uninstall-instructions.txt" &
        ./MaintenanceTool
        rm -r -f ~/Qt
        # remove qt-creator source
        rm -r -f ~/bin/qt-creator
    fi
fi

if [ $QT_INSTALL -eq 1 ]; then
    echo "Downloading Qt Open-Source installer"
    wget http://download.qt.io/official_releases/qt/$QT_BASE_VERSION/$QT_VERSION/qt-opensource-linux-x64-$QT_VERSION.run -nv
    chmod +x qt-opensource-linux-x64-$QT_VERSION.run
    echo -e "Qt install instructions" > qt-install-instructions.txt
    echo -e "-----------------------\n" >> qt-install-instructions.txt
    echo -e "Change Qt install path to /home/vagrant/Qt" >> qt-install-instructions.txt
    echo -e "Do not change the component selection" >> qt-install-instructions.txt
    echo -e "Accept the license agreement" >> qt-install-instructions.txt
    echo -e "Install Qt" >> qt-install-instructions.txt
    echo -e "Do not launch Qt Creator\n" >> qt-install-instructions.txt
    bash -c "sleep 1; leafpad qt-install-instructions.txt; rm qt-install-instructions.txt" &
    ./qt-opensource-linux-x64-$QT_VERSION.run
    rm qt-opensource-linux-x64-$QT_VERSION.run

    # copy config file
    mkdir -p ~/.config/QtProject/
    cp ~/provision/files/QtCreator.ini ~/.config/QtProject/QtCreator.ini

    cd Desktop
    echo -e "[Desktop Entry]" > qt-creator.desktop
    echo -e "Comment[en_US]=" >> qt-creator.desktop
    echo -e "Exec=/home/vagrant/Qt/Tools/QtCreator/bin/qtcreator" >> qt-creator.desktop
    echo -e "Icon=/home/vagrant/Qt/Tools/QtCreator/share" >> qt-creator.desktop
    echo -e "Name=Qt Creator" >> qt-creator.desktop
    echo -e "StartupNotify=true" >> qt-creator.desktop
    echo -e "Terminal=false" >> qt-creator.desktop
    echo -e "Type=Application\n" >> qt-creator.desktop
    cd ..

    # download Qt Creator source
    mkdir -p /home/vagrant/bin
    cd /home/vagrant/bin
    QTC=~/Qt/Tools/QtCreator/bin/qtcreator
    QTCVERSION=`$QTC -version 2>&1 >/dev/null | grep 'Qt Creator' | grep 'based on' | head -c 16 | tail -c 5`
    QTCVERSION2=`echo $QTCVERSION | head -c 3`
    wget https://download.qt.io/official_releases/qtcreator/$QTCVERSION2/$QTCVERSION/qt-creator-opensource-src-$QTCVERSION.tar.gz -nv
    tar xfz qt-creator*.tar.gz
    rm qt-creator*.tar.gz
    mv qt-creator*src* qt-creator
    #wget https://download.qt.io/official_releases/qtcreator/$QTCVERSION2/$QTCVERSION/qt-creator-opensource-linux-x86_64-$QTCVERSION.run
fi

QMAKE=~/Qt/5.*/gcc*/bin/qmake
QT_INSTALL_PREFIX=~/Qt/5.*/gcc*

cd ~

if [ -e repos/QtQuickVcp ]; then
    cd repos/QtQuickVcp
    git pull --rebase
    cd ..
else
    mkdir -p repos
    cd repos
    # download and install QtQuickVcp
    git clone https://github.com/strahlex/QtQuickVcp
    mkdir -p build/QtQuickVcp
fi

cd build/QtQuickVcp

$QMAKE ../../QtQuickVcp
make -j $CORES
make docs
make install
make install_docs

cd ~
if [ -e repos/MachinekitSDK ]; then
    cd repos/MachinekitSDK
    git pull --rebase
    cd ..
else
    # download and build MachinekitSDK
    cd repos
    git clone https://github.com/strahlex/MachinekitSDK
    mkdir -p build/MachinekitSDK
fi

cd MachinekitSDK
./install.sh ~/Qt/
cd ..

# cd build/MachinekitSDK
# $QMAKE ../../MachinekitSDK
# make -j $CORES
# make install

#notify-send "Enable Qbs and BBIOConfig plugins in Qt Creator and set up Machinekit target"
