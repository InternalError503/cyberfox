@echo off
title XPI Language Compy Bookmarks Version: 2.0.2
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
for /f %%f in ('dir /b "%DestinPath%"') do copy /y "%CD%bookmarks.html" "%DestinPath%\%%f\browser\defaults\profile"
exit /b %ERRORLEVEL%