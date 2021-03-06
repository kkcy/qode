#!/bin/sh
set -e

DIRNAME=$(cd `dirname $0` && pwd)

cd $DIRNAME/../../node/out/Release/
rm -rf ./darwin

echo "Post Build: Making Qode portable..."

echo "Choosing Qt from $QT_INSTALL_DIR"

echo "Copying Frameworks"
mkdir -p ./darwin/lib
cp -R "$QT_INSTALL_DIR/lib/QtWidgets.framework" "./darwin/lib/QtWidgets.framework"
cp -R "$QT_INSTALL_DIR/lib/QtGui.framework" "./darwin/lib/QtGui.framework"
cp -R "$QT_INSTALL_DIR/lib/QtCore.framework" "./darwin/lib/QtCore.framework"
cp -R "$QT_INSTALL_DIR/lib/QtDBus.framework" "./darwin/lib/QtDBus.framework"
cp -R "$QT_INSTALL_DIR/lib/QtPrintSupport.framework" "./darwin/lib/QtPrintSupport.framework"
echo "Copying plugins"
mkdir -p ./darwin/plugins
cp -R "$QT_INSTALL_DIR/plugins/iconengines" "./darwin/plugins/iconengines"
cp -R "$QT_INSTALL_DIR/plugins/imageformats" "./darwin/plugins/imageformats"
cp -R "$QT_INSTALL_DIR/plugins/platforms" "./darwin/plugins/platforms"
cp -R "$QT_INSTALL_DIR/plugins/platformthemes" "./darwin/plugins/platformthemes"
cp -R "$QT_INSTALL_DIR/plugins/styles" "./darwin/plugins/styles"
echo "Copying binaries"
mkdir -p ./darwin/bin
cp "$QT_INSTALL_DIR/bin/moc" "./darwin/bin/moc"
cp "$QT_INSTALL_DIR/bin/macdeployqt" "./darwin/bin/macdeployqt"

cp ./qode ./darwin/qode
cd ./darwin
echo "Fixing linked library paths"
install_name_tool -change  "$QT_INSTALL_DIR/lib/QtWidgets.framework/Versions/5/QtWidgets" "@rpath/QtWidgets.framework/Versions/5/QtWidgets" qode
install_name_tool -change  "$QT_INSTALL_DIR/lib/QtCore.framework/Versions/5/QtCore" "@rpath/QtCore.framework/Versions/5/QtCore" qode
install_name_tool -change  "$QT_INSTALL_DIR/lib/QtGui.framework/Versions/5/QtGui" "@rpath/QtGui.framework/Versions/5/QtGui" qode

install_name_tool -add_rpath "@loader_path/lib" qode
install_name_tool -add_rpath "$QT_INSTALL_DIR/lib/" qode
install_name_tool -add_rpath "@executable_path/../Frameworks" qode

echo "Fixing linked library paths for binaries"
echo "[Paths]" > ./bin/qt.conf
echo "Prefix = \"../\"" >> ./bin/qt.conf

echo "Qode is ready!"