#!/usr/bin/env bash
[[ $INPUT_PKG_DIRECTORIES ]] && mkdir -p $INPUT_PKG_DIRECTORIES
[[ -e $INPUT_BIN ]] && mv $INPUT_BIN bin/
[[ -e $INPUT_LIB ]] && mv $INPUT_LIB lib/
[[ -e $INPUT_SHARE ]] && mv $INPUT_SHARE share
if [[ -e $INPUT_DATA_DIRECTORY ]]; then
	mkdir share/${INPUT_PACKAGE_NAME};
	mv $INPUT_DATA_DIRECTORY share/${INPUT_PACKAGE_NAME}
fi
mkdir /tmpdirs
mv $INPUT_PKG_DIRECTORIES /tmpdirs
cd /tmpdirs
while read path
do
        rpath=${path/./${INPUT_PREFIX}}
        sed -i "/rm %prefix%/i\ \ \ \ \ \ \ \ rm $rpath" /zip-it
done < <(find . -type f)

while read path
do
	if [[ ${path/#.\/} != "." && ${path/#.\/} != "bin" && ${path/#.\/} != "lib" && ${path/#.\/} != "share" ]]; then
		rpath=${path/./${INPUT_PREFIX}}
		sed -i "/rm %prefix%/i\ \ \ \ \ \ \ \ rmdir $rpath" /zip-it
	fi
done < <(find . -type d)

sed -i "s|%prefix%|${INPUT_PREFIX}|g" /zip-it;
sed -i "s|%comprefix%|${INPUT_PREFIX}/share/bash-completion/completions|g" /zip-it;
sed -i "s/%owner%/${INPUT_OWNER}/g" /zip-it;
sed -i "s/%package%/${INPUT_PACKAGE_NAME}/g" /zip-it;
cd -
mv /tmpdirs/* .
mv /zip-it ${INPUT_PACKAGE_NAME}
zip -r $INPUT_PACKAGE_NAME.zip $INPUT_PKG_DIRECTORIES ${INPUT_PACKAGE_NAME}
