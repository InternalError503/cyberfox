# Cyberfox KDE Plasma Edition Installation, Shortcut Desktop, (Optional) Shortcut Menu, Cyberfox KDE Plasma Edition Uninstall
# Version: 1.0
# Release, Beta channels linux

#!/bin/bash

# Set current directory to script directory.
Dir=$(cd "$(dirname "$0")" && pwd)

# Enter current script directory.
cd $Dir

# Count how many packages in the directory, If there is more then one the script may break or have undesired effect.
PackageCount=`ls Cyberfox_KDE_Plasma_Edition-*.tar.bz2 | awk 'END { print NR }'` 

# Make package name editable in single place in the event of file naming change.
Package=$Dir/Cyberfox_KDE_Plasma_Edition-*.tar.bz2

# Desktop shortcut path, Applications shortcut path, Cyberfox install path.
Desktop=~/Desktop/cyberfox.desktop
Applications=/usr/share/applications
InstallDirectory=$HOME/Apps

# Check if the script is in the right place before checking file hashes.
echo "Do you wish to install Cyberfox now?"
select yn in "Install" "Uninstall" "Quit"; do
    case $yn in
        Install )

        # Check if more than 1 package exist.
        if [ $PackageCount -gt 1 ]; then  
            echo "You have to many packages [$PackageCount] in this directory, I am unable to compute what package to install, Please remove the other packages so i no longer get confused!"
            notify-send "A error has occured"
            exit 0 
        fi;


        if [ -f $Dir/Cyberfox_KDE_Plasma_Edition-*.tar.bz2 ]; then
		
            # Make directory if not already exist
            if ! [ -d $InstallDirectory ]; then
                echo "Making $InstallDirectory directory!"
                mkdir $InstallDirectory
            fi
			
            # Navigate in to apps directory
            echo "Entering $InstallDirectory directory"
            cd $InstallDirectory
			
            # Unpack cyberfox in to apps directory, Remove existing cyberfox folder.
            if [ -d $InstallDirectory/Cyberfox ]; then
                echo "Removing older install $InstallDirectory/Cyberfox"
                rm -rvf $InstallDirectory/Cyberfox;
            fi
			
            echo "Unpacking $Package in to $InstallDirectory directory"
            tar xjfv $Package

            # Remove readme.txt it has no place in apps directory.
            if [ -f $InstallDirectory/README.txt ]; then
                rm -rvf $InstallDirectory/README.txt;
            fi

            # Create desktop shortcut
            echo "Generating desktop shortcut"
            echo "[Desktop Entry]" > $Desktop
            echo "Encoding=UTF-8" >> $Desktop
            echo "Name=Cyberfox" >> $Desktop
            echo "Comment=Starts Cyberfox Web Browser" >> $Desktop
            echo "Exec=$InstallDirectory/Cyberfox/Cyberfox" >> $Desktop
            echo "Icon=$InstallDirectory/Cyberfox/browser/icons/mozicon128.png" >> $Desktop
            echo "Terminal=false" >> $Desktop
            echo "X-MuiltpleArgs=false" >> $Desktop
            echo "StartupWMClass=Cyberfox" >> $Desktop
            echo "Type=Application" >> $Desktop
            echo "Categories=Network;WebBrowser;" >> $Desktop
            echo "MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;" >> $Desktop
            chmod +x $Desktop

            # Add KDE Plasma notification integration
            echo "Do you wish to add a KDE Plasma notification integration (Requires root privileges)?"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes )
                        echo "To add a KDE Plasma notification integration, root privileges are required!"
                        echo "Adding KDE Plasma notification integration"
                        # Requires admin permissions to write the file to /usr/share/knotifications5 directory.
                        sudo wget -O /usr/share/knotifications5/kyberfoxhelper.notifyrc  https://raw.githubusercontent.com/hawkeye116477/kyberfoxhelper/master/kyberfoxhelper.notifyrc
                    break;;
                    No ) break;;
                esac
        
            # Clone shortcut to /usr/share/applications for access in menus i.e Mint, Ubuntu search etc
            echo "Do you wish to add a shortcut to your startmenu (Requires root privileges)?"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes )
                        echo "To add a copy of the desktop shortcut to $Applications, root privileges are required!"
                        echo "Generating menu shortcut"
                        # Requires admin permissions to write the file to /usr/share/applications directory.
                        sudo cp $Desktop $Applications
                    break;;
                    No ) break;;
                esac
            done
            echo "Cyberfox is now ready for use!"
            notify-send "Installation Compelete"
        else
            echo "You must place this script next to the 'Cyberfox_KDE_Plasma_Edition' tar.bz2 package."
        fi; break;;
        Uninstall )

            # Navigate in to apps directory
            echo "Entering $InstallDirectory directory"
            cd $InstallDirectory

            # Remove cyberfox installation folder
            if [ -d $InstallDirectory/Cyberfox ]; then
                echo "Removing older install $InstallDirectory/Cyberfox"
                rm -rvf $InstallDirectory/Cyberfox;
            fi

            # Remove cyberfox desktop icon if exists.
            if [ -f $Desktop ]; then
                rm -vf $Desktop;
            fi
			
            # Remove menu icon if exists.
            # Requires admin permissions to write the file to /usr/share/applications directory.
            # This should only prompt if the user installed it, Meaning if the check for the file returns true.
            if [ -f $Applications/cyberfox.desktop ]; then
                sudo rm -vf $Applications/cyberfox.desktop;
            fi
            
            # Remove KDE Plasma notification integration
             if [ -f /usr/share/knotifications5/kyberfoxhelper.notifyrc ]; then
                sudo rm -vf /usr/share/knotifications5/kyberfoxhelper.notifyrc;
            fi
            
			notify-send "Uninstall Complete"
        break;;
	  "Quit" )
            echo "If I’m not back in five minutes, just wait longer."
			exit 0; break;;
    esac
done
