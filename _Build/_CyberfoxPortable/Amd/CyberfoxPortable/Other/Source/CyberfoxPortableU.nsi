;Copyright 2004-2014 John T. Haller of PortableApps.com

;Website: http://PortableApps.com/FirefoxPortable

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

;Code modified by 8pecxstudios.com for cyberfox project.

;Include check for win64.txt file used to define or undefined 64bit builds.
!include CheckFile.nsh
;Define x64 bit builds comment out for x86
${!IfExist} "win64.txt"
!define ISWIN64
!endif

!ifdef ISWIN64
	!define PORTABLEAPPNAME "Cyberfox, Portable Edition"
!else
	!define PORTABLEAPPNAME "Cyberfox, Portable Edition (x86)"
!endif

!define APPNAME "Cyberfox"
!define NAME "CyberfoxPortable"
!include "..\..\..\..\shared\version.nsh"
!define WEBSITE "https://8pecxstudios.com/"
!define DEFAULTEXE "cyberfox.exe"
!define DEFAULTAPPDIR "cyberfox"
!define LAUNCHERLANGUAGE "English"
!define VENDOR "8pecxstudios"

;=== Program Details
Name "${PORTABLEAPPNAME}"
OutFile "..\..\${NAME}.exe"
Caption "${PORTABLEAPPNAME} | ${VENDOR}"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${PORTABLEAPPNAME}"
VIAddVersionKey Comments "Allows ${APPNAME} to be run from a removable USB drive.  For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "${VENDOR}"
VIAddVersionKey LegalCopyright "${VENDOR}"
VIAddVersionKey FileDescription "${PORTABLEAPPNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${PORTABLEAPPNAME}"

!ifdef ISWIN64
	VIAddVersionKey LegalTrademarks "Firefox source code is a Registered Trademark of The Mozilla Foundation.  ${APPNAME} Portable is designed and developed by ${VENDOR}."
!else
	VIAddVersionKey LegalTrademarks "Firefox source code is a Registered Trademark of The Mozilla Foundation.  ${APPNAME} Portable (x86) is designed and developed by ${VENDOR}."
!endif
VIAddVersionKey OriginalFilename "${DEFAULTEXE}"

;=== Runtime Switches
CRCCheck On
WindowIcon Off
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user
XPStyle on

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
;(Standard NSIS)
!include FileFunc.nsh
!insertmacro GetParameters ;Requires NSIS 2.40 or better
!include LogicLib.nsh
!include Registry.nsh
!include TextFunc.nsh
!insertmacro GetParent
!include WordFunc.nsh
!insertmacro VersionCompare

;(NSIS Plugins)
!include TextReplace.nsh

;(Custom)
!include CheckForPlatformSplashDisable.nsh
!include ReplaceInFileWithTextReplace.nsh
!include ReadINIStrWithDefault.nsh
!include SetFileAttributesDirectoryNormal.nsh

;=== Program Icon
Icon "..\..\App\AppInfo\appicon.ico"

;=== Icon & Stye ===
BrandingText "${VENDOR}®"

;=== Languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\${LAUNCHERLANGUAGE}.nlf"
!include PortableApps.comLauncherLANG_${LAUNCHERLANGUAGE}.nsh

;=== Variables
Var PROGRAMDIRECTORY
Var PROFILEDIRECTORY
Var ORIGINALPROFILEDIRECTORY
Var SETTINGSDIRECTORY
Var PLUGINSDIRECTORY
Var ADDITIONALPARAMETERS
Var ALLOWMULTIPLEINSTANCES
Var SKIPCOMPREGFIX
Var EXECSTRING
Var PROGRAMEXECUTABLE
Var INIPATH
Var DISABLESPLASHSCREEN
Var DISABLEINTELLIGENTSTART
Var LOCALHOMEPAGE
Var ISDEFAULTDIRECTORY
Var RUNLOCALLY
Var WAITFORPROGRAM
Var LASTPROFILEDIRECTORY
Var APPDATAPATH
Var SECONDARYLAUNCH
Var MOZILLAORGKEYEXISTS
Var HKLMMOZILLAORGKEYEXISTS
Var MISSINGFILEORPATH
Var CRASHREPORTSDIREXISTS
Var EXTENSIONSDIREXISTS
Var bolHKCUSoftwareMozillaFirefoxCrashReporterExists
Var bolHKCUSoftwareMozillaFirefoxExists
Var bolHKCUSoftwareMozillaExists
Var SubmitCrashReportBackup

Section "Main"
	;=== Setup variables
	ReadEnvStr $APPDATAPATH "APPDATA"

	;=== Find the INI file, if there is one
		IfFileExists "$EXEDIR\${NAME}.ini" "" NoINI
			StrCpy "$INIPATH" "$EXEDIR"

		;=== Read the parameters from the INI file
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Directory" "App\${DEFAULTAPPDIR}"
		StrCpy $PROGRAMDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "ProfileDirectory" "Data\profile"
		StrCpy $PROFILEDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "SettingsDirectory" "Data\settings"
		StrCpy $SETTINGSDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $0 "$INIPATH\${NAME}.ini" "${NAME}" "PluginsDirectory" "Data\plugins"
		StrCpy $PLUGINSDIRECTORY "$EXEDIR\$0"
		${ReadINIStrWithDefault} $ADDITIONALPARAMETERS "$INIPATH\${NAME}.ini" "${NAME}" "AdditionalParameters" ""
		${ReadINIStrWithDefault} $ALLOWMULTIPLEINSTANCES "$INIPATH\${NAME}.ini" "${NAME}" "AllowMultipleInstances" "false"
		${ReadINIStrWithDefault} $SKIPCOMPREGFIX "$INIPATH\${NAME}.ini" "${NAME}" "SkipCompregFix" "false"
		${ReadINIStrWithDefault} $PROGRAMEXECUTABLE "$INIPATH\${NAME}.ini" "${NAME}" "${APPNAME}Executable" "${DEFAULTEXE}"
		${ReadINIStrWithDefault} $WAITFORPROGRAM "$INIPATH\${NAME}.ini" "${NAME}" "WaitFor${APPNAME}" "false"
		${ReadINIStrWithDefault} $DISABLESPLASHSCREEN "$INIPATH\${NAME}.ini" "${NAME}" "DisableSplashScreen" "false"
		${ReadINIStrWithDefault} $DISABLEINTELLIGENTSTART "$INIPATH\${NAME}.ini" "${NAME}" "DisableIntelligentStart" "false"
		${ReadINIStrWithDefault} $LOCALHOMEPAGE "$INIPATH\${NAME}.ini" "${NAME}" "LocalHomepage" ""
		${ReadINIStrWithDefault} $RUNLOCALLY "$INIPATH\${NAME}.ini" "${NAME}" "RunLocally" "false"
		StrCmp $RUNLOCALLY "true" "" CheckIfDefaultDirectories
			StrCpy $WAITFORPROGRAM "true"

	CheckIfDefaultDirectories:
		;=== Check if default directories
		StrCmp $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}" "" EndINI
		StrCmp $PROFILEDIRECTORY "$EXEDIR\Data\profile" "" EndINI
		StrCmp $PLUGINSDIRECTORY "$EXEDIR\Data\plugins" "" EndINI
		StrCmp $SETTINGSDIRECTORY "$EXEDIR\Data\settings" "" EndINI
		StrCpy $ISDEFAULTDIRECTORY "true"
	
	EndINI:
		IfFileExists "$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" FoundProgramEXE NoProgramEXE

	NoINI:
		;=== No INI file, so we'll use the defaults
		StrCpy $ADDITIONALPARAMETERS ""
		StrCpy $ALLOWMULTIPLEINSTANCES "false"
		StrCpy $SKIPCOMPREGFIX "false"
		StrCpy $WAITFORPROGRAM "false"
		StrCpy $PROGRAMEXECUTABLE "${DEFAULTEXE}"
		StrCpy $DISABLESPLASHSCREEN "false"
		StrCpy $DISABLEINTELLIGENTSTART "false"

		IfFileExists "$EXEDIR\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" CheckPortableProgramDIR
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\App\${DEFAULTAPPDIR}"
			StrCpy $PROFILEDIRECTORY "$EXEDIR\Data\profile"
			StrCpy $PLUGINSDIRECTORY "$EXEDIR\Data\plugins"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\Data\settings"
			StrCpy $ISDEFAULTDIRECTORY "true"
			Goto FoundProgramEXE
	
	CheckPortableProgramDIR:
			IfFileExists "$EXEDIR\${NAME}\App\${DEFAULTAPPDIR}\${DEFAULTEXE}" "" NoProgramEXE
			StrCpy $PROGRAMDIRECTORY "$EXEDIR\${NAME}\App\${DEFAULTAPPDIR}"
			StrCpy $PROFILEDIRECTORY "$EXEDIR\${NAME}\Data\profile"
			StrCpy $PLUGINSDIRECTORY "$EXEDIR\${NAME}\Data\plugins"
			StrCpy $SETTINGSDIRECTORY "$EXEDIR\${NAME}\Data\settings"
			Goto FoundProgramEXE

	NoProgramEXE:
		;=== Program executable not where expected
		StrCpy $MISSINGFILEORPATH $PROGRAMEXECUTABLE
		MessageBox MB_OK|MB_ICONEXCLAMATION `$(LauncherFileNotFound)`
		Abort

	FoundProgramEXE:
		StrCpy $ORIGINALPROFILEDIRECTORY $PROFILEDIRECTORY
		
		IfFileExists "$APPDATA\${VENDOR}\${APPNAME}\*.*" CheckUserRegistryKey
			StrCpy $WAITFORPROGRAM "true"
		CheckUserRegistryKey:
			${registry::KeyExists} "HKCU\Software\${VENDOR}" $R0			
			StrCmp $R0 "-1" CheckMachineRegistryKey ;=== If it doesn't exist, skip the next line
			StrCpy $MOZILLAORGKEYEXISTS "true"
		CheckMachineRegistryKey:
			${registry::KeyExists} "HKLM\Software\${VENDOR}" $R0			
			StrCmp $R0 "-1" CheckOtherKeys ;=== If it doesn't exist, skip the next line
			StrCpy $HKLMMOZILLAORGKEYEXISTS "true"
		CheckOtherKeys:
			${registry::KeyExists} "HKCU\Software\${VENDOR}" $R0			
			${If} $R0 != "-1"
				StrCpy $bolHKCUSoftwareMozillaExists true
				${registry::KeyExists} "HKCU\Software\${VENDOR}\${APPNAME}" $R0			
				${If} $R0 != "-1"
					StrCpy $bolHKCUSoftwareMozillaFirefoxExists true
					${registry::KeyExists} "HKCU\Software\${VENDOR}\${APPNAME}\Crash Reporter" $R0				
					${If} $R0 != "-1"
						StrCpy $bolHKCUSoftwareMozillaFirefoxCrashReporterExists true
						${registry::Read} "HKCU\Software\${VENDOR}\${APPNAME}\Crash Reporter" "SubmitCrashReport" $SubmitCrashReportBackup $R2					
					${EndIf}
				${EndIf}	
			${EndIf}

	;CheckIfRunning:
		;=== Check if running
		StrCmp $ALLOWMULTIPLEINSTANCES "true" ProfileWork
!ifdef ISWIN64		
		FindProcDLL64::FindProc "${DEFAULTEXE}"
!else
		FindProcDLL86::FindProc "${DEFAULTEXE}"
!endif		
		StrCmp $R0 "1" "" CheckForCrashReports
			;=== Already running, check if it is using the portable profile
			IfFileExists "$PROFILEDIRECTORY\parent.lock" "" WarnAnotherInstance
				StrCpy $SECONDARYLAUNCH "true"
				Goto RunProgram

	WarnAnotherInstance:
		MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherAlreadyRunning)`
		Abort
	
	CheckForCrashReports:
		IfFileExists "$APPDATA\${VENDOR}\${APPNAME}\Crash Reports\*.*" "" CheckForExtensionsDirectory
			Rename "$APPDATA\${VENDOR}\${APPNAME}\Crash Reports" "$APPDATA\${VENDOR}\${APPNAME}\Crash Reports-BackupBy${NAME}"
			StrCpy $CRASHREPORTSDIREXISTS "true"
			StrCpy $WAITFORPROGRAM "true"

	CheckForExtensionsDirectory:
		IfFileExists "$APPDATA\${VENDOR}\Extensions\*.*" "" ProfileWork
			Rename "$APPDATA\${VENDOR}\Extensions" "$APPDATA\${VENDOR}\Extensions-BackupBy${NAME}"		
			StrCpy $EXTENSIONSDIREXISTS "true"
			StrCpy $WAITFORPROGRAM "true"
	
	ProfileWork:
		;=== Check for an existing profile
		IfFileExists "$PROFILEDIRECTORY\prefs.js" ProfileFound
			;=== No profile was found
			StrCmp $ISDEFAULTDIRECTORY "true" CopyDefaultProfile CreateProfile
	
	CopyDefaultProfile:
		CreateDirectory "$EXEDIR\Data"
		CreateDirectory "$EXEDIR\Data\plugins"
		CreateDirectory "$EXEDIR\Data\profile"
		CreateDirectory "$EXEDIR\Data\settings"
		CopyFiles /SILENT $EXEDIR\App\DefaultData\plugins\*.* $EXEDIR\Data\plugins
		CopyFiles /SILENT $EXEDIR\App\DefaultData\profile\*.* $EXEDIR\Data\profile
		CopyFiles /SILENT $EXEDIR\App\DefaultData\settings\*.* $EXEDIR\Data\settings
		GoTo ProfileFound
	
	CreateProfile:
		IfFileExists "$PROFILEDIRECTORY\*.*" ProfileFound
		CreateDirectory "$PROFILEDIRECTORY"

	ProfileFound:
		IfFileExists "$SETTINGSDIRECTORY\${NAME}Settings.ini" SettingsFound
			CreateDirectory "$SETTINGSDIRECTORY"
			FileOpen $R0 "$SETTINGSDIRECTORY\${NAME}Settings.ini" w
			FileClose $R0
			WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastProfileDirectory" "NONE"

	SettingsFound:
		${ReadINIStrWithDefault} $R0 "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "SubmitCrashReport" ""
		${If} $R0 != ""
			${registry::Write} "HKCU\Software\${VENDOR}\${APPNAME}\Crash Reporter" "SubmitCrashReport" "$R0" "REG_DWORD" $R1
		${EndIf}
		
		${ReadINIStrWithDefault} $R0 "$EXEDIR\App\AppInfo\appinfo.ini" "Installer" "Run" "true"
		
		${If} $R0 == "false"
		${OrIf} ${FileExists} "$EXEDIR\LupoApp.ini"
			;Upgrade or install sans the PortableApps.com Installer which can cause compatibility issues
			${ReadINIStrWithDefault} $0 "$EXEDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion" "0.0.0.0"
			${ReadINIStrWithDefault} $1 "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "InvalidPackageWarningShown" "0.0.0.0"
			${VersionCompare} $0 $1 $2
			${If} $2 == 1
			${OrIf} $R0 == "false"
				MessageBox MB_OK|MB_ICONEXCLAMATION `Warning: ${PORTABLEAPPNAME} was installed or upgraded without using the official PortableApps.com Installer which can cause compatibility issues and may be a violation of the application's license. You may encounter issues while using this application. Please visit PortableApps.com to obtain the official release of this application to install or upgrade.`
				WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "InvalidPackageWarningShown" $0
				DeleteINISec "$EXEDIR\App\AppInfo\appinfo.ini" "Installer"
			${EndIf}
		${EndIf}
	
	
		;=== Check for read/write
		StrCmp $RUNLOCALLY "true" DisplaySplash
		ClearErrors
		FileOpen $R0 "$PROFILEDIRECTORY\writetest.temp" w
		IfErrors "" WriteSuccessful
			;== Write failed, so we're read-only
			MessageBox MB_YESNO|MB_ICONQUESTION `$(LauncherAskCopyLocal)` IDYES SwitchToRunLocally
			MessageBox MB_OK|MB_ICONINFORMATION `$(LauncherNoReadOnly)`
			Abort

	SwitchToRunLocally:
		StrCpy $RUNLOCALLY "true"
		StrCpy $WAITFORPROGRAM "true"
		Goto DisplaySplash
	
	WriteSuccessful:
		FileClose $R0
		Delete "$PROFILEDIRECTORY\writetest.temp"
	
	DisplaySplash:
		${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
		StrCmp $DISABLESPLASHSCREEN "true" SkipSplashScreen
			;=== Show the splash screen before processing the files
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.jpg "${NAME}.jpg"
			newadvsplash::show /NOUNLOAD 2000 0 0 -1 /L $PLUGINSDIR\splash.jpg

	SkipSplashScreen:
		;=== Run locally if needed (aka Portable Firefox Live)
		StrCmp $RUNLOCALLY "true" "" CompareProfilePath
		RMDir /r "$TEMP\${NAME}\"
		CreateDirectory $TEMP\${NAME}\profile
		CreateDirectory $TEMP\${NAME}\plugins
		CreateDirectory $TEMP\${NAME}\program
		CopyFiles /SILENT $PROFILEDIRECTORY\*.* $TEMP\${NAME}\profile
		StrCpy $PROFILEDIRECTORY $TEMP\${NAME}\profile
		CopyFiles /SILENT $PLUGINSDIRECTORY\*.* $TEMP\${NAME}\plugins
		StrCpy $PLUGINSDIRECTORY $TEMP\${NAME}\plugins
		CopyFiles /SILENT $PROGRAMDIRECTORY\*.* $TEMP\${NAME}\program
		StrCpy $PROGRAMDIRECTORY $TEMP\${NAME}\program
		${SetFileAttributesDirectoryNormal} "$TEMP\${NAME}"

	CompareProfilePath:
		ReadINIStr $LASTPROFILEDIRECTORY "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastProfileDirectory"
		StrCmp $PROFILEDIRECTORY $LASTPROFILEDIRECTORY "" RememberProfilePath
			StrCmp $DISABLEINTELLIGENTSTART "true" RememberProfilePath
				StrCpy $SKIPCOMPREGFIX "true"
	
	RememberProfilePath:
		WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "LastProfileDirectory" "$PROFILEDIRECTORY"

	;FixPrefsJs:
		IfFileExists "$PROFILEDIRECTORY\prefs.js" "" FixOtherFiles
		StrCmp $LASTPROFILEDIRECTORY "NONE" FixPrefsJsPart2
		StrCpy $2 $LASTPROFILEDIRECTORY 1 ;Last drive letter
		StrCpy $3 $PROFILEDIRECTORY 1 ;Current drive letter
		StrCmp $2 $3 FixPrefsJsPart2 ;If no change, move on
		
		;=== Replace drive letters without impacting other instances of the letter in prefs.js
		${ReplaceInFileCS} "$PROFILEDIRECTORY\prefs.js" `file:///$2` `file:///$3`
		${ReplaceInFileCS} "$PROFILEDIRECTORY\prefs.js" `", "$2:\\` `", "$3:\\`
	
	FixPrefsJsPart2:
		;=== Be sure the default browser check is disabled
		FileOpen $0 "$PROFILEDIRECTORY\prefs.js" a
		FileSeek $0 0 END
		FileWriteByte $0 "13"
		FileWriteByte $0 "10"
		FileWrite $0 `user_pref("browser.shell.checkDefaultBrowser", false);`
		FileWriteByte $0 "13"
		FileWriteByte $0 "10"
		StrCmp "$LOCALHOMEPAGE" "" FixPrefsJsClose
		FileWrite $0 `user_pref("browser.startup.homepage", "file:///$EXEDIR/$LOCALHOMEPAGE");`
		FileWriteByte $0 "13"
		FileWriteByte $0 "10"

	FixPrefsJsClose:
		FileClose $0 

	FixOtherFiles:
		StrCmp $LASTPROFILEDIRECTORY "NONE" RunProgram
		${GetParent} $LASTPROFILEDIRECTORY $0
		${GetParent} $0 $0
		StrCpy $0 '$0\' ;last Portable directory
		${GetParent} $ORIGINALPROFILEDIRECTORY $1
		${GetParent} $1 $1
		StrCpy $1 '$1\' ;current Portable directory
		StrCmp $0 $1 RunProgram
		${If} ${FileExists} "$PROFILEDIRECTORY\pluginreg.dat"
			${ReplaceInFile} "$PROFILEDIRECTORY\pluginreg.dat" $0 $1
		${EndIf}
		${If} ${FileExists} "$PROFILEDIRECTORY\extensions.ini"
			${ReplaceInFile} "$PROFILEDIRECTORY\extensions.ini" $0 $1
			;Update extensions SQL
		${EndIf}
		${If} ${FileExists} "$PROFILEDIRECTORY\extensions.sqlite"
			nsExec::Exec `"$EXEDIR\App\Bin\sqlite3.exe" "$PROFILEDIRECTORY\extensions.sqlite" "UPDATE addon SET descriptor = '$1' || SUBSTR(descriptor,(LENGTH('$0')+1)) WHERE descriptor LIKE '$0%';"`
		${EndIf}
		${If} ${FileExists} "$PROFILEDIRECTORY\mimeTypes.rdf"
			${ReplaceInFile} "$PROFILEDIRECTORY\mimeTypes.rdf" $0 $1
		${EndIf}
		${If} ${FileExists} "$PROFILEDIRECTORY\prefs.js"
			${ReplaceInFile} "$PROFILEDIRECTORY\prefs.js" $0 $1
			${WordReplace} $0 "\" "/" "+" $2
			${WordReplace} $1 "\" "/" "+" $3
			${ReplaceInFile} "$PROFILEDIRECTORY\prefs.js" "file:///$2" "file:///$3"
		${EndIf}
		${GetParent} $LASTPROFILEDIRECTORY $0
		${GetParent} $0 $0
		${GetParent} $0 $0
		StrCpy $0 '$0\' ;last PortableApps directory
		${GetParent} $ORIGINALPROFILEDIRECTORY $1
		${GetParent} $1 $1
		${GetParent} $1 $1
		StrCpy $1 '$1\' ;current PortableApps directory
		StrCmp $0 $1 RunProgram
		${If} ${FileExists} "$PROFILEDIRECTORY\mimeTypes.rdf"
			${ReplaceInFile} "$PROFILEDIRECTORY\mimeTypes.rdf" $0 $1
		${EndIf}

	RunProgram:
		StrCmp $SKIPCOMPREGFIX "true" GetPassedParameters

		;=== Delete component registry to ensure compatibility with all extensions
		Delete $PROFILEDIRECTORY\compreg.dat

	GetPassedParameters:
		;=== Get any passed parameters
		${GetParameters} $0
		StrCmp "'$0'" "''" "" LaunchProgramParameters

		;=== No parameters
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" -profile "$PROFILEDIRECTORY"`
		Goto CheckMultipleInstances

	LaunchProgramParameters:
		StrCpy $EXECSTRING `"$PROGRAMDIRECTORY\$PROGRAMEXECUTABLE" -profile "$PROFILEDIRECTORY" $0`

	CheckMultipleInstances:
		StrCmp $ALLOWMULTIPLEINSTANCES "true" "" AdditionalParameters
		StrCpy $EXECSTRING `$EXECSTRING -no-remote`

	AdditionalParameters:
		StrCmp $ADDITIONALPARAMETERS "" PluginsEnvironment

		;=== Additional Parameters
		StrCpy $EXECSTRING `$EXECSTRING $ADDITIONALPARAMETERS`

	PluginsEnvironment:
		;=== Set the plugins directory if we have a path
		${IfNot} ${FileExists} "$PLUGINSDIRECTORY\*.*"
			StrCpy $PLUGINSDIRECTORY ""
		${EndIf}
		${GetParent} $EXEDIR $0
		${If} ${FileExists} "$0\CommonFiles\Java\bin\plugin2\*.*"
			${If} $PLUGINSDIRECTORY != ""
				StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\Java\bin\plugin2"
			${Else}
				StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\Java\bin\plugin2"
			${EndIf}
		${ElseIf} ${FileExists} "$0\CommonFiles\Java\bin\new_plugin\*.*"
			${If} $PLUGINSDIRECTORY != ""
				StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\Java\bin\new_plugin"
			${Else}
				StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\Java\bin\new_plugin"
			${EndIf}
		${EndIf}
		
!ifdef ISWIN64
		${If} ${FileExists} "$0\CommonFiles\Java64\bin\plugin2\*.*"
			${If} $PLUGINSDIRECTORY != ""
				StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\Java64\bin\plugin2"
			${Else}
				StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\Java64\bin\plugin2"
			${EndIf}
		${ElseIf} ${FileExists} "$0\CommonFiles\Java64\bin\new_plugin\*.*"
			${If} $PLUGINSDIRECTORY != ""
				StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\Java64\bin\new_plugin"
			${Else}
				StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\Java64\bin\new_plugin"
			${EndIf}
		${EndIf}		
!endif
		
		${If} ${FileExists} "$0\CommonFiles\Silverlight\files\*.*"
			${If} $PLUGINSDIRECTORY != ""
				StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\Silverlight\files"
			${Else}
				StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\Silverlight\files"
			${EndIf}
		${EndIf}
		${If} ${FileExists} "$0\CommonFiles\Flash\files\*.*"
			${If} $PLUGINSDIRECTORY != ""
				StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\Flash\files"
			${Else}
				StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\Flash\files"
			${EndIf}
		${EndIf}
		${If} ${FileExists} "$0\CommonFiles\BrowserPlugins\*.*"
			${If} $PLUGINSDIRECTORY != ""
				StrCpy $PLUGINSDIRECTORY "$PLUGINSDIRECTORY;$0\CommonFiles\BrowserPlugins"
			${Else}
				StrCpy $PLUGINSDIRECTORY "$0\CommonFiles\BrowserPlugins"
			${EndIf}
		${EndIf}
		
		StrCmp $PLUGINSDIRECTORY "" LaunchNow
			System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("MOZ_PLUGIN_PATH", "$PLUGINSDIRECTORY").r0'

	LaunchNow:
		System::Call 'Kernel32::SetEnvironmentVariable(t, t) i("MOZ_CRASHREPORTER_DATA_DIRECTORY", "$PROFILEDIRECTORY\CrashReports").r0'
		
		StrCmp $SECONDARYLAUNCH "true" StartProgramAndExit
		StrCmp $WAITFORPROGRAM "true" "" StartProgramAndExit
		SetOutPath $PROGRAMDIRECTORY
		ExecWait $EXECSTRING

	CheckRunning:
		Sleep 2000
		StrCmp $ALLOWMULTIPLEINSTANCES "true" CheckIfRemoveLocalFiles
!ifdef ISWIN64		
		FindProcDLL64::FindProc "${DEFAULTEXE}"
!else
		FindProcDLL86::FindProc "${DEFAULTEXE}"
!endif               
		StrCmp $R0 "1" CheckRunning CleanupRunLocally
	
	StartProgramAndExit:
		SetOutPath $PROGRAMDIRECTORY
		Exec $EXECSTRING
		Goto TheEnd
	
	CleanupRunLocally:
		StrCmp $RUNLOCALLY "true" "" CheckIfRemoveLocalFiles
		RMDir /r "$TEMP\${NAME}\"

	CheckIfRemoveLocalFiles:
!ifdef ISWIN64		
		FindProcDLL64::FindProc "${DEFAULTEXE}"
!else
		FindProcDLL86::FindProc "${DEFAULTEXE}"
!endif	
		Pop $R0
		StrCmp $R0 "1" TheEnd RemoveLocalFiles

	RemoveLocalFiles:
		StrCmp $ALLOWMULTIPLEINSTANCES "true" RemoveLocalFiles2
		RMDir /r "$APPDATA\${VENDOR}\${APPNAME}\Crash Reports\"
		Rename "$APPDATA\${VENDOR}\${APPNAME}\Crash Reports-BackupBy${APPNAME}" "$APPDATA\${VENDOR}\${APPNAME}\Crash Reports"

	RemoveLocalFiles2:
		StrCmp $ALLOWMULTIPLEINSTANCES "true" RemoveLocalFiles3
		RMDir /r "$APPDATA\${VENDOR}\Extensions\"
		Rename "$APPDATA\${VENDOR}\Extensions-BackupBy${APPNAME}" "$APPDATA\${VENDOR}\Extensions"
		
	RemoveLocalFiles3:
		Delete "$APPDATA\${VENDOR}\${APPNAME}\pluginreg.dat"
		RMDir "$APPDATA\${VENDOR}\${APPNAME}\Profiles\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\${VENDOR}\${APPNAME}\Profile\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\${VENDOR}\${APPNAME}\" ;=== Will only delete if empty (no /r switch)
		RMDir "$APPDATA\${VENDOR}\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\${VENDOR}\${APPNAME}\${APPNAME}\updates\0" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\${VENDOR}\${APPNAME}\${APPNAME}\updates" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\${VENDOR}\${APPNAME}\${APPNAME}" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\${VENDOR}\${APPNAME}\" ;=== Will only delete if empty (no /r switch)
		RMDir "$LOCALAPPDATA\${VENDOR}\" ;=== Will only delete if empty (no /r switch)
		StrCmp $MOZILLAORGKEYEXISTS "true" RemoveMachineRegistryKey
			${registry::DeleteKey} "HKEY_CURRENT_USER\Software\${VENDOR}" $R0
		RemoveMachineRegistryKey:
			StrCmp $HKLMMOZILLAORGKEYEXISTS "true" RemoveOtherKeys
				${registry::KeyExists} "HKLM\Software\${VENDOR}" $R0
					StrCmp $R0 "-1" RemoveOtherKeys ;=== If it doesn't exist, skip the next line
						UserInfo::GetAccountType
						Pop $0
						StrCmp $0 "Guest" RemoveOtherKeys
						StrCmp $0 "User" RemoveOtherKeys
						${registry::DeleteKey} "HKLM\Software\${VENDOR}" $R0
		RemoveOtherKeys:
			;Store the crash report setting
			${registry::Read} "HKCU\Software\${VENDOR}\${APPNAME}\Crash Reporter" "SubmitCrashReport" $R1 $R2		
			WriteINIStr "$SETTINGSDIRECTORY\${NAME}Settings.ini" "${NAME}Settings" "SubmitCrashReport" "$R1"
			
			${If} $bolHKCUSoftwareMozillaExists == true
				${If} $bolHKCUSoftwareMozillaFirefoxExists == true
					${If} $bolHKCUSoftwareMozillaFirefoxCrashReporterExists == true
						${registry::Write} "HKCU\Software\${VENDOR}\${APPNAME}\Crash Reporter" "SubmitCrashReport" "$SubmitCrashReportBackup" "REG_DWORD" $R1
					${Else}
						${registry::DeleteKey} "HKCU\Software\${VENDOR}\${APPNAME}\Crash Reporter" $R0
					${EndIf}
				${Else}
					${registry::DeleteKey} "HKCU\Software\${VENDOR}\${APPNAME}" $R0
				${EndIf}				
			${Else}
				${registry::DeleteKey} "HKCU\Software\${VENDOR}" $R0
			${EndIf}

	TheEnd:
		${registry::Unload}
		newadvsplash::stop /WAIT
SectionEnd