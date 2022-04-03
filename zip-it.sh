#!/usr/bin/env sh
set -x
mkdir -p $INPUT_PKG_DIRECTORIES
mv $INPUT_BIN bin/
echo $INPUT_LIB;
[ -n $INPUT_LIB ] && mv $INPUT_LIB lib/
[ -n $INPUT_SHARE ] && mv $INPUT_SHARE share
zip -r $INPUT_PACKAGE_NAME.zip $INPUT_PKG_DIRECTORIES
