#!/bin/bash
# Version: 1.1
# Set working directory default is ~/Documents
WORKDIR=~/Documents
cd $WORKDIR

function buildPacks(){
    cd "$WORKDIR/cyberfox-languagepacks/releases/$1"
    for D in *; do
        if [ -d "${D}" ]; then
            cd "${D}"
            zip -r "$WORKDIR/languagepacks/langpack-${D%.*}@8pecxstudios.com.xpi" *
            cd ..
        fi
    done
}

function copyPacks(){
    cp -r "$WORKDIR/languagepacks/." "$WORKDIR/obj64/dist/bin/browser/features/"
    if [ -d "$WORKDIR/obj64/dist/Cyberfox" ]; then
        cp -r "$WORKDIR/languagepacks/." "$WORKDIR/obj64/dist/Cyberfox/browser/features/"
    fi;
}

if [ ! -d "$WORKDIR/languagepacks" ]; then
    mkdir "$WORKDIR/languagepacks"
    else
    rm -rf "$WORKDIR/languagepacks"
    mkdir "$WORKDIR/languagepacks"
fi;

if [ -d "$WORKDIR/cyberfox-languagepacks" ]; then
    cd "$WORKDIR/cyberfox-languagepacks"
    echo "Pulling repository"
    git pull
    buildPacks $1
    copyPacks
else
    echo "Cloning repository"
    git clone "https://github.com/InternalError503/cyberfox-languagepacks.git"
    buildPacks $1
    copyPacks
fi;

