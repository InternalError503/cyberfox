@echo off
title XPI Language Compy About-Properties 1.0.1
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#              Copyright(c) 2014 8pecxstudios             #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#                      8pecxstudios                       #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
set CD=%~DP0
if not exist "_XPI_Folder" goto :end
set DestinPath=_XPI_Folder
for /f %%f in ('dir /b "%DestinPath%"') do copy /y  "%CD%aboutDialog.properties" "%DestinPath%\%%f\browser\chrome\%%~nf\locale\browser\"
exit /b %ERRORLEVEL%