# Get latest CyberCTR package
# Version: 1.0

#!/bin/bash

# Set working directory default is ~/Documents
WORKDIR=~/Documents

command -v git >/dev/null 2>&1 || { 
    echo "I require git but it's not installed would you like to install it now!."
    select yn in "Yes" "No"; do
	case $yn in
	    Yes )
	      xterm -e sudo apt-get install git
	    break;;
	    No ) echo "I require git but it's not installed type 'sudo apt-get install git' to manually install it then run me again!." && exit;;
	esac
    done   
 }

cd $WORKDIR

if [ -d "CyberCTR" ]; then
  echo "Auto purge uncommited untracked changes"
  cd CyberCTR
  git checkout -- .
  echo "Cloning latest CyberCTR source files"
  git pull
  cd ..
  #Need to redo chmod and set permsissions every pull
  echo "Changing chmod of CyberCTR repository to 777"
  chmod -R 777 CyberCTR 
else
  echo "Downloading CyberCTR source repository"
  git clone https://github.com/InternalError503/CyberCTR.git
  echo "Changing chmod of CyberCTR repository to 777"
  chmod -R 777 CyberCTR 
fi

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
	  cd $WORKDIR/obj64/dist
	  
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