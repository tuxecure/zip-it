# README

A GitHub Action for zipping script files in a zip file for easy distribution and installation

## Usage

Customize following example workflow and save as `.github/workflows/zip-it.yml` on your source repository.


```yaml
name: Zipping it

on: [push]

jobs:
  zip-it:
    runs-on: ubuntu-18.04
    steps:
    - uses: actions/checkout@v3
    - uses: tuxecure/zip-it@v1.10
      with:
        prefix: ${HOME}/.local # sets the location where the package script will extract the files to.
        pkg_directories: bin lib share #created bin lib and share for zipping
        bin: crackle rorw remount # goes into $PREFIX/bin
	lib: triplet pkgfunc linkfunc # goes into $PREFIX/lib
	share: crackle # goes into $PREFIX/share in this case also known as $XDG_DATA_HOME
        data_directory: state # goes into $PREFIX/share/crackle in this case also known as $XDG_DATA_HOME/crackle
        owner: tuxecure # name of the repo owner defaults to the current repo owner
        repo_name: crackle # name of the repo defaults to the current repo name
        package_name: crackle # name of the zip defaults to the current repo name
```
