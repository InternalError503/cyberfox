#!/bin/bash

# Set current directory to script directory.
Dir=$(cd "$(dirname "$0")" && pwd)
cd $Dir

# Init vars
VERSION=""

function finalCleanUp(){
    if [ -d "$Dir/tmp" ]; then
        echo "Cleaning temporary dir"
        rm -rf $Dir/tmp
    fi
}

# Generate template directories
if [ ! -d "$Dir/tmp/kyberfoxhelper-$VERSION" ]; then 
    mkdir -p $Dir/tmp/kyberfoxhelper-$VERSION
fi

# Get kyberfoxhelper version
if [ ! -d "$Dir/tmp/version/latest_version.txt" ]; then 
    mkdir $Dir/tmp/version
    wget -O $Dir/tmp/version/latest_version.txt 'https://github.com/hawkeye116477/kyberfoxhelper/raw/master/latest_version.txt'
fi
    
if [ -f "$Dir/tmp/version/latest_version.txt" ]; then
    VERSION=$(<$Dir/tmp/version/latest_version.txt)
else
    echo "Unable to get current helper version!"
    exit 1    
fi

# Copy latest build
wget -O $Dir/tmp/kyberfoxhelper-$VERSION/kyberfoxhelper 'https://github.com/hawkeye116477/kyberfoxhelper/releases/download/v${VERSION}/kyberfoxhelper'
wget -O $Dir/tmp/kyberfoxhelper-$VERSION/kyberfoxhelper.notifyrc 'https://github.com/hawkeye116477/kyberfoxhelper/raw/master/kyberfoxhelper.notifyrc'

# Copy deb templates
if [ -d "$Dir/deb_apt/kyberfoxhelper/debian" ]; then
	cp -r $Dir/deb_apt/kyberfoxhelper/debian/ $Dir/tmp/kyberfoxhelper-$VERSION/
else
    echo "Unable to locate deb templates!"
    exit 1 
fi

# Generate change log template
CHANGELOGDIR=$Dir/tmp/kyberfoxhelper-$VERSION/debian/changelog
if grep -q -E "__VERSION__|__CHANGELOG__|__TIMESTAMP__" "$CHANGELOGDIR" ; then
    sed -i "s|__VERSION__|$VERSION|" "$CHANGELOGDIR"
    DATE=$(date --rfc-2822)
    sed -i "s|__TIMESTAMP__|$DATE|" "$CHANGELOGDIR"

else
    echo "An error occured when trying to generate $CHANGELOGDIR information!"
    exit 1  
fi

# Make sure correct permissions are set
chmod 755 $Dir/tmp/kyberfoxhelper-$VERSION/debian/rules
chmod 777 $Dir/tmp/kyberfoxhelper-$VERSION/kyberfoxhelper

# Build .deb package
notify-send "Building deb package!"
cd ~/waterfox-deb/BUILD/tmp/kyberfoxhelper-$VERSION
debuild -us -uc

if [ -f $Dir/tmp/kyberfoxhelper_*_amd64.deb ]; then
    mv $Dir/tmp/*.deb $Dir/debs
else
    echo "Unable to move deb packages the file maybe missing or had errors during creation!"
   exit 1
fi


notify-send "Deb & PPA complete!"
finalCleanUp
