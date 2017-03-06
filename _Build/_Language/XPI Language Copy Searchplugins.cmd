@echo off
title XPI Language Copy Searchplugins 1.0
ECHO.
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
if not exist "_XPI_Folder" goto :end
set InputPath=_XPI_Folder
set Plugins=_SearchPlugins

for /f %%f in ('dir /b "%InputPath%"') do (
	copy /y "%Plugins%\*.*" "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\searchplugins\"
)
exit /b %ERRORLEVEL%