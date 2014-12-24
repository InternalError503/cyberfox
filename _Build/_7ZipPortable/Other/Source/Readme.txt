7-Zip Portable Launcher 1.2.2.0
===============================
Copyright 2004-2006 John T. Haller

Website: http://PortableApps.com/7-ZipPortable

This software is OSI Certified Open Source Software.
OSI Certified is a certification mark of the Open Source Initiative.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


ABOUT 7-Zip PORTABLE
======================
The 7-Zip Portable Launcher allows you to run 7-Zip from a removable drive whose letter changes as you move it to another computer.  The file archiver and the settings can be entirely self-contained on the drive and then used on any Windows computer.


LICENSE
=======
This code is released under the GPL.  Within the 7-ZipPortableSource directory you will find the code (7-ZipPortable.nsi) as well as the full GPL license (License.txt).  If you use the launcher or code in your own product, please give proper and prominent attribution.


INSTALLATION / DIRECTORY STRUCTURE
==================================
By default, the program expects one of these directory structures:

-\ <--- Directory with 7-ZipPortable.exe
	+\App\
	    +\7-Zip\
	+\Data\
		+\settings\

OR

-\ <--- Directory with 7-ZipPortable.exe
	+\7-ZipPortable\
		+\App\
			+\7-Zip\
		+\Data\
			+\settings\

OR

-\ <--- Directory with 7-ZipPortable.exe
	+\PortableApps\
		+\7-ZipPortable\
			+\App\
				+\7-Zip\
			+\Data\
				+\settings\

OR

-\ <--- Directory with 7-ZipPortable.exe (PortableApps, for instance)
	+\Apps\
		+\7-ZipPortable\
			+\7-Zip\
	+\Data\
		+\7-ZipPortable\
			+\settings\


It can be used in other directory configurations by including the 7-ZipPortable.ini file in the same directory as 7-ZipPortable.exe and configuring it as details in the INI file section below.  The INI file may also be placed in a subdirectory of the directory containing 7-ZipPortable.exe called 7-ZipPortable or 2 directories deep in PortableApps\7-ZipPortable or Data\7-ZipPortable.  All paths in the INI should remain relative to the EXE and not the INI.


7-ZipPortable.INI CONFIGURATION
=================================
The 7-Zip Portable Launcher will look for an ini file called 7-ZipPortable.ini within its directory (see the paragraph above in the Installation/Directory Structure section).  If you are happy with the default options, it is not necessary, though.  There is an example INI included with this package to get you started.  The INI file is formatted as follows:

[7-ZipPortable]
7-ZipDirectory=App\7-Zip
SettingsDirectory=Data\settings
7-ZipExecutable=7zFM.exe
AdditionalParameters=
DisableSplashScreen=false


The 7-ZipDirectory and SettingsDirectory entries should be set to the *relative* path to the directories containing 7-Zip.exe and your settings from the current directory.  All must be a subdirectory (or multiple subdirectories) of the directory containing 7-ZipPortable.exe.  The default entries for these are described in the installation section above.

The SettingsFile entry is the name of your 7-Zip settings file within the SettingsDirectory.

The 7-ZipExecutable entry allows you to give an alternate filename for the 7-Zip executable.

The AdditionalParameters entry allows you to specify additional parameters to be passed to 7-Zip on the command line.

The DisableSplashScreen entry allows you to run the 7-Zip Portable Launcher without the splash screen showing up.  The default is false.


PROGRAM HISTORY / ABOUT THE AUTHORS
===================================
This launcher is loosely based on the Firefox Portable launcher, which contains methods suggested by mai9 and tracon of the mozillaZine.org forums.