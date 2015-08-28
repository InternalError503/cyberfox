set releaseVer=00.0.0.0
set smallVer=00.0
set betaVer=b0
call _Func_GenDirHash.bat "beta86"
call _Func_GenDirHash.bat "beta64"
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=i368 --package=beta86 --version=%releaseVer% --sversion=%smallVer%%betaVer% --build
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=amd64 --package=beta64 --version=%releaseVer% --sversion=%smallVer%%betaVer% --build