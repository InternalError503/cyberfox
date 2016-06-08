####Setup build environment
Open terminal and use the following command more [information](https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Build_Instructions/Linux_Prerequisites)

```
wget -O bootstrap.py https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py && python bootstrap.py
```

#### Manual Build Instructions:

Note: Using git is much easier then downloading a large archive that sometimes fails or is damaged, It downloads very fast through git.

So what you do is:

In the terminal __if you don't have__ git installed

```sudo apt-get install git```

Next cd to your working directory

Now `clone` the release repository

```git clone https://github.com/InternalError503/cyberfox.git```

Once it has finished downloaded you need to *set the folder permissions*, The reason for this is its inheriting git servers file permissions, In the terminal type

```chmod -R 777 cyberfox```

Then press enter.

Now the permissions have be set to you.

Now setup your `mozconfig` and any addition changes like setting the branding identity color

Once ready `cd` inside the `cyberfox folder` and in the terminal type

```./mach build```

Once compilation is complete just checkout your build and in the terminal type

```./mach run```

Just to test everything runs ok

When ready to finalize the build in the terminal type

```./mach package```

This will package up the build (Note: we don't have any installer like systems for cyberfox on linux but we are looking into it).

The next time you want to *build cyberfox* just `cd` into the source folder then type

```git pull```

This should pull all the new files.

If the repo says you have uncommitted or untracked changes just do

```
git checkout -- .
git pull
```

If the above does not clear any uncommitted or un-tracked changes

```
git checkout -- .
git pull origin master --force
```

You will have to set the mozconfig again if not already present as it should ignore this file and keep any changes you make to it.

If the local git repository wont let you pull the latest due to uncommitted changes or un-tracked files and the above __"git checkout -- ."__ does not resolve the merge conflict
then in terminal type:

```git reset --hard```

This should revert all changes to modified files.

Note: Once you have pulled the latest tree from the git repo you will have to set the permissions again so you need to set the folder permissions,
The reason for this is its inheriting git servers file permissions, if your inside the cyberfox folder in the terminal type:

```cd ..```

This will take you up one directory then in the terminal type

```chmod -R 777 cyberfox```

Then press enter, Now the permissions have be set to you, Now just `cd` back in to `cyberfox directory`

```cd cyberfox```


Once you have done this a few times it gets very quick and easy.
Git is a very easy source code management system with very few commands which is why its so easy to use and very powerful in source control.
For additional information please see this [article](https://8pecxstudios.com/Forums/viewtopic.php?f=5&t=685#p4351)

*Important:* Keep in mind that on Linux everything is case sensitive so if the folder is named cyberfox and your typing Cyberfox you will get an error.

###### Notes: in the cyberfox version 37.0

To set the browser branding identity color for build type specific you need to edit the following file

`cyberfox\build\defines.sh`

its a simple system 1 equals enabled (true) and blank disabled (false) for branding identity only one can be enabled.

So on linux it would look like the following

Linux Release
```ini
# Set the browser branding identity color
IDENTITY_BRANDING_AMD=
IDENTITY_BRANDING_BETA=
IDENTITY_BRANDING_LINUX=1
IDENTITY_BRANDING_LINUX_BETA=
IDENTITY_BRANDING_INTEL=
```

Linux Beta
```ini
# Set the browser branding identity color
IDENTITY_BRANDING_AMD=
IDENTITY_BRANDING_BETA=
IDENTITY_BRANDING_LINUX=
IDENTITY_BRANDING_LINUX_BETA=1
IDENTITY_BRANDING_INTEL=
```

#### Quick Build Instructions:

Here is a quick build script for cyberfox on Linux that will expand over time, This will allow you to automate most of the manual tasks mentioned above.

Script version: *2.2*

```bash
# Cyberfox quick build script
# Version: 2.2
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
	timestamp=$(date +%F_%T)
	configFile=$WORKDIR/$1/toolkit/content/buildconfig.html
	if grep -q -E "__SOURCEURL__|__SOURCEURLNAME__|__HASHSUM__|__GITURL__" "$configFile" ; then  
	  sed -i.$timestamp.bak "s|__SOURCEURL__|$2|" $configFile
	  sed -i "s|__SOURCEURLNAME__|$3|" $configFile
		if testConnection; then
		  echo "Getting HASHSUN information from source code this may take a few minutes depending on internet connection!"	
		  online_sha512=$(curl -s $2 | sha512sum | awk '{print $1}')
		  sed -i "s|__HASHSUM__|$online_sha512|" $configFile
		else
		  sed -i "s|SHA512:__HASHSUM__|Failed to generate SHA512|" $configFile
		fi	
	  sed -i "s|__GITURL__|$4|g" $configFile
	  else
	  	echo "Source code information appears to be generated check if needs updating!"	
	fi
}

# Apply unity patch to locally downloaded repository.
function ApplyUnity(){
    if [ -f $WORKDIR/unity-menubar-$1.patch ]; then		
        git apply $WORKDIR/unity-menubar-$1.patch
        changeDirectory $WORKDIR
        setPerms $LDIR
        UNITY=true
    else
        echo "Unable to find '$WORKDIR/unity-menubar-$1.patch' unity patch skipping unity edition!"
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
UNITY=false

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

echo "Do you wish to apply unity patch?"
VERSON=$(<$WORKDIR/$LDIR/browser/config/version.txt)
select yn in "Yes" "No" "Quit"; do
    case $yn in
        Yes )	  	
		echo "Do you wish to test unity patch?"
		select yn in "Yes" "No"; do
		    case $yn in
		      Yes )
                if [ -f $WORKDIR/unity-menubar-$VERSON.patch ]; then		
                        git apply --check $WORKDIR/unity-menubar-$VERSON.patch
                fi; 
                echo "Do you wish to apply unity patch?"
                select yn in "Yes" "No"; do
                    case $yn in
                        Yes ) 
                            ApplyUnity $VERSON 
                        break;;
                        No ) break;;
                    esac
                done
              break;;
		      No ) 
                  ApplyUnity $VERSON 
              break;;
		    esac
		done
	  break;;
        No ) break;;
	  "Quit" )
			exit 0
		break;;
    esac
done

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
	if [ -f $Dir/README.txt ]; then
    		cp -r $Dir/README.txt $WORKDIR/obj64/dist/
    fi
	  changeDirectory "$WORKDIR/obj64/dist"
           
	  # Get the current filename with browser version!
	  filename=$(basename Cyberfox-*.en-US.linux-x86_64.tar.bz2)
	  
	    if [ -f $filename ]; then
	      echo "Packaging: Found $filename removing file!"
	      rm -f $filename
	    fi
        
	  	# Generate compiled files hashsums (SHA512).  
        echo "Generating file hashes, Please wait!"
        find Cyberfox -type f -print0 | xargs -0 sha512sum  > Cyberfox/SHA512SUMS.chk

        echo "Packaging: Now re-packaging Cyberfox into $filename!"
		if [ -f README.txt ]; then
			echo "Packaging: Adding README into $filename!"
		  	tar cvfj $filename Cyberfox README.txt; 
		else
			echo "Packaging: README not added into $filename!"
			tar cvfj $filename Cyberfox;
		fi
        
	  if $UNITY ; then	
	    echo "Packaging: Renaming unity package!"  	
	  	mv $filename $(echo $filename | sed 's/.tar.bz2/-Unity-Edition.tar.bz2/g');
	  fi;

	  if [ "$IDENTITY" == "Beta" ]; then
	    echo "Packaging: Renaming beta package!"
	    name=$(<$WORKDIR/$LDIR/browser/config/version_display.txt)  	
	  	mv $filename "Cyberfox-$name.en-US.linux-x86_64.beta.tar.bz2";
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
```

What it does is the following

First sets the working directory to "__~/Documents__" by default so if you use a different directory then change it.

To change it

```
WORKDIR=~/Documents
```

simply replace "__~/Documents__" so an example of this is

```
WORKDIR=~/Downloads
```


It then checks if git is install if not it will it will prompt you to install it, You can install it by selecting the option when prompt or not install it and then manually install it
then run the script again.

If git is installed then it checks if the cyberfox repository exist in the __$WORKDIR__ if it does then it will auto purge all changes

Then asks you if you would like to download the latest build files for the first time or download the latest.

It will automatically set the branding identity to Linux so not need to edit that file manually

It will then change the permissions to *777*

Then prompt to build cyberfox
It will check if a existing obj64 directory then prompt if you would like to remove it
__Note:__ This is the default name from our supplied configuration file.
If you don't remove the old build output it will want to do a clobber build you will have to manually do this.

If cyberfox repository does not exist then it will clone the repository in the __$WORKDIR__

It will then change the permissions to *777*

It will automatically set the branding identity to Linux so not need to edit that file manually

Then prompt to build cyberfox
It will check if a existing obj64 directory then prompt if you would like to remove it
__Note:__ This is the default name from our supplied configuration file.
If you don't remove the old build output it will want to do a clobber build you will have to manually do this.

Once cyberfox has been built it will prompt if you would like to package it.
The prompts are numeric so for an example

```
1) Yes
2) No
```

You would type ether __1__ for yes or __2__ for no.

Here is the __build_cyberfox.sh__

When you download this file you can run it form anywhere however you will need to chmod the permissions of the file or it will not allow you to run it.

so you would cd in to the directory its contained in then type

```chmod -R 777 build_cyberfox.sh```

Then your all set.

To use the script just open the terminal then supply the path to it for example

```
~/Desktop/build_cyberfox.sh
```

Note: Don't edit build_cyberfox.sh on windows as windows adds \r or \r\n to line endings to assimilate carriage returns this will just cause error messages in the script or cause it not to work
unless using a good text editor i.e notepad++.