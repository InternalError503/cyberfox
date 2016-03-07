# Cyberfox quick build script
# Version: 2.0
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
	echo "Changing chmod of $1 to 777"
	chmod -R 777 $1
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

# Set working directory default is ~/Documents
WORKDIR=~/Documents

# Set repository url.
# Set identity.
# Set local repository direcorty name.
GITURI=""
IDENTITY=""
LDIR=""

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
	  else
	  	if [ ! -z "$GITURI" ]; then
	    echo "Downloading $LDIR source repository"
	    git clone $GITURI
	      	setPerms $LDIR
	    echo "mozconfig does not exist copying pre-configured to $LDIR root"
	    cp -r $WORKDIR/$LDIR/_Build/_Linux/mozconfig $WORKDIR/$LDIR/
			setIdentity $IDENTITY
	      changeDirectory $LDIR
	  else
	  		echo "Sorry, I don't understand your answer!"
			exit 1
	    fi;
	  fi; break;;
        No ) 
		  setIdentity $IDENTITY
		  break;;
	  "Quit" )
			exit 0
		break;;
    esac
done

# Set CyberCTR default start page style.
setHomeStyle $IDENTITY

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
	  if [ -f $WORKDIR/$LDIR/mozconfig ]; then
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
	  if [ -d $WORKDIR/obj64/dist/bin ]; then
	      	changeDirectory $LDIR
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
	  if [ -d $WORKDIR/obj64/dist/bin ]; then
	    	changeDirectory "$WORKDIR/$LDIR"
	    ./mach package

	# Include readme.txt
    cp -r $Dir/README.txt $WORKDIR/obj64/dist/
	  changeDirectory "$WORKDIR/obj64/dist"
	  # Get the current filename with browser version!
	  filename=$(basename Cyberfox-*.en-US.linux-x86_64.tar.bz2)
	  
	    if [ -f $filename ]; then
	      echo "Found $filename removing file!"
	      rm -f $filename
	    fi
	  echo "Now re-packaging Cyberfox into $filename!"
	  tar cvfj $filename Cyberfox README.txt; 

	  else
	    echo "Unable to package $LDIR $WORKDIR/obj64/dist/bin does not exist!"
	  fi; break;;  
        No ) break;;
	  "Quit" )
			exit 0
		break;;
    esac
done