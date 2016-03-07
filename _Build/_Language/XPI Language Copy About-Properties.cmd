@echo off
title XPI Language Copy About-Properties 1.0.3
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#              Copyright(c) 2016 8pecxstudios             #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#                      8pecxstudios                       #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
if not exist "_XPI_Folder" goto :end
set InputPath=_XPI_Folder
set PatchFile=_Language-patches

for /f %%f in ('dir /b "%InputPath%"') do (
	if exist "%PatchFile%\%%~nf.aboutDialog.properties" (
		copy /y "%PatchFile%\%%~nf.aboutDialog.properties" "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\aboutDialog.properties"
	) else (
		copy /y "%PatchFile%\en-US.aboutDialog.properties" "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\aboutDialog.properties"
	)
)
exit /b %ERRORLEVEL%