@echo Off
:top
::----
set BuildFolderPath=%~DP0
::set NSISCompiler="%BuildFolderPath%_NSISPortable\NSISPortable.exe"  can't be used if /V0 flag is as the NSISPortable does not recognise the command.
set NSISCompiler="%BuildFolderPath%_NSISPortable\app\nsis\makensis" 
set Argos=/V0
echo. 
::----
ECHO.
ECHO.
ECHO.                                                         			   
ECHO.Please Select Compiler Option           
ECHO.---------------------------------------         	   
ECHO.                                                                      
ECHO.Press 1 to Create (x86) Package.                
ECHO.Press 2 to Create (x64) Package.                 
ECHO.Press E to Exit.                      
ECHO.                                                          
ECHO.---------------------------------------         
ECHO.
ECHO.
ECHO.----------- 
ECHO.1. Create (x86) Package. 
ECHO.2. Create (x64) Package. 
ECHO.E. E to Exit.
ECHO.Any Key. Cancel.             
ECHO.----------- 
SET /P uin=Choose an option (1,2,E)? 
if /i {%uin%}=={1} (goto :Compile-Package-86)
if /i {%uin%}=={2} (goto :Compile-Package-64) 
if /i {%uin%}=={E} (goto :exit)
if /i {%uin%}=={Exit} (goto :exit)
if /i {%uin%}=={EXIT} (goto :exit)
if /i {%uin%}=={e} (goto :exit)
if /i {%uin%}=={exit} (goto :exit)
goto :top


:Compile-Package-86
echo. Compilation of portable medium is starting!
timeout 1 >nul
::----
echo. Building Intel 86 bit portable package
if exist "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\Other\Source\win64.txt" del /y"%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\Other\Source\win64.txt"
copy /y "%BuildFolderPath%_CyberfoxPortable\BlankConfig\intel86\UpdateConfig.ini" "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\AppInfo"
if exist "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox" rmdir /q /s "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox"
mkdir "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox"
xcopy /e /v "%BuildFolderPath%_Installer\{content}\browser\intel86" "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox"
mkdir "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox\distribution"
xcopy /e /v "%BuildFolderPath%_CyberCTR\distribution" "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox\distribution"
%NSISCompiler% %Argos% "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\Other\Source\CyberfoxPortableU.nsi" 
echo. Build Intel 86 bit portable package complete!
timeout 1 >nul
::----
echo. Building Amd 86 bit portable package!
if exist "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\Other\Source\win64.txt" del /y"%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\Other\Source\win64.txt"
copy /y "%BuildFolderPath%_CyberfoxPortable\BlankConfig\amd86\UpdateConfig.ini" "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\AppInfo"
if exist "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\Cyberfox" rmdir /q /s "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\Cyberfox"
mkdir "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\Cyberfox"
xcopy /e /v "%BuildFolderPath%_Installer\{content}\browser\amd86" "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\Cyberfox"
mkdir "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\Cyberfox\distribution"
xcopy /e /v "%BuildFolderPath%_CyberCTR\distribution" "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\Cyberfox\distribution"
%NSISCompiler% %Argos% "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\Other\Source\CyberfoxPortableU.nsi" 
echo. Build Amd 86 bit portable package complete!
goto :completed
::----
:Compile-Package-64
echo. Compilation of portable medium is starting!
timeout 1 >nul
::----
echo. Building Intel 64 bit portable package!
if not exist "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\Other\Source\win64.txt" break>"%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\Other\Source\win64.txt"
copy /y "%BuildFolderPath%_CyberfoxPortable\BlankConfig\intel64\UpdateConfig.ini" "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\AppInfo"
if exist "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox" rmdir /q /s "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox"
mkdir "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox"
xcopy /e /v "%BuildFolderPath%_Installer\{content}\browser\intel64" "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox"
mkdir "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox\distribution"
xcopy /e /v "%BuildFolderPath%_CyberCTR\distribution" "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\App\Cyberfox\distribution"
%NSISCompiler% %Argos% "%BuildFolderPath%_CyberfoxPortable\Intel\CyberfoxPortable\Other\Source\CyberfoxPortableU.nsi" 
echo. Build Intel 64 bit portable package Complete!
timeout 1 >nul
::----
echo. Building Amd 64 bit portable package!
if not exist "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\Other\Source\win64.txt" break>"%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\Other\Source\win64.txt"
copy /y "%BuildFolderPath%_CyberfoxPortable\BlankConfig\amd64\UpdateConfig.ini" "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\AppInfo"
if exist "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\Cyberfox" rmdir /q /s "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\Cyberfox"
mkdir "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\Cyberfox"
xcopy /e /v "%BuildFolderPath%_Installer\{content}\browser\amd64" "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\Cyberfox"
mkdir "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\Cyberfox\distribution"
xcopy /e /v "%BuildFolderPath%_CyberCTR\distribution" "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\App\Cyberfox\distribution"
%NSISCompiler% %Argos% "%BuildFolderPath%_CyberfoxPortable\Amd\CyberfoxPortable\Other\Source\CyberfoxPortableU.nsi" 
echo. Build Amd 64 bit portable package complete!
timeout 1 >nul
goto :completed
::----
:completed
popd
echo. 
echo. 
echo. 
echo.Compilation Complete!
echo.Open _Installation Folder For All Outputed Portable Packages!
timeout 1 >nul
::----
goto :top
:exit
exit /b %ERRORLEVEL%