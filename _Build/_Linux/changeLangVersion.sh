#!/bin/bash
# Version: 1.0
# Set working directory default is ~/Documents
WORKDIR=~/Documents
cd $WORKDIR

function updatePackVersion(){
    cd "$WORKDIR/cyberfox-languagepacks/releases/$2"
    for D in *; do
        if [ -d "${D}" ]; then
            cd "${D}"
            sed -i "s|$2|$1|" "$WORKDIR/cyberfox-languagepacks/releases/$2/${D}/install.rdf"
            cd ..
        fi
    done
}

updatePackVersion $1 $2