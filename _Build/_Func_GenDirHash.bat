@echo off
:: ----------------------------------------------------------
:: Function generate output hash
:: ----------------------------------------------------------
if exist "_Installer\{content}\browser\%~1" (
GetHash-CL.exe --sum=SHA512 --output=_Installer\{content}\browser\%~1\SHA512SUMS --Folder=_Installer\{content}\browser\%~1
) else (
echo.Error GetHash-CL.exe --sum=SHA512 --output=_Installer\{content}\browser\%~1\SHA512SUMS --Folder=_Installer\{content}\browser\%~1 
)
exit /b %ERRORLEVEL%