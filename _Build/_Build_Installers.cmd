::Copyright 2014 8pecxstudios
@echo OFF
::----
set BuildFolderPath=%~DP0
set ISSCompiler="%BuildFolderPath%_ISCompiler\compil32"
set zip=%~DP0_7ZipPortable\App\7-Zip\7z.exe 
set CyberCTRPath=%BuildFolderPath%_CyberCTR\distribution
echo. 
::----
echo.Packaging CyberCTR!
timeout 2 >nul
::---- 
if exist "%BuildFolderPath%_CyberCTR\distribution.7z" del "%BuildFolderPath%_CyberCTR\distribution.7z"
%zip% a -mx9 -t7z "%BuildFolderPath%_CyberCTR\distribution.7z" "%CyberCTRPath%"
if exist "%BuildFolderPath%_CyberCTR\distribution.7z" copy /y "%BuildFolderPath%_CyberCTR\distribution.7z" "%BuildFolderPath%_Amd\_64\{ThirdParty}\"
if exist "%BuildFolderPath%_CyberCTR\distribution.7z" copy /y "%BuildFolderPath%_CyberCTR\distribution.7z" "%BuildFolderPath%_Amd\_86\{ThirdParty}\"
if exist "%BuildFolderPath%_CyberCTR\distribution.7z" copy /y "%BuildFolderPath%_CyberCTR\distribution.7z" "%BuildFolderPath%_Intel\_64\{ThirdParty}\"
if exist "%BuildFolderPath%_CyberCTR\distribution.7z" copy /y "%BuildFolderPath%_CyberCTR\distribution.7z" "%BuildFolderPath%_Intel\_86\{ThirdParty}\"
echo. 
::----
echo.Updating Changelog.rtf
timeout 2 >nul
::---- 
if exist "%BuildFolderPath%_Changelog\changelog.rtf" copy /y "%BuildFolderPath%_Changelog\changelog.rtf" "%BuildFolderPath%_Amd\_64\{Files}\"
if exist "%BuildFolderPath%_Changelog\changelog.rtf" copy /y "%BuildFolderPath%_Changelog\changelog.rtf" "%BuildFolderPath%_Amd\_86\{Files}\"
if exist "%BuildFolderPath%_Changelog\changelog.rtf" copy /y "%BuildFolderPath%_Changelog\changelog.rtf" "%BuildFolderPath%_Intel\_64\{Files}\"
if exist "%BuildFolderPath%_Changelog\changelog.rtf" copy /y "%BuildFolderPath%_Changelog\changelog.rtf" "%BuildFolderPath%_Intel\_86\{Files}\"
timeout 2 >nul
::---- 
echo.Building cyberfox installer packages!
timeout 2 >nul
::---- 
echo.Building cyberfox Intel 64 bit installer package!
%ISSCompiler% /cc "%BuildFolderPath%_Intel\_64\Cyberfox_Intel_64.iss" 
echo.Finished building cyberfox Intel 64 bit installer package!
timeout 2 >nul
::----
echo.Building cyberfox Intel 86 bit installer package!
%ISSCompiler% /cc "%BuildFolderPath%_Intel\_86\Cyberfox_Intel_86.iss"
echo.Finished building cyberfox Intel 86 bit installer package!
timeout 2 >nul
::----
echo.Building cyberfox AMD 64 bit installer package!
%ISSCompiler% /cc "%BuildFolderPath%_Amd\_64\Cyberfox_AMD_64.iss"
echo.Finished building cyberfox AMD 64 bit installer package!
timeout 2 >nul
::----
echo.Building cyberfox AMD 86 bit installer package!
%ISSCompiler% /cc "%BuildFolderPath%_Amd\_86\Cyberfox_AMD_86.iss"
echo.Finished building cyberfox AMD 86 bit installer package!
::----
popd
echo. 
echo. 
echo. 
echo.  Finished building all installer packages!
echo.  Open _Installation folder for all outputed installation packages!
timeout 3 >nul
::----
exit /b %ERRORLEVEL%
