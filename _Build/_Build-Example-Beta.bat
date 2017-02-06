set releaseVer=00.0.0.0
set smallVer=00.0
set betaVer=b0

GenUpdateInfo.exe --f="_Installer\{content}\browser\beta86\update.ini" --v=%smallVer%%betaVer% --t=beta86
GenUpdateInfo.exe --f="_Installer\{content}\browser\beta64\update.ini" --v=%smallVer%%betaVer% --t=beta64
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=i368 --package=beta86 --version=%releaseVer% --sversion=%smallVer% --bversion=%betaVer% --build
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=amd64 --package=beta64 --version=%releaseVer% --sversion=%smallVer% --bversion=%betaVer% --build