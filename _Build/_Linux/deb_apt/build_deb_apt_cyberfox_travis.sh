#!/bin/bash
# Script version: 1.4.3

# Set current directory to script directory.
Dir=$(cd "$(dirname "$0")" && pwd)
cd $Dir

# Init vars
VERSION=""

function finalCleanUp(){
    if [ -d "$Dir/tmp" ]; then
        echo "Clean: $Dir/tmp"
        rm -rf $Dir/tmp
    fi
}

# Create folder where we move our created deb packages
if [ ! -d "$Dir/debs" ]; then 
mkdir $Dir/debs
fi

# Get package version.
if [ ! -d "$Dir/tmp/version" ]; then 
mkdir -p $Dir/tmp/version
cd $Dir/tmp/version
wget https://raw.githubusercontent.com/InternalError503/cyberfox/master/browser/config/version_display.txt
fi

if [ -f "$Dir/tmp/version/version_display.txt" ]; then
    VERSION=$(<$Dir/tmp/version/version_display.txt)
else
    echo "Unable to get current build version!"
    exit 1    
fi


# Generate template directories
if [ ! -d "$Dir/tmp/cyberfox-$VERSION" ]; then 
    mkdir $Dir/tmp/cyberfox-$VERSION
	fi


# Copy deb templates
if [ -d "$Dir/cf/debian" ]; then
	cp -r $Dir/cf/debian/ $Dir/tmp/cyberfox-$VERSION/
else
    echo "Unable to locate ppa templates!"
    exit 1 
fi

# Generate change log template
CHANGELOGDIR=$Dir/tmp/cyberfox-$VERSION/debian/changelog
if grep -q -E "__VERSION__|__CHANGELOG__|__TIMESTAMP__" "$CHANGELOGDIR" ; then
    sed -i "s|__VERSION__|$VERSION|" "$CHANGELOGDIR"

    sed -i "s|__CHANGELOG__|https://cyberfox.8pecxstudios.com/hooray-your-cyberfox-is-up-to-date/?version=$VERSION|" "$CHANGELOGDIR"
    DATE=$(date --rfc-2822)
    sed -i "s|__TIMESTAMP__|$DATE|" "$CHANGELOGDIR"
else
    echo "An error occured when trying to generate $CHANGELOGDIR information!"
    exit 1  
fi

# Copy latest build
	cd $Dir/tmp/cyberfox-$VERSION
	wget https://sourceforge.net/projects/cyberfox/files/Zipped%20Format/Cyberfox-$VERSION.en-US.linux-x86_64.tar.bz2
	tar jxf Cyberfox-$VERSION.en-US.linux-x86_64.tar.bz2
	if [ -d "$Dir/tmp/cyberfox-$VERSION/cyberfox" ]; then
	rm -rf $Dir/tmp/cyberfox-$VERSION/README.txt
	mv $Dir/tmp/cyberfox-$VERSION/cyberfox/browser/features $Dir/tmp/cyberfox-$VERSION
else
    echo "Unable to Cyberfox package files, Please check the build was created and packaged successfully!"
    exit 1     
fi

# Make sure correct permissions are set
chmod 755 $Dir/tmp/cyberfox-$VERSION/debian/cyberfox.prerm
chmod 755 $Dir/tmp/cyberfox-$VERSION/debian/cyberfox.postinst
chmod 755 $Dir/tmp/cyberfox-$VERSION/debian/rules
chmod 755 $Dir/tmp/cyberfox-$VERSION/debian/wrapper/cyberfox

# Linux has hunspell dictionaries, so we can remove Cyberfox dictionaries and make symlink to Linux dictionaries. 
# Thanks to this, we don't have to download dictionary from AMO for our language.
rm -rf $Dir/tmp/cyberfox-$VERSION/cyberfox/dictionaries

# Remove unneeded files
rm -rf $Dir/tmp/cyberfox-$VERSION/cyberfox/SHA512SUMS.chk
rm -rf $Dir/tmp/cyberfox-$VERSION/cyberfox/removed-files

# Build .deb package (Requires devscripts to be installed sudo apt install devscripts).
echo "Building deb package!"
debuild -us -uc -d

if [ -f $Dir/tmp/cyberfox_*_amd64.deb ]; then
    mv $Dir/tmp/*.deb $Dir/debs
else
    echo "Unable to move deb packages the file maybe missing or had errors during creation!"
   exit 1
fi

echo "Deb package for APT repository complete!"
finalCleanUp
