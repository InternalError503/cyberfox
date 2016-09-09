# Cyberfox quick build script
# Version: 2.4
# Release, Beta channels linux

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

# Apply unity patch to locally downloaded repository.
function ApplyUnity(){

	# Download pacth if not exist
	if [ ! -f "$WORKDIR/unity-menubar-$1.patch" ]; then
		# Check url mext release for changes.	
		wget -O $WORKDIR/unity-menubar-$1.patch 'https://bazaar.launchpad.net/~mozillateam/firefox/firefox.trusty/download/head:/unitymenubar.patch-20130215095938-1n6mqqau8tdfqwhg-1/unity-menubar.patch'
	fi

	# Apply patch if exists
    if [ -f "$WORKDIR/unity-menubar-$1.patch" ] && [ ! -f "$WORKDIR/$LDIR/unitylock" ]; then		
        git apply $WORKDIR/unity-menubar-$1.patch
				echo >> "$WORKDIR/$LDIR/unitylock"
        changeDirectory $WORKDIR
        setPerms $LDIR
    else
        echo "Unable to find '$WORKDIR/unity-menubar-$1.patch' unity patch! or patch has already been applied!"
    fi; 
}


# Set working directory default is ~/Documents
WORKDIR=~/Documents

# Set repository url.
# Set identity.
# Set local repository direcorty name.
# Set Unity patch bool.
GITURI=""
IDENTITY=""
LDIR=""
VERSION=""

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

# Set unity patch
if [ "$IDENTITY" == "Release" ]; then
	echo "Applying unity patch"
	ApplyUnity $VERSION
fi

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
	  if [ -d "$WORKDIR/obj64/dist/bin" ]; then
	    	changeDirectory "$WORKDIR/$LDIR"
	    ./mach package

	# Include readme.txt
	if [ -f "$Dir/README.txt" ]; then
    		cp -r $Dir/README.txt $WORKDIR/obj64/dist/
  fi
	  changeDirectory "$WORKDIR/obj64/dist"
           
	  # Get the current filename with browser version!
	  FILENAME=$(basename Cyberfox-*.en-US.linux-x86_64.tar.bz2)
	  
	    if [ -f "$FILENAME" ]; then
	      echo "Packaging: Found $FILENAME removing file!"
	      rm -f $FILENAME
	    fi
        
	  	# Generate compiled files hashsums (SHA512).  
        echo "Generating file hashes, Please wait!"
        find Cyberfox -type f -print0 | xargs -0 sha512sum  > Cyberfox/SHA512SUMS.chk

        echo "Packaging: Now re-packaging Cyberfox into $FILENAME!"
		if [ -f "README.txt" ]; then
			echo "Packaging: Adding README into $FILENAME!"
		  	tar cvfj $FILENAME Cyberfox README.txt; 
		else
			echo "Packaging: README not added into $FILENAME!"
			tar cvfj $FILENAME Cyberfox;
		fi

	  if [ "$IDENTITY" == "Beta" ]; then
	    echo "Packaging: Renaming beta package!"	
	  	mv $FILENAME "Cyberfox-$VERSION.en-US.linux-x86_64.beta.tar.bz2";

		  if [ -f "$WORKDIR/$LDIR/_Build/_Linux/build_deb_package.sh" ]; then
		  		"$WORKDIR/$LDIR/_Build/_Linux/build_deb_package.sh" $GITURI;

				# Get the current deb filename with browser version to rename it!
	  			DEBFILENAME=$(basename Cyberfox-*.en-US.linux-x86_64.deb)
				mv $DEBFILENAME "Cyberfox-$VERSION.en-US.linux-x86_64.beta.deb";
		  fi

	  else

		  if [ -f "$WORKDIR/$LDIR/_Build/_Linux/build_deb_package.sh" ]; then
		  		"$WORKDIR/$LDIR/_Build/_Linux/build_deb_package.sh" $GITURI;
		  fi 

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