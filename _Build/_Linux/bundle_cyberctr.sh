# Get latest CyberCTR package
# Version: 1.1

#!/bin/bash

# Set working directory default is ~/Documents
WORKDIR=~/Documents

# Set repository url.
GITURI=https://github.com/InternalError503/CyberCTR.git

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

# Set on linux Simplicity Linux as default.
function setHomeStyle(){
      echo "Setting about:home default to (Simplicity linux)"
      sed -i 's|\("extensions.classicthemerestorer.abouthome",\) "\(.*\)"|\1 "simplicitygreen"|' $WORKDIR/CyberCTR/distribution/bundles/CTR@8pecxstudios.com/defaults/preferences/options.js
}

# Set chmod permissons.
function setPerms(){
  echo "Changing chmod of $1 to 777"
  chmod -R 777 $1
}

# Add changing directory information to console.
function changeDirectory(){

  if [ "$1" == ".." ]; then
    echo "Leaving last directory!" 
    cd $1
  else
    echo "Entering $1 directory!" 
    cd $1
  fi  
}

checkGIT
cd $WORKDIR

echo "Do you wish to setup or update CyberCTR source repository now?"
select yn in "Yes" "No"; do
    case $yn in
        Yes )
        if [ -d "CyberCTR" ]; then
          echo "Auto purge uncommited untracked changes"
          changeDirectory "CyberCTR"
          git checkout -- .
          echo "Cloning latest CyberCTR source files"
          git pull
          changeDirectory ".."
          setHomeStyle
          setPerms "CyberCTR"
        else
          echo "Downloading CyberCTR source repository"
          git clone $GITURI
          setHomeStyle
          setPerms "CyberCTR"
        fi; break;;
        No ) break;;
    esac
done

echo "Do you wish to transfer CyberCTR into obj64/dist/cyberfox now?"
select yn in "Yes" "No"; do
    case $yn in
        Yes )
	  if [ -d "$WORKDIR/obj64/dist/Cyberfox/distribution" ]; then
	    echo "Existing distribution folder found!, removing it now!"
	    rm -rv $WORKDIR/obj64/dist/Cyberfox/distribution
	  fi
	  echo "Now transfering CyberCTR to cyberfox folder"
	  cp -r CyberCTR/distribution/ $WORKDIR/obj64/dist/Cyberfox; 
        break;;
        No ) exit;;
    esac
done

echo "Do you wish to package cyberfox archive now?"
select yn in "Yes" "No"; do
    case $yn in
        Yes )
	  changeDirectory "$WORKDIR/obj64/dist"
	  # Get the current filename with browser version!
	  filename=$(basename Cyberfox-*.en-US.linux-x86_64.tar.bz2)
	  
	    if [ -f $filename ]; then
	      echo "Found $filename removing file!"
	      rm -f $filename
	    fi
	  echo "Now re-packaging cyberfox into $filename!"
	  tar cvfj $filename Cyberfox; 
        break;;
        No ) exit;;
    esac
done