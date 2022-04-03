#!/usr/bin/env sh
mkdir -p $INPUT_PKG_DIRECTORIES
sed -i "s/%package%/${INPUT_PACKAGE_NAME}/g" /zip-it;
mv /zip-it ${INPUT_PACKAGE_NAME}|| exit 1;
mv $INPUT_BIN bin/
[ $INPUT_LIB != "" ] && mv $INPUT_LIB lib/
[ $INPUT_SHARE != "" ] && mv $INPUT_SHARE share
zip -r $INPUT_PACKAGE_NAME.zip $INPUT_PKG_DIRECTORIES ${INPUT_PACKAGE_NAME} /crackle.conf
