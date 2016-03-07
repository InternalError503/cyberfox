@echo off
::Set version
(set /P releaseVer=
)<VERSION\SMVER.txt

::Enter Chocolatey
cd _Chocolately

::Copy cyberfox.nuspec
if exist "nuspec\cyberfox.nuspec" (
copy /y "nuspec\cyberfox.nuspec" "package\"
GetHash-CL.exe --file=nuspec/cyberfox.nuspec --version=%releaseVer% --rsum=package\cyberfox.nuspec
) else (
echo. "nuspec\cyberfox.nuspec" not found!
pause
exit
)

::Copy chocolateyInstall.ps1
if exist "chocolateyInstall\chocolateyInstall.ps1" (
copy /y "chocolateyInstall\chocolateyInstall.ps1" "package\tools\"
GetHash-CL.exe --file=chocolateyInstall\chocolateyInstall.ps1 --version=%releaseVer% --rsum=package\tools\chocolateyInstall.ps1
) else (
echo. "chocolateyInstall\chocolateyInstall.ps1" not found!
pause
exit
)

::Compile choco package.
choco
cd package
cpack cyberfox.nuspec
cd ..

if exist "package\cyberfox.%releaseVer%.nupkg" (
copy /y "package\cyberfox.%releaseVer%.nupkg" "packageOutput\"
del "package\cyberfox.%releaseVer%.nupkg"
) else (
echo. "package\cyberfox.%releaseVer%.nupkg" not found!
pause
exit
)

if exist "packageOutput\cyberfox.%releaseVer%.nupkg" (
choco push packageOutput\cyberfox.%releaseVer%.nupkg
) else (
echo. "packageOutput\cyberfox.%releaseVer%.nupkg" not found!
pause
exit
)
popd
exit /b %ERRORLEVEL%