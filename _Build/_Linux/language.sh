#!/bin/bash
# Version: 1.2
# Set working directory default is ~/Documents
WORKDIR=~/Documents
cd $WORKDIR

# Build language XPI packages
function buildPacks(){
    cd "$WORKDIR/cyberfox-languagepacks/releases/$1"
    for D in *; do
        if [ -d "${D}" ]; then
            cd "${D}"
            zip -r "$WORKDIR/languagepacks/langpack-${D%.*}@8pecxstudios.com.xpi" *
            cd ..
        fi
    done
    # Ensure to removed en-US language pack
    if [ -f "$WORKDIR/languagepacks/langpack-en-US@8pecxstudios.com.xpi" ]; then
        rm -vf "$WORKDIR/languagepacks/langpack-en-US@8pecxstudios.com.xpi"
    fi;
}

# Copy compiled language packages to build output
function copyPacks(){
    cp -r "$WORKDIR/languagepacks/." "$WORKDIR/obj64/dist/bin/browser/features/"
    if [ -d "$WORKDIR/obj64/dist/Cyberfox" ]; then
        cp -r "$WORKDIR/languagepacks/." "$WORKDIR/obj64/dist/Cyberfox/browser/features/"
    fi;
}

# Check if language packs for version exist first
if [ ! -d "$WORKDIR/cyberfox-languagepacks/releases/$1" ]; then
    echo "Error: $WORKDIR/cyberfox-languagepacks/releases/$1 not found"
    exit 0
fi;

# Remove current packs and generate fresh everytime
if [ ! -d "$WORKDIR/languagepacks" ]; then
    mkdir "$WORKDIR/languagepacks"
    else
    rm -rf "$WORKDIR/languagepacks"
    mkdir "$WORKDIR/languagepacks"
fi;

# Pull whole repo or pull latest changes
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

