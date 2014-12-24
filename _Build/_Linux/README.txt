Setup build environment
Open terminal and use teh following comand more informaiton https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Build_Instructions/Linux_Prerequisites
wget -O bootstrap.py https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py && python bootstrap.py

Extract the source archive in the root of the source folder copy the following file.

mozconfig

Now copy and paste the following configuration the source code folder.
Note: This config file uses the official-linux branding folder this branding folder is designed for Linux builds only this branding addresses a few bugs, From 33.0.3+

Now CD to the source directory and type ./mach build
It should now compile successfully.

Once your build is complete in the console type ./mach run this will launch the build to check everything is working.

Next head to the source folder and in the _Build folder in the _AboutHome simply open ether the light or dark folder (Choose the one you prefer) and copy its contents,
Next navigate to obj64/dist/bin/browser/chrome/browser/content/browser/abouthome and paste the files in, This will add the style to the default start-up page.

Next when ready type in the current console ./mach package
This will package the build and output a tar.bz2 in the obj64/dist/bin folder this is cyberfox you can take this file
and extract it in a safe location then create a shortcut to cyberfox

If you want cyberCTR then head to the source folder and in the _Build folder in the _CyberCTR copy the distribution folder to where you have placed cyberfox and place it in side cyberfox root executable folder (On windows this is where cyberfox.exe is).