@echo OFF
set DestinPath1=_AppStrings
set DestinPath2=_Branding
set DestinPath3=_BrowserDTD
set DestinPath4=_Install_Manifest
set DestinPath5=_Originals
set DestinPath6=_Preferences
set DestinPath7=_XPI_Folder
if exist "%DestinPath1%" rmdir /s /q "%DestinPath1%"
mkdir %DestinPath1%
if exist "%DestinPath2%" rmdir /s /q "%DestinPath2%"
mkdir %DestinPath2%
if exist "%DestinPath3%" rmdir /s /q "%DestinPath3%"
mkdir %DestinPath3%
if exist "%DestinPath4%" rmdir /s /q "%DestinPath4%"
mkdir %DestinPath4%
if exist "%DestinPath5%" rmdir /s /q "%DestinPath5%"
mkdir %DestinPath5%
if exist "%DestinPath6%" rmdir /s /q "%DestinPath6%"
mkdir %DestinPath6%
if exist "%DestinPath7%" rmdir /s /q "%DestinPath7%"
mkdir %DestinPath7%