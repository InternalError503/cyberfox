::Copyright 2015 8pecxstudios
@echo OFF
::----
set BuildFolderPath=%~DP0
set ISSCompiler="%BuildFolderPath%_ISCompiler\compil32"
set zip=%~DP0_7ZipPortable\App\7-Zip\7z.exe
echo. 
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
