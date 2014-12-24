; CheckForPlatformSplashDisable 1.0 (2010-06-16)
;
; Checks if the platform wants the splash screen disabled
; Copyright 2008-2010 John T. Haller of PortableApps.com
; Released under the GPL
;
; Usage: ${CheckForPlatformSplashDisable} DISABLESPLASHSCREEN
;
; Example: ${CheckForPlatformSplashDisable} $DISABLESPLASHSCREEN
;    If the platform wants it disabled, $DISABLESPLASHSCREEN will be true.  Otherwise
;    it will be whatever its previous value was

Function CheckForPlatformSplashDisable
	;Get our parameters
	Exch $0 ;DISABLESPLASHSCREEN
	Push $1
	Push $R0
	Push $2
	
	;Read from the INI
	StrCmp $0 "true" ClearTheStackAndExit
		ReadEnvStr $1 "PortableApps.comDisableSplash"
		StrCmp $1 "true" "" ClearTheStackAndExit
			${GetParent} $EXEDIR $1
			IfFileExists `$1\PortableApps.com\PortableAppsPlatform.exe` "" ClearTheStackAndExit
				MoreInfo::GetProductName `$1\PortableApps.com\PortableAppsPlatform.exe`
				Pop $2
				StrCmp $2 "PortableApps.com Platform" "" ClearTheStackAndExit
					MoreInfo::GetCompanyName `$1\PortableApps.com\PortableAppsPlatform.exe`
					Pop $2
					StrCmp $2 "PortableApps.com" "" ClearTheStackAndExit
						FindProcDLL::FindProc "PortableAppsPlatform.exe"
						StrCmp $R0 1 "" ClearTheStackAndExit
							StrCpy $0 "true"

	ClearTheStackAndExit:
	;Clear the stack
	Pop $2
	Pop $R0
	Pop $1
	
	;Reset the last variable and leave our result on the stack
	Exch $0
FunctionEnd

!macro CheckForPlatformSplashDisable DISABLESPLASHSCREEN
  Push `${DISABLESPLASHSCREEN}`
  Call CheckForPlatformSplashDisable
  Pop `${DISABLESPLASHSCREEN}`
!macroend

!define CheckForPlatformSplashDisable '!insertmacro "CheckForPlatformSplashDisable"'