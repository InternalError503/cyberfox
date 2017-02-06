(set /P smallVer=
)<Version\smver.txt
(set /P releaseVer=
)<Version\Version.txt

GenUpdateInfo.exe --f="_Installer\{content}\browser\intel86\update.ini" --v=%smallVer% --t=intel86
GenUpdateInfo.exe --f="_Installer\{content}\browser\intel64 \update.ini" --v=%smallVer% --t=intel64 
GenUpdateInfo.exe --f="_Installer\{content}\browser\amd86\update.ini" --v=%smallVer% --t=amd86
GenUpdateInfo.exe --f="_Installer\{content}\browser\amd64\update.ini" --v=%smallVer% --t=amd64

BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=i368 --package=intel86 --version=%releaseVer% --sversion=%smallVer% --build
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=amd64 --package=intel64 --version=%releaseVer% --sversion=%smallVer% --build
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=i368 --package=amd86 --version=%releaseVer% --sversion=%smallVer% --build
BuildISS.exe --configIn=_InstallerConfig\app.config --configOut=_Installer\app.config --arch=amd64 --package=amd64 --version=%releaseVer% --sversion=%smallVer% --build