::Copyright 2015 8pecxstudios
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
"%zip%" a -mmt -mx9 -t7z "%BuildFolderPath%_CyberCTR\distribution.7z" "%CyberCTRPath%"
if exist "%BuildFolderPath%_CyberCTR\distribution.7z" copy /y "%BuildFolderPath%_CyberCTR\distribution.7z" "%BuildFolderPath%_Installer\{content}\ThirdParty\"
echo. 
::----
echo.Updating Changelog.rtf
timeout 2 >nul
::---- 
if exist "%BuildFolderPath%_Changelog\changelog.rtf" copy /y "%BuildFolderPath%_Changelog\changelog.rtf" "%BuildFolderPath%_Installer\{content}\setupFiles"
if exist "%BuildFolderPath%_Changelog\changelog.rtf" copy /y "%BuildFolderPath%_Changelog\changelog.rtf" "%BuildFolderPath%_Directory_Tree\temp\current_version"
timeout 2 >nul
::---- 
echo.Building cyberfox installer packages!
timeout 2 >nul
::---- 
echo.Building cyberfox installer package!
%ISSCompiler% /cc "%BuildFolderPath%_Installer\generateInstaller.iss" 
echo.Finished building cyberfox installer package!
::----
popd 
echo. 
echo. 
echo.Finished building the installer package!
echo.Open _Installation folder for all outputed installation packages!
timeout 2 >nul
::----
exit /b %ERRORLEVEL%
