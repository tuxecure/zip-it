#!/usr/bin/env bash
[[ $INPUT_PKG_DIRECTORIES ]] && mkdir -p $INPUT_PKG_DIRECTORIES
sed -i "s|%prefix%|${INPUT_PREFIX}|g" /zip-it;
sed -i "s/%maintainer%/${INPUT_MAINTAINER}/g" /zip-it;
sed -i "s/%package%/${INPUT_PACKAGE_NAME}/g" /zip-it;
[[ -e $INPUT_BIN ]] && mv $INPUT_BIN bin/
[[ -e $INPUT_LIB ]] && mv $INPUT_LIB lib/
[[ -e $INPUT_SHARE ]] && mv $INPUT_SHARE share
if [[ -e $INPUT_DATA_DIRECTORY ]]; then
	mkdir share/${INPUT_PACKAGE_NAME};
	mv $INPUT_DATA_DIRECTORY share/${INPUT_PACKAGE_NAME}
fi
mv /zip-it ${INPUT_PACKAGE_NAME}
zip -r $INPUT_PACKAGE_NAME.zip $INPUT_PKG_DIRECTORIES ${INPUT_PACKAGE_NAME}
