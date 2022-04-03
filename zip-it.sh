#!/usr/bin/env sh
mkdir -p $INPUT_PKG_DIRECTORIES
mv $INPUT_BIN bin/
[ $INPUT_LIB != "" ] && mv $INPUT_LIB lib/
[ $INPUT_SHARE != "" ] && mv $INPUT_SHARE share
zip -r $INPUT_PACKAGE_NAME.zip $INPUT_PKG_DIRECTORIES
