# Cyberfox KDE Plasma Edition quick build script
# Version: 1.1.1
# Release, Beta channels Linux
# This is only for Cyberfox 52. For Cyberfox 53+ something should be changed...

#!/bin/bash

# Check for git installation.
function checkGIT(){
	command -v git >/dev/null 2>&1 || { 
	    echo "I require git but it's not installed would you like to install it now!."
	    select yn in "Yes" "No"; do
		case $yn in
		    Yes )
		      x-terminal-emulator -e sudo apt-get install git
		    break;;
		    No ) echo "I require git but it's not installed type 'sudo apt-get install git' to manually install it then run me again!." && exit;;
		esac
	    done   
	 }
}

# Set linux branding identity color.
function setIdentity(){
	if [ "$1" == "Release" ]; then
	    echo "Setting branding identity to linux"
	    sed -i "s/\(IDENTITY_BRANDING_INTEL *= *\).*/\1/" $WORKDIR/cyberfox/build/defines.sh
	    sed -i "s/\(IDENTITY_BRANDING_LINUX *= *\).*/\11/" $WORKDIR/cyberfox/build/defines.sh
	    sed -i 's|\(--with-branding *= *\).*|\--with-branding=browser/branding/official-linux|' $WORKDIR/cyberfox/mozconfig
	    echo "Setting branding identity complete!"
	elif [ "$1" == "Beta" ]; then
	    echo "Setting branding identity to Beta"
	    sed -i "s/\(IDENTITY_BRANDING_BETA *= *\).*/\1/" $WORKDIR/cyberfox-beta/build/defines.sh
	    sed -i "s/\(IDENTITY_BRANDING_LINUX_BETA *= *\).*/\11/" $WORKDIR/cyberfox-beta/build/defines.sh
	    sed -i 's|\(--with-branding *= *\).*|\--with-branding=browser/branding/official-linux-beta|' $WORKDIR/cyberfox-beta/mozconfig
	    echo "Setting branding identity complete!"
	else
			echo "Sorry, Failed to process that!"
			exit 1		
	fi;
}

# Set on linux Simplicity Linux as default.
function setHomeStyle(){
	if [ "$1" == "Release" ]; then
      echo "Setting about:home default to (Simplicity linux)"
      sed -i 's|\("extensions.classicthemerestorer.abouthome",\) "\(.*\)"|\1 "simplicitygreen"|' $WORKDIR/cyberfox/browser/extensions/cyberctr/defaults/preferences/options.js
	elif [ "$1" == "Beta" ]; then
      echo "Setting about:home default to (Simplicity linux Beta)"
     sed -i 's|\("extensions.classicthemerestorer.abouthome",\) "\(.*\)"|\1 "simplicitygreen"|' $WORKDIR/cyberfox-beta/browser/extensions/cyberctr/defaults/preferences/options.js     		
	else
			echo "Sorry, Failed to process that!"
			exit 1		
	fi;
}

# Set chmod permissons.
function setPerms(){
	echo "Changing chmod of $1 to 755"
	chmod -R 755 $1
}

# Add changing directory information to console.
function changeDirectory(){

	if [ "$1" == ".." ]; then
		echo "Leaving $(dirname "$0") directory!"	
		cd $1
	else
		echo "Entering $(dirname "$0")/$1 directory!"	
		cd $1
	fi	
}

# Test internet connection
function testConnection(){
	echo "Checking for internet connection!"
	wget -q --tries=10 --timeout=20 --spider https://ftp.mozilla.org
	if [[ $? -eq 0 ]]; then
		# 0 = true
	    return 0 
	else
	    # 1 = false
	    echo "No internet connection found!"
	    return 1
	fi
}

# Generate buildconfig.html source information.
function GenerateBuildInfo(){
	echo "Setting source code information!"
	TIMESTAMP=$(date +%F_%T)
	CONFIGFILE=$WORKDIR/$1/toolkit/content/buildconfig.html
	if grep -q -E "__SOURCEURL__|__SOURCEURLNAME__|__HASHSUM__|__GITURL__" "$CONFIGFILE" ; then  
	  sed -i.$TIMESTAMP.bak "s|__SOURCEURL__|$2|" $CONFIGFILE
	  sed -i "s|__SOURCEURLNAME__|$3|" $CONFIGFILE
		if testConnection; then
		  echo "Getting HASHSUN information from source code this may take a few minutes depending on internet connection!"	
		  ONLINE_SHA512=$(curl -s $2 | sha512sum | awk '{print $1}')
		  sed -i "s|__HASHSUM__|$ONLINE_SHA512|" $CONFIGFILE
			echo "$ONLINE_SHA512" >> "$WORKDIR/$LDIR/sourcesha512"
		else
		  sed -i "s|SHA512:__HASHSUM__|Failed to generate SHA512|" $CONFIGFILE
		fi	
	  sed -i "s|__GITURL__|$4|g" $CONFIGFILE
	  else
	  	echo "Source code information appears to be generated check if needs updating!"	
	fi
}

# Apply KDE Plasma patch to locally downloaded repository.
function ApplyKDE(){

	# Download patch if not exist and replace some words
	if [ ! -f "$WORKDIR/$LDIR/_Build/_Linux/KDE/mozilla-kde-$1.patch" ] && [ ! -f "$WORKDIR/$LDIR/_Build/_Linux/KDE/firefox-kde-$1.patch" ]; then
		# Check url next release for changes.	
			wget -O $WORKDIR/$LDIR/_Build/_Linux/KDE/mozilla-kde-$1.patch 'http://www.rosenauer.org/hg/mozilla/raw-file/firefox52/mozilla-kde.patch'
			wget -O $WORKDIR/$LDIR/_Build/_Linux/KDE/firefox-kde-$1.patch 'http://www.rosenauer.org/hg/mozilla/raw-file/firefox52/firefox-kde.patch'
			sed -i 's/Firefox/Cyberfox/g' $WORKDIR/$LDIR/_Build/_Linux/KDE/mozilla-kde-$1.patch
			sed -i 's/KMOZILLAHELPER/KCYBERFOXHELPER/g' $WORKDIR/$LDIR/_Build/_Linux/KDE/mozilla-kde-$1.patch
			sed -i 's|/usr/lib/mozilla/kmozillahelper|/opt/cyberfox/kcyberfoxhelper|g' $WORKDIR/$LDIR/_Build/_Linux/KDE/mozilla-kde-$1.patch
			sed -i 's/kmozillahelper/kcyberfoxhelper/g' $WORKDIR/$LDIR/_Build/_Linux/KDE/mozilla-kde-$1.patch
			sed -i 's/firefox/cyberfox/g' $WORKDIR/$LDIR/_Build/_Linux/KDE/firefox-kde-$1.patch
	fi

	# Apply patches if exists
    if [  -f "$WORKDIR/$LDIR/_Build/_Linux/KDE/mozilla-kde-$1.patch" ] && [  -f "$WORKDIR/$LDIR/_Build/_Linux/KDE/firefox-kde-$1.patch" ] && [ ! -f "$WORKDIR/$LDIR/KDE_lock" ]; then
        cd $WORKDIR/$LDIR
        patch -Np1 -i $WORKDIR/$LDIR/_Build/_Linux/KDE/mozilla-kde-$1.patch
        patch -Np1 -i $WORKDIR/$LDIR/_Build/_Linux/KDE/firefox-kde-$1.patch
        patch -Np1 -i $WORKDIR/$LDIR/_Build/_Linux/KDE/fix_kde_jar.mn.patch
        patch -Np1 -i $WORKDIR/$LDIR/_Build/_Linux/KDE/fix_browser_kde.xul.patch
        patch -Np1 -i $WORKDIR/$LDIR/_Build/_Linux/KDE/pgo_fix_missing_kdejs.patch
        patch -Np1 -i $WORKDIR/$LDIR/_Build/_Linux/all/fix-wifi-scanner.diff
				echo >> "$WORKDIR/$LDIR/KDE_lock"
        changeDirectory $WORKDIR
        setPerms $LDIR
    else
        echo "Unable to find KDE patches or patches has already been applied!"
    fi; 
}

# Set working directory default is ~/Documents
WORKDIR=~/Documents

# Set repository url.
# Set identity.
# Set local repository directory name.
# Set KDE patch bool.
GITURI=""
IDENTITY=""
LDIR=""
VERSION=""
VERSION_HELPER=""
BUILTLOCALES=false

  echo "What package do you wish to build?"
  select answer in "Release" "Beta" "Quit"; do
      case $answer in
	  "Release" )	  
		    GITURI=https://github.com/InternalError503/cyberfox.git
		    IDENTITY="Release"
		    LDIR="cyberfox"
			break;;  
	  "Beta" )
			GITURI=https://github.com/InternalError503/cyberfox-beta.git
			IDENTITY="Beta"
			LDIR="cyberfox-beta"
			break;;
	  "Quit" )
			exit 0
		break;;
		*)
			echo "Sorry, I don't understand your answer!"
			exit 1
		break;;
      esac
  done

# Get and set base path.
Dir=$(cd "$(dirname "$0")" && pwd)

checkGIT
cd $WORKDIR

echo "Do you wish to setup or update cyberfox source repository now?"
select yn in "Yes" "No" "Quit"; do
    case $yn in
        Yes )	  
	  if [ -d "$LDIR" ]; then
	      changeDirectory $LDIR
	    	echo "Auto purge uncommited untracked changes"
	      git reset --hard
	    	echo "Cloning latest cyberfox source files"
	      git pull
				setIdentity $IDENTITY
	      changeDirectory ".."
	      setPerms $LDIR
	      changeDirectory $LDIR
	  		VERSION=$(<$WORKDIR/$LDIR/browser/config/version.txt)	
		    GenerateBuildInfo $LDIR "https://ftp.mozilla.org/pub/firefox/candidates/$VERSION-candidates/build1/source/firefox-$VERSION.source.tar.xz" "firefox-$VERSION.source.tar.xz" $GITURI
	  else
	  	if [ ! -z "$GITURI" ]; then
	    	echo "Downloading $LDIR source repository"
	    	git clone $GITURI
	      setPerms $LDIR
	    	echo "mozconfig does not exist copying pre-configured to $LDIR root"
	    	cp -r $WORKDIR/$LDIR/_Build/_Linux/mozconfig $WORKDIR/$LDIR/
				setIdentity $IDENTITY
	      changeDirectory $LDIR
	  		VERSION=$(<$WORKDIR/$LDIR/browser/config/version_display.txt)
		    GenerateBuildInfo $LDIR "https://ftp.mozilla.org/pub/firefox/candidates/$VERSION-candidates/build1/source/firefox-$VERSION.source.tar.xz" "firefox-$VERSION.source.tar.xz" $GITURI
	  else
	  		echo "Sorry, I don't understand your answer!"
			exit 1
	    fi;
	  fi; break;;
        No ) 
                    if [ ! -f "$WORKDIR/$LDIR/mozconfig" ]; then
                        echo "mozconfig does not exist copying pre-configured to $LDIR root"
                        cp -r $WORKDIR/$LDIR/_Build/_Linux/mozconfig $WORKDIR/$LDIR/
                    fi;
					setIdentity $IDENTITY
					VERSION=$(<$WORKDIR/$LDIR/browser/config/version_display.txt)
					GenerateBuildInfo $LDIR "https://ftp.mozilla.org/pub/firefox/candidates/$VERSION-candidates/build1/source/firefox-$VERSION.source.tar.xz" "firefox-$VERSION.source.tar.xz" $GITURI
		  break;;
	  "Quit" )
			exit 0
		break;;
    esac
done

# Set CyberCTR default start page style.
setHomeStyle $IDENTITY

# Check if VERSION was set
if [ -z "$VERSION" ] || [ ! -n "$VERSION" ]; then
    echo "VERSION was not set, Setting VERSION now!"
    VERSION=$(<$WORKDIR/$LDIR/browser/config/version_display.txt)
fi

# Set KDE Plasma patches
echo "Applying KDE patches"
ApplyKDE $VERSION $IDENTITY

echo "Do you wish to build $LDIR now?"
select yn in "Yes" "No" "Quit"; do
    case $yn in
        Yes ) 
	  if [ -d $WORKDIR/obj64 ]; then
	    echo "Old ojb64 build output found! would you like to remove it now ?"
	      select yn in "Yes" "No"; do
		  case $yn in
		      Yes ) rm -rvf $WORKDIR/obj64; break;;
		      No ) break;;
		  esac
	      done
	  fi
	  if [ -f "$WORKDIR/$LDIR/mozconfig" ]; then
	    changeDirectory "$WORKDIR/$LDIR"
			./mach build
	  else
		 echo "Were sorry but we can't build $LDIR the mozconfig is missing!" && exit
	  fi; break;;       
        No ) break;;
	  "Quit" )
			exit 0
		break;;
    esac
done

echo "Do you wish to test $LDIR now?"
select yn in "Yes" "No" "Quit"; do
    case $yn in
        Yes )
	  if [ -d "$WORKDIR/obj64/dist/bin" ]; then
	  		# build localization packages
			if [ "$IDENTITY" == "Release" ]; then
				echo "Generating language packs for release"
				"$WORKDIR/$LDIR/_Build/_Linux/language.sh" $VERSION
				BUILTLOCALES=true
			elif [ "$IDENTITY" == "Beta" ]; then
				echo "Generating language packs for beta"
				"$WORKDIR/$LDIR/_Build/_Linux/language.sh" $(<$WORKDIR/$LDIR/browser/config/version.txt)
				BUILTLOCALES=true
			fi;

			# Check if in correct directory if not enter it.
			if [ "$PWD" != "$WORKDIR/$LDIR" ]; then
						changeDirectory $LDIR
			fi
	      ./mach run
	  else
	      echo "Unable to start $LDIR $WORKDIR/obj64/dist/bin does not exist!"
	  fi; break;;
        No ) break;;
	  "Quit" )
			exit 0
		break;;
    esac
done

echo "Do you wish to package $LDIR now?"
select yn in "Yes" "No" "Quit"; do
    case $yn in
        Yes )

	# build localization packages
	if [ "$IDENTITY" == "Release" ] && [ "$BUILTLOCALES" = false ] ; then
		echo "Generating language packs for release"
		"$WORKDIR/$LDIR/_Build/_Linux/language.sh" $VERSION
	elif [ "$IDENTITY" == "Beta" ] && [ "$BUILTLOCALES" = false ] ; then
		echo "Generating language packs for beta"
		"$WORKDIR/$LDIR/_Build/_Linux/language.sh" $(<$WORKDIR/$LDIR/browser/config/version.txt)
	fi;
	
    # Get kcyberfoxhelper version
    if [ ! -d "$WORKDIR/tmp/latest_version.txt" ]; then 
    mkdir $WORKDIR/tmp
    wget -O $WORKDIR/tmp/latest_version.txt 'https://github.com/hawkeye116477/kcyberfoxhelper/raw/master/latest_version.txt'
    fi
    
    if [ -f "$WORKDIR/tmp/latest_version.txt" ]; then
    VERSION_HELPER=$(<$WORKDIR/tmp/latest_version.txt)
else
    echo "Unable to get current helper version!"
    exit 1    
fi

	  if [ -d "$WORKDIR/obj64/dist/bin" ]; then
	    	changeDirectory "$WORKDIR/$LDIR"
	    ./mach package

	
	#Include README_CYBERFOX_KDE.txt
	if [ -f "$WORKDIR/$LDIR/_Build/_Linux/README_CYBERFOX_KDE.txt" ]; then
    		cp -r $WORKDIR/$LDIR/_Build/_Linux/README_CYBERFOX_KDE.txt $WORKDIR/obj64/dist/
    elif [! -f "$WORKDIR/$LDIR/_Build/_Linux/README_CYBERFOX_KDE.txt" ]; then
    echo "README_CYBERFOX_KDE.txt not found. You should include this important file!"
	fi
	

	# Include voucher.bin
	if [ -f "$Dir/voucher.bin" ]; then
			cp -r $Dir/voucher.bin $WORKDIR/obj64/dist/
    		cp -r $Dir/voucher.bin $WORKDIR/obj64/dist/bin/
			cp -r $Dir/voucher.bin $WORKDIR/obj64/dist/cyberfox/
	fi
	
    # Include kcyberfoxhelper
	wget -O $WORKDIR/obj64/dist/cyberfox/kcyberfoxhelper "https://github.com/hawkeye116477/kcyberfoxhelper/releases/download/v$VERSION_HELPER/kcyberfoxhelper"
	chmod +x $WORKDIR/obj64/dist/cyberfox/kcyberfoxhelper
	rm -rf $WORKDIR/tmp/
	
	# Include kde.js
	mkdir -p $WORKDIR/obj64/dist/cyberfox/browser/defaults/preferences/
	cp -R $WORKDIR/$LDIR/_Build/_Linux/KDE/kde.js $WORKDIR/obj64/dist/cyberfox/browser/defaults/preferences/


	  changeDirectory "$WORKDIR/obj64/dist"
           
	  # Get the current filename with browser version!
	  FILENAME=$(basename Cyberfox_KDE_Plasma_Edition-$VERSION.en-US.linux-x86_64.tar.bz2)
	  
	    if [ -f "$FILENAME" ]; then
	      echo "Packaging: Found $FILENAME removing file!"
	      rm -f $FILENAME
	    fi
        
	  	# Generate compiled files hashsums (SHA512).  
        echo "Generating file hashes, Please wait!"
        find cyberfox -type f -print0 | xargs -0 sha512sum  > cyberfox/SHA512SUMS.chk

        echo "Packaging: Now re-packaging Cyberfox into $FILENAME!"
		if [ -f "README_CYBERFOX_KDE.txt" ]; then
			echo "Packaging: Adding README into $FILENAME!"
		  	tar cvfj $FILENAME cyberfox README_CYBERFOX_KDE.txt; 
		else
			echo "Packaging: README not added into $FILENAME!"
			tar cvfj $FILENAME cyberfox;
		fi

	  if [ "$IDENTITY" == "Beta" ]; then
	    echo "Packaging: Renaming beta package!"	
	  	mv $FILENAME "Cyberfox_KDE_Plasma_Edition-$VERSION.en-US.linux-x86_64.beta.tar.bz2";



	  fi

	  else
	    echo "Packaging: Unable to package $LDIR $WORKDIR/obj64/dist/bin does not exist!"
	  fi; break;;  
        No ) break;;
	  "Quit" )
			exit 0
		break;;
    esac
done
