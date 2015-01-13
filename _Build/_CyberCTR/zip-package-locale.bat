@echo off
::CyberCTR locales packager
if not exist "%~dp0distribution" goto :end
if not exist "%~dp0locales" mkdir "%~dp0locales"
set zip=%~DP03rd_Party\7za.exe 
for /f %%f in ('dir /b "%~dp0distribution\bundles\CTR@8pecxstudios.com\locale"') do %zip% a -mx9 -tzip "%~dp0locales\%%f.7z" "%~dp0distribution\bundles\CTR@8pecxstudios.com\locale\%%f"
:end