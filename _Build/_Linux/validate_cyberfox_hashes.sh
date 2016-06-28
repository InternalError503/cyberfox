# Cyberfox build validation script
# Version: 1.0
# Release, Beta channels linux

# Set current directory to script directory.
Dir=$(cd "$(dirname "$0")" && pwd)

# Enter current script directory.
cd $Dir

# Check if the script is in the right place before checking file hashes.
echo "Do you wish to validate Cyberfox file hashes now?"
select yn in "Yes" "No" "Quit"; do
    case $yn in
        Yes )        
        if [ -d $Dir/Cyberfox ]; then
            echo "Now check file hashes please wait!"
            echo "The file SHA512SUMS.chk will fail the check, This is ok, All other files however should pass."
            sha512sum -c $Dir/Cyberfox/SHA512SUMS.chk
        else
            echo "You must place this script outside or next to the 'Cyberfox' folder."
        fi; 
        exit 0
        break;;
        No ) break;;
	  "Quit" )
            echo "If I’m not back in five minutes, just wait longer."
			exit 0
		break;;
    esac
done

# Generate file hashes, If asked by support you may need to generate file hashes of your cyberfox installation.
echo "Do you wish to generate Cyberfox file hashes now?"
select yn in "Yes" "No" "Quit"; do
    case $yn in
        Yes )        
        if [ -d $Dir/Cyberfox ]; then
            # Generate compiled files hashsums (SHA512).  
            echo "Generating file hashes, Please wait!"
            find Cyberfox -type f -print0 | xargs -0 sha512sum > $Dir/SHA512SUMS.chk
            echo "Your newly created file hashes can be found $Dir/SHA512SUMS.chk"        
        else
            echo "You must place this script outside or next to the 'Cyberfox' folder."
        fi; break;;
        No ) break;;
	  "Quit" )
            echo "If I’m not back in five minutes, just wait longer."
			exit 0
		break;;
    esac
done   