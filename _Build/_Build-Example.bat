set releaseVer=00.0.0.0
set smallVer=00.0.0
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=i368 --package=intel86 --version=%releaseVer% --sversion=%smallVer% --build
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=amd64 --package=intel64 --version=%releaseVer% --sversion=%smallVer% --build
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=i368 --package=amd86 --version=%releaseVer% --sversion=%smallVer% --build
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=amd64 --package=amd64 --version=%releaseVer% --sversion=%smallVer% --build