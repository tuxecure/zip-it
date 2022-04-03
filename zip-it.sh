#!/usr/bin/env sh
mkdir -p $INPUT_PKG_DIRECTORIES
sed -i "s/%package%/${INPUT_PACKAGE_NAME}/g" /zip-it;
set -x
sed -i "s/%prefix%/${INPUT_PREFIX}/g" /crackle.conf;
sed -i "s/%package%/${INPUT_PACKAGE_NAME}/g" /crackle.conf;
sed -i "s/%maintainer%/${INPUT_MAINTAINER}}/g" /crackle.conf;
mv /zip-it ${INPUT_PACKAGE_NAME}|| exit 1;
mv $INPUT_BIN bin/
[ $INPUT_LIB != "" ] && mv $INPUT_LIB lib/
[ $INPUT_SHARE != "" ] && mv $INPUT_SHARE share
set +x
zip -r $INPUT_PACKAGE_NAME.zip $INPUT_PKG_DIRECTORIES ${INPUT_PACKAGE_NAME} /crackle.conf
