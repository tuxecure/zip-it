#!/bin/sh
set -e
PREFIX="${PREFIX:-/}"
TARGET_PATH="./"

# thanks to github magic, we declare variables in the actions.yml file
# which then turn into ${INPUT_thename} in the environment here

mkdir -p "${INPUT_PKG_DIRECTORIES?:"The directories to be zipped was not set"}"

# checking for mandatory flags (can technically be empty, but not null)
: "${INPUT_OWNER?"There was no owner specified"}"  # authorship
: "${INPUT_REPO_NAME?"There was no repository name specified"}"  # used for tracking the source of the program
: "${INPUT_PKGREL?"There was no package release specified"}"  # the version number
: "${INPUT_PKG_DIRECTORIES?"There was no package directories specified"}"  # an array of files to be included in the zip
: "${INPUT_PACKAGE_NAME?"There was no package name specified"}"  # used for the zipname and stuff


# moving all the input directories into the prefixed locations
[ -e "${INPUT_BIN}" ] && mv -t "${PREFIX}/bin/" "${INPUT_BIN}"
[ -e "${INPUT_LIB}" ] && mv -t "${PREFIX}/lib/" "${INPUT_LIB}"
[ -e "${INPUT_SHARE}" ] && mv -t "${PREFIX}/share/" "${INPUT_SHARE}"
if [ -e "${INPUT_CONFIG}" ]; then
	mkdir -p "${PREFIX}/config/${INPUT_PACKAGE_NAME}"
	mv -t "${PREFIX}/config/${INPUT_PACKAGE_NAME}" "${INPUT_CONFIG}"
fi

# uh
if [ -e "${INPUT_DATA_DIRECTORY}" ]; then
	mkdir -p "${PREFIX}/share/${INPUT_PACKAGE_NAME}"
	mv -t "share/${INPUT_PACKAGE_NAME}" "${INPUT_DATA_DIRECTORY}"
fi

# let's make a place we can pollute, and work there instead
TMPDIR="$(mktemp -d -p "${PREFIX}")"
mv -t "${TMPDIR}" "${INPUT_PKG_DIRECTORIES}"
pushd "${TMPDIR}"

# go through all the files in the project, and replace prefixes
while read path; do
	rpath=${path/./${INPUT_PREFIX}}
	sed -i "/rm @prefix@/i\ \ \ \ \ \ \ \ rm $rpath" "${PREFIX}/zip-it"
done < <(find . -type f)

# go through all the directories in the project, and replace more prefixes
while read path; do
	if $(printf "${path/#.\/}" | grep -x -q -E 'bin|lib|share'); then
		rpath=${path/./${INPUT_PREFIX}}
		sed -i \
			-e "/rm @prefix@/i\ \ \ \ \ \ \ \ rmdir -p --ignore-fail-on-non-empty $rpath" \
			"${PREFIX}/zip-it"
	fi
done < <(find . -type d | tac)

sed -i \
	-e "s|@prefix@|${INPUT_PREFIX}|g" \
	-e "s|@comprefix@|${INPUT_PREFIX}/share/bash-completion/completions|g" \
	-e "s/@owner@/${INPUT_OWNER}/g" \
	-e "s/@repo@/${INPUT_REPO_NAME}/g" \
	-e "s/@package@/${INPUT_PACKAGE_NAME}/g" \
	-e "s/@pkgrel@/${INPUT_PKGREL}/g" \
	"${PREFIX}/zip-it"

# don't disturb the user
popd

# after having done work, we move everything back here
mv -t . "${TMPDIR}"/*
mv -t "${INPUT_PACKAGE_NAME}" "${PREFIX}/zip-it"

# zip it up, ready to deliver
zip -r "${INPUT_PACKAGE_NAME}.zip" "${INPUT_PKG_DIRECTORIES}" "${INPUT_PACKAGE_NAME}"

