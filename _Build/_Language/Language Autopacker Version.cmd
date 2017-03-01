@echo off
title Language Autopacker Version: 1.1
ECHO&color 03
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#              Copyright(c) 2017 8pecxstudios             #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#                      8pecxstudios                       #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
set DestinPath=%~DP0_XPI_Folder
set OutputPath=..\_Installation\LanguageA

if exist "%OutputPath%" (
	del /q /f "%OutputPath%"
	mkdir "%OutputPath%"
) else (
	mkdir "%OutputPath%"
)

if not exist "..\_7ZipPortable\App\7-Zip\7za.exe" goto :exit
set SevenZip=..\_7ZipPortable\App\7-Zip\7za.exe

for /f %%f in ('dir /b "%DestinPath%"') do (
	if exist "%DestinPath%\%%f\%%f" del "%DestinPath%\%%f\%%f"
	%SevenZip% a -mmt -mx9 -tzip "%DestinPath%\%%f\langpack-%%~nf@8pecxstudios.com.xpi" "%DestinPath%\%%f\*"
	copy /y "%DestinPath%\%%f\langpack-%%~nf@8pecxstudios.com.xpi" "%OutputPath%\"
	del "%DestinPath%\%%f\langpack-%%~nf@8pecxstudios.com.xpi"
)

if exist "%OutputPath%\langpack-en-US@8pecxstudios.com.xpi" (
	del "%OutputPath%\langpack-en-US@8pecxstudios.com.xpi"
)

:exit
popd
exit /b %ERRORLEVEL%