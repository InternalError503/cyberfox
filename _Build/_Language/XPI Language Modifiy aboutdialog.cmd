@echo off

title XPI Language Modifiy aboutDialog.dtd Version: 1.0 
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#              Copyright(c) 2015 8pecxstudios             #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#                      8pecxstudios                       #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
set CD=%~DP0
if not exist "_aboutDialog" mkdir "_aboutDialog"
set OutputPath=_aboutDialog
set InputPath=_XPI_Folder
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Copy aboutDialog.dtd                #
ECHO.#        Press 2 to Update aboutDialogdtd                     #
ECHO.#        Press 3 to exit                     #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Copy aboutDialog.dtd 
ECHO.2. Update aboutDialog.dtd 
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
for /f %%f in ('dir /b "%InputPath%"') do copy /y "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\aboutDialog.dtd" "%OutputPath%\%%~nf.aboutDialog.dtd" 
exit /b %ERRORLEVEL%
:upinst
if not exist %InputPath% goto :eof
cls
for /f %%f in ('dir /b "%InputPath%"') do copy /y  "%OutputPath%\%%~nf.aboutDialog.dtd" "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\aboutDialog.dtd"
exit /b %ERRORLEVEL%