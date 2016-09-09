#!/bin/bash
# Built from template by hawkeye116477
# Full repo https://github.com/hawkeye116477/cyberfox-deb
# Script Version: 1.1
# Set current directory to script directory.
Dir=$(cd "$(dirname "$0")" && pwd)
cd $Dir

# Init vars
VERSION=""
IDENTITY=$1

# Check if IDENTITY was passed to script
if [ -z "$IDENTITY" ] || [ ! -n "$IDENTITY" ]; then
    echo "IDENTITY type must be passed to the script build_deb_and_ppa_package.sh 'IDENTITY'"
    exit 1
fi

function finalCleanUp(){
    if [ -d "$Dir/deb_ppa" ]; then
        echo "Clean: $Dir/deb_ppa"
        rm -rf $Dir/deb_ppa
    fi
}

# Temp while testing
finalCleanUp

# Get package version.
if [ -f "../../browser/config/version_display.txt" ]; then
    VERSION=$(<../../browser/config/version_display.txt)
else
    echo "Unable to get current build version!"
    exit 1    
fi

# Generate template directories
if [ ! -d "$Dir/deb_ppa" ]; then 
    mkdir $Dir/deb_ppa
    mkdir $Dir/deb_ppa/cyberfox-$VERSION
    mkdir $Dir/deb_ppa/cyberfox-$VERSION/debian 
    mkdir $Dir/deb_ppa/cyberfox-$VERSION/usr
    mkdir $Dir/deb_ppa/cyberfox-$VERSION/usr/lib
    mkdir $Dir/deb_ppa/cyberfox-$VERSION/usr/lib/Cyberfox
    mkdir $Dir/deb_ppa/cyberfox-$VERSION/usr/share
    mkdir $Dir/deb_ppa/cyberfox-$VERSION/usr/share/applications
    mkdir $Dir/deb_ppa/cyberfox-$VERSION/usr/share/lintian
    mkdir $Dir/deb_ppa/cyberfox-$VERSION/usr/share/lintian/overrides
    # Create folder where put locales.xpi
    if [ "$IDENTITY" == "Release" ]; then
        mkdir $Dir/deb_ppa/cyberfox-$VERSION/locales
    fi    
fi


# Set current directory to directory of package.
cd $Dir/deb_ppa/cyberfox-$VERSION

# Copy DEB and PPA templates
if [ -d "$Dir/deb_and_ppa_templates/_template" ]; then
	cp -r $Dir/deb_and_ppa_templates/_template/* $Dir/deb_ppa/cyberfox-$VERSION/debian
else
    echo "Unable to locate ppa templates!"
    exit 1 
fi

# Copy control file
if [ "$IDENTITY" == "Release" ]; then
	cp $Dir/deb_and_ppa_templates/control.release $Dir/deb_ppa/cyberfox-$VERSION/debian/control
elif [ "$IDENTITY" == "Beta" ]; then
	cp $Dir/deb_and_ppa_templates/control.beta $Dir/deb_ppa/cyberfox-$VERSION/debian/control
else
    echo "IDENTITY was not set. Unable to copy control file!"
    exit 1 
fi	

# Generate change log template
CHANGELOGDIR=$Dir/deb_ppa/cyberfox-$VERSION/debian/changelog
if grep -q -E "__VERSION__|__CHANGELOG__|__TIMESTAMP__" "$CHANGELOGDIR" ; then
    sed -i "s|__VERSION__|$VERSION|" "$CHANGELOGDIR"

    if [ "$IDENTITY" == "Release" ]; then
        sed -i "s|__CHANGELOG__|https://cyberfox.8pecxstudios.com/hooray-your-cyberfox-is-up-to-date/?version=$VERSION|" "$CHANGELOGDIR"
    elif [ "$IDENTITY" == "Beta" ]; then
        sed -i "s|__CHANGELOG__|https://github.com/InternalError503/cyberfox-beta/releases/tag/$VERSION|" "$CHANGELOGDIR"  
    else
        sed -i "s|__CHANGELOG__|N/A|" "$CHANGELOGDIR"
    fi
    DATE=$(date --rfc-2822)
    sed -i "s|__TIMESTAMP__|$DATE|" "$CHANGELOGDIR"

else
    echo "An error occured when trying to generate $CHANGELOGDIR information!"
    exit 1  
fi


# Copy template for copyright
if [ -f "$Dir/deb_and_ppa_templates/copyright" ]; then
    cp $Dir/deb_and_ppa_templates/copyright $Dir/deb_ppa/cyberfox-$VERSION/debian
else
    echo "Unable to locate copyright template!"
    exit 1 
fi

# Copy latest build
if [ -d "../../../../../obj64/dist/Cyberfox" ]; then
    cp -r ../../../../../obj64/dist/Cyberfox/* $Dir/deb_ppa/cyberfox-$VERSION/usr/lib/Cyberfox
	cp $Dir/deb_and_ppa_templates/cyberfox.desktop $Dir/deb_ppa/cyberfox-$VERSION/usr/share/applications
	cp $Dir/deb_and_ppa_templates/Cyberfox $Dir/deb_ppa/cyberfox-$VERSION/usr/share/lintian/overrides
    cp $Dir/deb_and_ppa_templates/Cyberfox.sh $Dir/deb_ppa/cyberfox-$VERSION
	cp $Dir/deb_and_ppa_templates/vendor-gre.js $Dir/deb_ppa/cyberfox-$VERSION
	cp $Dir/deb_and_ppa_templates/vendor-cyberfox.js $Dir/deb_ppa/cyberfox-$VERSION
else
    echo "Unable to Cyberfox package files, Please check the build was created and packaged successfully!"
    exit 1     
fi

# Copy language packs. Copy .xpi to $Dir/deb_ppa/cyberfox-$VERSION/locales. Need to add commands here.
if [ ! "$IDENTITY" == "Release" ]; then
    # ToDo: Pull latest applicable language packs when release package, Don't package for beta.
    rm -f $Dir/deb_ppa/cyberfox-$VERSION/debian/cyberfox-locale-pl.install
fi

# Make sure correct permissions are set
chmod  755 $Dir/deb_ppa/cyberfox-$VERSION/debian/control
chmod  755 $Dir/deb_ppa/cyberfox-$VERSION/debian/cyberfox.prerm
chmod  755 $Dir/deb_ppa/cyberfox-$VERSION/debian/cyberfox.postinst
chmod  755 $Dir/deb_ppa/cyberfox-$VERSION/debian/copyright
chmod  755 $Dir/deb_ppa/cyberfox-$VERSION/debian/rules

# Make symlinks
ln -s /usr/lib/Cyberfox/Cyberfox.sh $Dir/deb_ppa/cyberfox-$VERSION/cyberfox
ln -s /usr/lib/Cyberfox/browser/icons/mozicon128.png $Dir/deb_ppa/cyberfox-$VERSION/Cyberfox.png

# Linux has hunspell dictionaries, so we can remove Cyberfox dictionaries and make symlink to Linux dictionaries. 
# Thanks to this, we don't have to download dictionary from AMO for our language.
rm -rf $Dir/deb_ppa/cyberfox-$VERSION/usr/lib/Cyberfox/dictionaries
ln -s /usr/share/hunspell $Dir/deb_ppa/cyberfox-$VERSION/usr/lib/Cyberfox/dictionaries

# Build .deb package (Requires devscripts to be installed sudo apt install devscripts)
notify-send "Building deb package!"
debuild -us -uc #throws error
if [ -f "$Dir/deb_ppa/cyberfox_$VERSION_amd64.deb" ]; then
    cp $Dir/deb_ppa/cyberfox_$VERSION_amd64.deb ../../../obj64/dist/Cyberfox-$VERSION.en-US.linux-x86_64.deb
else
    echo "Unable to move $Dir/deb_ppa/cyberfox_$VERSION_amd64.deb the file maybe missing or had errors during creation!"
    exit 1
fi

exit 1 #Just exit here until above builds correctly.@
# Build package for upload to PPA (Requires devscripts to be installed sudo apt install devscripts)
notify-send "Building package for upload to PPA"
debuild -S -sa

# Upload package to cyberfox PPA
cd $Dir/deb_and_ppa
if [ "$IDENTITY" == "Release" ]; then
    notify-send "Uploading package to PPA"
    dput ppa:8pecxstudios/cyberfox cyberfox-$VERSION-0~ppa1.source.changes
elif [ "$IDENTITY" == "Beta" ]; then
    notify-send "Uploading package to PPA"
    dput ppa:8pecxstudios/cyberfox-next cyberfox-$VERSION-0~ppa1.source.changes
else
    echo "IDENTITY was not set unable to push package!"
    exit 1 
fi

# Clean up
notify-send "Deb & PPA complete!"
finalCleanUp
