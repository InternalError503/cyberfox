;Copyright (C) 2004-2010 John T. Haller

;Website: http://PortableApps.com/7-ZipPortable

;This software is OSI Certified Open Source Software.
;OSI Certified is a certification mark of the Open Source Initiative.

;This program is free software; you can redistribute it and/or
;modify it under the terms of the GNU General Public License
;as published by the Free Software Foundation; either version 2
;of the License, or (at your option) any later version.

;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with this program; if not, write to the Free Software
;Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

!define PORTABLEAPPNAME "7-Zip Portable"
!define NAME "7-ZipPortable"
!define APPNAME "7-Zip"
!define VER "1.6.5.0"
!define WEBSITE "PortableApps.com/7-ZipPortable"
!define DEFAULTEXE "7zFM.exe"
!define DEFAULTAPPDIR "7-Zip"
!define DEFAULTSETTINGSPATH "settings"
!define LAUNCHERLANGUAGE "English"

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | PortableApps.com"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "John T. Haller"
VIAddVersionKey FileDescription "${PORTABLEAPPNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${PORTABLEAPPNAME}"
VIAddVersionKey LegalTrademarks "PortableApps.com is a Trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "${NAME}.exe"
;VIAddVersionKey PrivateBuild ""
;VIAddVersionKey SpecialBuild ""

;=== Runtime Switches
CRCCheck On
WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
;(Standard NSIS)
!include LogicLib.nsh
!include Registry.nsh
!include TextFunc.nsh
!insertmacro GetParameters
!include x64.nsh

;(NSIS Plugins)
!include TextReplace.nsh

;(Custom)
!include ReadINIStrWithDefault.nsh
!include ReplaceInFileWithTextReplace.nsh
!include CheckForPlatformSplashDisable.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

Var PROGRAMDIRECTORY
Var SETTINGSDIRECTORY
Var ADDITIONALPARAMETERS
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var INIPATH
Var DISABLESPLASHSCREEN
Var ISDEFAULTDIRECTORY
Var SECONDARYLAUNCH
Var FAILEDTORESTOREKEY
Var MISSINGFILEORPATH
Var APPLANGUAGE


Section "Main"
	;=== Check if already running
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${NAME}2") i .r1 ?e'
	Pop $0
	StrCmp $0 0 CheckForINI
		StrCpy $SECONDARYLAUNCH "true"

	CheckForINI:
	;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\${NAME}.ini" "" NoINI
			StrCpy "$INIPATH" "$EXEDIR"
			Goto ReadINI

	ReadINI:
		;=== Read the parameters from the INI file
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Directory" "App\${DEFAULTAPPDIR}"
		StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "SettingsDirectory" "Data\${DEFAULTSETTINGSPATH}"
		StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\$0"

		;=== Check that the above required parameters are present
		IfErrors NoINI

		${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$INIPATH\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
		${ReadINIStrWithDefault} $PROGRAMEXECUTABLE "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Executable" "${DEFAULTEXE}"
		${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$INIPATH\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"

	;CleanUpAnyErrors:
		;=== Any missing unrequired INI entries will be an empty string, ignore associated errors
		ClearErrors

		;=== Correct PROGRAMEXECUTABLE if blank
		StrCmp $PROGRAMEXECUTABLE "" "" CheckForProgramINI
			StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE}"
			Goto CheckForProgramINI
			
	CheckForProgramINI:
		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE NoProgramEXE

	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy "$ADDITIONALPARAMETERS" ""
		StrCpy "$PROGRAMEXECUTABLE" "${DEFAULTEXE}"
		StrCpy "$DISABLESPLASHSCREEN" "false"

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
			StrCpy "$PROGRAMDIRECTORY" "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy "$SETTINGSDIRECTORY" "$EXEDIR\Data\${DEFAULTSETTINGSPATH}"
			StrCpy "$ISDEFAULTDIRECTORY" "true"
			GoTo FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort
		
	FoundProgramEXE:
		${If} ${RunningX64}
			${If} ${FileExists} "$PROGRAMDIRECTORY64\$PROGRAMEXECUTABLE"
				Rename "$PROGRAMDIRECTORY\Lang" "$PROGRAMDIRECTORY64\Lang"
				StrCpy $PROGRAMDIRECTORY "$PROGRAMDIRECTORY64"
			${EndIf}
		${Else}
			Rename "$PROGRAMDIRECTORY64\Lang" "$PROGRAMDIRECTORY\Lang"
		${EndIf}
	
	;CheckIfAlreadyRunning:
		;=== Check if already running
		StrCmp $SECONDARYLAUNCH "true" CheckForSettings
		FindProcDLL::FindProc "$PROGRAMEXECUTABLE"                 
		StrCmp $R0 "1" WarnAnotherInstance CheckForSettings

	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Abort
	
	CheckForSettings:
		IfFileExists "$SETTINGSDIRECTORY\*.*" SettingsFound
		;=== No settings found
		StrCmp $ISDEFAULTDIRECTORY "true" CopyDefaultSettings
		CreateDirectory $SETTINGSDIRECTORY
		Goto SettingsFound
	
	CopyDefaultSettings:
		CreateDirectory "$EXEDIR\Data"
		CreateDirectory "$EXEDIR\Data\settings"
		CopyFiles /SILENT $EXEDIR\App\DefaultData\settings\*.* $EXEDIR\Data\settings
		GoTo SettingsFound

	SettingsFound:
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
			StrCmp $DISABLESPLASHSCREEN "true" GetPassedParameters
			
			;=== Show the splash screen before processing the files
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"	
			newadvsplash::show /NOUNLOAD 1200 0 0 -1 /L $PLUGINSDIR\splash.jpg

	GetPassedParameters:
		;=== Get any passed parameters
		${GetParameters} $0
		StrCmp "'$0'" "''" "" LaunchProgramParameters

		;=== No parameters
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE"`
		Goto AdditionalParameters

	LaunchProgramParameters:
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" $0`

	AdditionalParameters:
		StrCmp $ADDITIONALPARAMETERS "" RegistryBackup

		;=== Additional Parameters
		StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`

	RegistryBackup:
		StrCmp $SECONDARYLAUNCH "true" LaunchAndExit
		;=== Backup the registry
		${registry::KeyExists} "HKEY_CURRENT_USER\Software\7-zip-BackupBy7-ZipPortable" $R0
		StrCmp $R0 "0" GetAppLanguage
		${registry::KeyExists} "HKEY_CURRENT_USER\Software\7-zip" $R0
		StrCmp $R0 "-1" GetAppLanguage
		${registry::MoveKey} "HKEY_CURRENT_USER\Software\7-zip" "HKEY_CURRENT_USER\Software\7-zip-BackupBy7-ZipPortable" $R0
		Sleep 100
	
	GetAppLanguage:
		ReadEnvStr $APPLANGUAGE "PortableApps.comLanguageCode"
		StrCmp $APPLANGUAGE "" UpdatePaths ;if not set, move on 
		StrCmp $APPLANGUAGE "en-gb" +2
		StrCmp $APPLANGUAGE "en-us" "" GetCurrentLanguage
			StrCpy $APPLANGUAGE "-"
			Goto SetAppLanguage

	GetCurrentLanguage:
		ReadINIStr $0 "$SETTINGSDIRECTORY\7zip_portable.reg" "HKEY_CURRENT_USER\Software\7-zip" "Lang"
		StrCmp `"$APPLANGUAGE"` $0 UpdatePaths ;if the same, move on
		IfFileExists "$PROGRAMDIRECTORY\Lang\$APPLANGUAGE.t*t" SetAppLanguage UpdatePaths

	SetAppLanguage:
		WriteINIStr "$SETTINGSDIRECTORY\7zip_portable.reg" "HKEY_CURRENT_USER\Software\7-zip" `"Lang"` `"$APPLANGUAGE"`

	UpdatePaths:
		StrCpy $2 $EXEDIR 1 ;$2 current drive letter
		ReadINIStr $3 "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDrive"
		StrCmp $3 "" RememberPath
		IfFileExists "$SETTINGSDIRECTORY\7zip_portable.reg" "" RememberPath	
		
		StrCpy $4 $3 1 ;$4 now contains just the drive letter
		StrCpy $1 $3 "" 3 ;$1 now contains the relative path to FM
		StrCpy $0 `"$2:\$1"`
		WriteINIStr "$SETTINGSDIRECTORY\7zip_portable.reg" "HKEY_CURRENT_USER\Software\7-zip\FM" `"Editor"` `$0`			
		${ReplaceInFileU16} "$SETTINGSDIRECTORY\7zip_portable.reg" "$4:\" "$2:\" ;replace drive letter in file
		${Registry::StrToHex} $4 $5 ;$5 now contains the ASCII code for old drive
		${Registry::StrToHex} $2 $6 ;$6 now contains the ASCII code for new drive
		${ReplaceInFileU16} "$SETTINGSDIRECTORY\7zip_portable.reg" "$5,00,3a,00" "$6,00,3a,00" ;replace drive letter in file
			
	RememberPath:
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastDrive" "$2:"

	;RestoreTheKey:
		IfFileExists "$SETTINGSDIRECTORY\7zip_portable.reg" "" LaunchNow
	
		IfFileExists "$WINDIR\system32\reg.exe" "" RestoreTheKey9x
			nsExec::ExecToStack `"$WINDIR\system32\reg.exe" import "$SETTINGSDIRECTORY\7zip_portable.reg"`
			Pop $R0
			StrCmp $R0 '0' LaunchNow ;successfully restored key

	RestoreTheKey9x:
		${registry::RestoreKey} "$SETTINGSDIRECTORY\7zip_portable.reg" $R0
		StrCmp $R0 '0' LaunchNow ;successfully restored key
		StrCpy $FAILEDTORESTOREKEY "true"
	
	LaunchNow:
		Sleep 100
		ExecWait $EXECSTRING
		
	CheckRunning:
		Sleep 1000
		FindProcDLL::FindProc "${DEFAULTEXE}"                  
		StrCmp $R0 "1" CheckRunning
		
		StrCmp $FAILEDTORESTOREKEY "true" SetOriginalKeyBack
		${registry::SaveKey} "HKEY_CURRENT_USER\Software\7-zip" "$SETTINGSDIRECTORY\7zip_portable.reg" "" $0
		Sleep 100
	
	SetOriginalKeyBack:
		${registry::DeleteKey} "HKEY_CURRENT_USER\Software\7-zip" $R0
		Sleep 100
		${registry::KeyExists} "HKEY_CURRENT_USER\Software\7-zip-BackupBy7-ZipPortable" $R0
		StrCmp $R0 "-1" TheEnd
		${registry::MoveKey} "HKEY_CURRENT_USER\Software\7-zip-BackupBy7-ZipPortable" "HKEY_CURRENT_USER\Software\7-zip" $R0
		Sleep 100
		Goto TheEnd
		
	LaunchAndExit:
		Exec $EXECSTRING
	
	TheEnd:
		${registry::Unload}
		newadvsplash::stop /WAIT
SectionEnd