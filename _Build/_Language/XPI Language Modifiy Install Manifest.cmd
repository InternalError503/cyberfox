@echo off
:top
title XPI Language Modifiy Install Manifest Version: 1.0.1
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
if not exist "_Install_Manifest" mkdir "_Install_Manifest"
set OutputPath=_Install_Manifest
set InputPath=_XPI_Folder
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Copy install.rdf                 #
ECHO.#        Press 2 to Update install.rdf.                    #
ECHO.#        Press 3 to exit                     #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Copy install.rdf.
ECHO.2. Update install.rdf.
ECHO.3. Exit.
ECHO.Any Key. Cancel.             
ECHO.----------- 
SET /P uin=Choose an option (1,2,3)? 
if /i {%uin%}=={1} (goto :copinst)
if /i {%uin%}=={2} (goto :upinst) 
if /i {%uin%}=={3} (goto :eof)
goto :eof



:copinst
if not exist %InputPath% goto :eof
cls
for /f %%f in ('dir /b "%InputPath%"') do copy /y "%InputPath%\%%f\install.rdf" "%OutputPath%\%%~nf.install.rdf" 
exit /b %ERRORLEVEL%
:upinst
if not exist %InputPath% goto :eof
cls
for /f %%f in ('dir /b "%InputPath%"') do del "%InputPath%\%%f\install.rdf" 
for /f %%f in ('dir /b "%InputPath%"') do copy /y  "%OutputPath%\%%~nf.install.rdf" "%InputPath%\%%f\"
for /f %%f in ('dir /b "%InputPath%"') do ren  "%InputPath%\%%f\%%~nf.install.rdf" "install.rdf"
exit /b %ERRORLEVEL%