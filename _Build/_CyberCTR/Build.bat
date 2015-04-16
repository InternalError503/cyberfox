::Note Requires 3rd party paid application called winrar http://www.rarlab.com/ to compile package.
@echo off
if not exist "%systemDrive%\Program Files\WinRAR\rar.exe" echo. & echo.Requires 3rd party paid application called winrar http://www.rarlab.com/ to compile package! & pause
if exist "%systemDrive%\Program Files\WinRAR\rar.exe" "%systemDrive%\Program Files\WinRAR\rar.exe" a -r0 -sfx CyberCTRUpdatePackage -z"%~DP0comment.config" "distribution\*.*"
exit /b %ERRORLEVEL%
