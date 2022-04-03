#!/usr/bin/env sh
mkdir -p $INPUT_PKG_DIRECTORIES
mv $INPUT_BIN bin/
mv $INPUT_LIB lib/
mv $INPUT_SHARE share
zip -r $INPUT_PACKAGE_NAME.zip $INPUT_PKG_DIRECTORIES
