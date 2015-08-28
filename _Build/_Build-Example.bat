(set /P smallVer=
)<Version\smver.txt
(set /P releaseVer=
)<Version\Version.txt
call _Func_GenDirHash.bat "intel86"
call _Func_GenDirHash.bat "intel64"
call _Func_GenDirHash.bat "amd86"
call _Func_GenDirHash.bat "amd64"
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=i368 --package=intel86 --version=%releaseVer% --sversion=%smallVer% --build
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=amd64 --package=intel64 --version=%releaseVer% --sversion=%smallVer% --build
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=i368 --package=amd86 --version=%releaseVer% --sversion=%smallVer% --build
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=amd64 --package=amd64 --version=%releaseVer% --sversion=%smallVer% --build