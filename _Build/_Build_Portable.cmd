@echo Off
title Build Cyberfox Portable V1.7
ECHO.
(set /P Version=
)<Version\Version.txt

set BuildFolderPath=%~DP0
set BuildFolderPathIntel=%~DP0_CyberfoxPortable\Intel\CyberfoxPortable\
set BuildFolderPathAmd=%~DP0_CyberfoxPortable\Amd\CyberfoxPortable\
set Delete=%BuildFolderPath%_Build_Portable\_Func_Delete.cmd
set DeleteDir=%BuildFolderPath%_Build_Portable\_Func_Delete_Dir.cmd
::set NSISCompiler="%BuildFolderPath%_NSISPortable\NSISPortable.exe"  can't be used if /V0 flag is as the NSISPortable does not recognise the command.
::The /V followed numbers between 0 and 4 sets the verbosity of output. (0=no output, 1=errors only, 2=warnings and errors, 3=info, warnings, and errors, 4=all output).
set NSISCompiler="%BuildFolderPath%_NSISPortable\app\nsis\makensis" 
set Argos=/V4

if not exist "%BuildFolderPath%_NSISPortable\app\nsis\makensis.exe" (
echo.The NSIS compiler was not found!
echo.Exiting
goto :exit
) 

goto :Compile-Package-86

:Compile-Package-86
echo. Compilation of portable medium is starting!
if not exist "%BuildFolderPath%_CyberfoxPortable\logs" (
mkdir "%BuildFolderPath%_CyberfoxPortable\logs"
)
echo. Building Intel 86 bit portable package
call %Delete% "%BuildFolderPathIntel%Other\Source\win64.txt" "win64.txt not found!"
call %Delete% "%BuildFolderPathIntel%CyberfoxPortable.exe" "CyberfoxPortable.exe not found!"
copy /y "%BuildFolderPath%_CyberfoxPortable\BlankConfig\intel86\UpdateConfig.ini" "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\AppInfo\"
call %DeleteDir% "%BuildFolderPathIntel%App\Cyberfox" "%BuildFolderPathIntel%App\Cyberfox not found!"
mkdir "%BuildFolderPathIntel%App\Cyberfox"
@echo on
call _Func_GenDirHash.bat "intel86"
xcopy /e /v "%BuildFolderPath%_Installer\{content}\browser\intel86" "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox"
@echo off
mkdir "%BuildFolderPathIntel%App\Cyberfox\distribution"
@echo on
xcopy /e /v "%BuildFolderPath%_CyberCTR\distribution" "%BuildFolderPathIntel%App\Cyberfox\distribution"
@echo off
@echo on
%NSISCompiler% %Argos% "%BuildFolderPathIntel%Other\Source\CyberfoxPortableU.nsi" > "%BuildFolderPath%_CyberfoxPortable\logs\build_intel86.log" && type "%BuildFolderPath%_CyberfoxPortable\logs\build_intel86.log"
@echo off
echo. Build Intel 86 bit portable package complete!

echo. Building Amd 86 bit portable package!
call %Delete% "%BuildFolderPathAmd%Other\Source\win64.txt" "win64.txt not found!"
call %Delete% "%BuildFolderPathAmd%CyberfoxPortable.exe" "CyberfoxPortable.exe not found!"
copy /y "%BuildFolderPath%_CyberfoxPortable\BlankConfig\amd86\UpdateConfig.ini" "%BuildFolderPathAmd%App\AppInfo\"
call %DeleteDir% "%BuildFolderPathAmd%App\Cyberfox" "%BuildFolderPathAmd%App\Cyberfox not found!"
mkdir "%BuildFolderPathAmd%App\Cyberfox"
@echo on
call _Func_GenDirHash.bat "amd86"
xcopy /e /v "%BuildFolderPath%_Installer\{content}\browser\amd86" "%BuildFolderPathAmd%App\Cyberfox"
@echo off
mkdir "%BuildFolderPathAmd%App\Cyberfox\distribution"
@echo on
xcopy /e /v "%BuildFolderPath%_CyberCTR\distribution" "%BuildFolderPathAmd%App\Cyberfox\distribution"
@echo off
@echo on
%NSISCompiler% %Argos% "%BuildFolderPathAmd%Other\Source\CyberfoxPortableU.nsi" > "%BuildFolderPath%_CyberfoxPortable\logs\build_amd86.log" && type "%BuildFolderPath%_CyberfoxPortable\logs\build_amd86.log"
@echo off
echo. Build Amd 86 bit portable package complete!
goto :Compile-Package-86-Portable

:Compile-Package-64
echo. Compilation of portable medium is starting!
if not exist "%BuildFolderPath%_CyberfoxPortable\logs" (
mkdir "%BuildFolderPath%_CyberfoxPortable\logs"
)
echo. Building Intel 64 bit portable package!
if not exist "%BuildFolderPathIntel%Other\Source\win64.txt" (
break>"%BuildFolderPathIntel%Other\Source\win64.txt"
)
call %Delete% "%BuildFolderPathIntel%CyberfoxPortable.exe" "CyberfoxPortable.exe not found!"
copy /y "%BuildFolderPath%_CyberfoxPortable\BlankConfig\intel64\UpdateConfig.ini" "%BuildFolderPathIntel%App\AppInfo\"
call %DeleteDir% "%BuildFolderPathIntel%App\Cyberfox" "%BuildFolderPathIntel%App\Cyberfox not found!"
mkdir "%BuildFolderPathIntel%App\Cyberfox"
@echo on
call _Func_GenDirHash.bat "intel64"
xcopy /e /v "%BuildFolderPath%_Installer\{content}\browser\intel64" "%BuildFolderPathIntel%App\Cyberfox"
@echo off
mkdir "%BuildFolderPathIntel%App\Cyberfox\distribution"
@echo on
xcopy /e /v "%BuildFolderPath%_CyberCTR\distribution" "%BuildFolderPathIntel%App\Cyberfox\distribution"
@echo off
@echo on
%NSISCompiler% %Argos% "%BuildFolderPathIntel%Other\Source\CyberfoxPortableU.nsi" > "%BuildFolderPath%_CyberfoxPortable\logs\build_intel64.log" && type "%BuildFolderPath%_CyberfoxPortable\logs\build_intel64.log"
@echo off
echo. Build Intel 64 bit portable package complete!

echo. Building Amd 64 bit portable package!
if not exist "%BuildFolderPathAmd%Other\Source\win64.txt" (
break>"%BuildFolderPathAmd%Other\Source\win64.txt"
)
call %Delete% "%BuildFolderPathAmd%CyberfoxPortable.exe" "CyberfoxPortable.exe not found!"
copy /y "%BuildFolderPath%_CyberfoxPortable\BlankConfig\amd64\UpdateConfig.ini" "%BuildFolderPathAmd%App\AppInfo\"
call %DeleteDir% "%BuildFolderPathAmd%App\Cyberfox" "%BuildFolderPathAmd%App\Cyberfox not found!"
mkdir "%BuildFolderPathAmd%App\Cyberfox"
@echo on
call _Func_GenDirHash.bat "amd64"
xcopy /e /v "%BuildFolderPath%_Installer\{content}\browser\amd64" "%BuildFolderPathAmd%App\Cyberfox"
@echo off
mkdir "%BuildFolderPathAmd%App\Cyberfox\distribution"
@echo on
xcopy /e /v "%BuildFolderPath%_CyberCTR\distribution" "%BuildFolderPathAmd%App\Cyberfox\distribution"
@echo off
@echo on
%NSISCompiler% %Argos% "%BuildFolderPathAmd%Other\Source\CyberfoxPortableU.nsi" > "%BuildFolderPath%_CyberfoxPortable\logs\build_amd64.log" && type "%BuildFolderPath%_CyberfoxPortable\logs\build_amd64.log" 
@echo off
echo. Build Amd 64 bit portable package complete!
goto :Compile-Package-64-Portable

:Compile-Package-86-Portable
@echo off
set BuildFolderPath=%~DP0
set PortableAppsInstaller="%BuildFolderPath%_PortableApps.comInstaller\PortableApps.comInstaller.exe"
set PortableAppsInstallerOutput="%BuildFolderPath%_Installation"

echo. Compilation of %Version% portable installation medium is starting!
echo. Building Amd 86 bit portable package!
%PortableAppsInstaller% "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable"
echo. Build Amd 86 bit package complete!
if not exist "%BuildFolderPath%_Installation" (
mkdir "%BuildFolderPath%_Installation"
)
ren "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable_%Version%_English.paf.exe"  "CyberfoxPortable_%Version%_English.Amd.86.paf.exe"
copy /y "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable_%Version%_English.Amd.86.paf.exe" "%PortableAppsInstallerOutput%"
call %Delete% "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable_%Version%_English.Amd.86.paf.exe" "CyberfoxPortable_%Version%_English.Amd.86.paf.exe not found!"
echo. Building intel 86 bit portable package
%PortableAppsInstaller% "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable"
echo. Build intel 86 bit portable package complete!
ren "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable_%Version%_English.paf.exe"  "CyberfoxPortable_%Version%_English.Intel.86.paf.exe"
copy /y "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable_%Version%_English.Intel.86.paf.exe" "%PortableAppsInstallerOutput%"
call %Delete% "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable_%Version%_English.Intel.86.paf.exe" "CyberfoxPortable_%Version%_English.Intel.86.paf.exe not found!"
goto :Compile-Package-86-Zipped

:Compile-Package-64-Portable
@echo off
set BuildFolderPath=%~DP0
set PortableAppsInstaller="%BuildFolderPath%_PortableApps.comInstaller\PortableApps.comInstaller.exe"
set PortableAppsInstallerOutput="%BuildFolderPath%_Installation"

echo. Compilation of %Version% portable installation medium is starting!
if not exist "%BuildFolderPath%_Installation" (
mkdir "%BuildFolderPath%_Installation"
)
echo. Building Amd 64 bit portable package!
%PortableAppsInstaller% "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable"
echo. Build Amd 64 bit package complete!
ren "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable_%Version%_English.paf.exe"  "CyberfoxPortable_%Version%_English.Amd.paf.exe"
copy /y "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable_%Version%_English.Amd.paf.exe" "%PortableAppsInstallerOutput%"
call %Delete% "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable_%Version%_English.Amd.paf.exe" "CyberfoxPortable_%Version%_English.Amd.paf.exe not found!"

echo. Building intel 64 bit portable package
%PortableAppsInstaller% "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable"
echo. Build intel64 bit portable package complete!
ren "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable_%Version%_English.paf.exe"  "CyberfoxPortable_%Version%_English.Intel.paf.exe"
copy /y "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable_%Version%_English.Intel.paf.exe" "%PortableAppsInstallerOutput%"
call %Delete% "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable_%Version%_English.Intel.paf.exe" "CyberfoxPortable_%Version%_English.Intel.paf.exe not found!"
goto :Compile-Package-64-Zipped

:Compile-Package-86-Zipped
@echo Off
set BuildFolderPath=%~DP0
if not exist "%BuildFolderPath%_7ZipPortable\App\7-Zip\7za.exe" goto :bye
set SevenZip=%BuildFolderPath%_7ZipPortable\App\7-Zip\7za.exe
set PortableAppsZippedOutput="%BuildFolderPath%_Installation"

echo. Compilation of %Version% zipped installation medium is starting!
echo. Building amd 86 bit zipped package!
%SevenZip% a -mx9 -t7z "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable_%Version%_English.Amd.86.7z" "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable"
echo. Build amd 86 bit package complete!
if not exist "%BuildFolderPath%_Installation" (
mkdir "%BuildFolderPath%_Installation"
)
copy /y "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable_%Version%_English.Amd.86.7z" "%PortableAppsZippedOutput%"
call %Delete% "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable_%Version%_English.Amd.86.7z" "CyberfoxPortable_%Version%_English.Amd.86.7z not found!"
echo. Building intel 86 bit zipped package
%SevenZip% a -mx9 -t7z  "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable_%Version%_English.Intel.86.7z" "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable"
echo. Build intel 86 bit zipped package complete!
copy /y "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable_%Version%_English.Intel.86.7z" "%PortableAppsZippedOutput%"
call %Delete% "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable_%Version%_English.Intel.86.7z" "CyberfoxPortable_%Version%_English.Intel.86.7z not found!"
goto :Compile-Package-64

:Compile-Package-64-Zipped
@echo Off
set BuildFolderPath=%~DP0
if not exist "%BuildFolderPath%_7ZipPortable\App\7-Zip\7za.exe" goto :bye
set SevenZip=%BuildFolderPath%_7ZipPortable\App\7-Zip\7za.exe
set PortableAppsZippedOutput="%BuildFolderPath%_Installation"

echo. Compilation 0f %Version% zipped installation medium is starting!
echo. Building amd 64 bit zipped package!
%SevenZip% a -mx9 -t7z "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable_%Version%_English.Amd.7z" "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable"
echo. Build Amd 64 bit package complete!
if not exist "%BuildFolderPath%_Installation" (
mkdir "%BuildFolderPath%_Installation"
)
copy /y "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable_%Version%_English.Amd.7z" "%PortableAppsZippedOutput%"
call %Delete% "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable_%Version%_English.Amd.7z" "CyberfoxPortable_%Version%_English.Amd.7z not found!"
echo. Building intel 64 bit zipped package
%SevenZip% a -mx9 -t7z  "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable_%Version%_English.Intel.7z" "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable"
echo. Build intel 64 bit zipped package complete!
copy /y "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable_%Version%_English.Intel.7z" "%PortableAppsZippedOutput%"
call %Delete% "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable_%Version%_English.Intel.7z" "CyberfoxPortable_%Version%_English.Intel.7z not found!"
goto :completed

:completed
@echo off
popd
echo. 
echo. 
echo. 
echo.Compilation Complete!
goto :top

:exit
exit /b %ERRORLEVEL%