@echo off

title XPI Language Modifiy extensions.dtd Version: 1.0 
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
if not exist "_Extensions" mkdir "_Extensions"
set OutputPath=_Extensions
set InputPath=_XPI_Folder
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Copy extensions.dtd                #
ECHO.#        Press 2 to Update extensions.dtd                     #
ECHO.#        Press 3 to exit                     #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Copy extensions.dtd 
ECHO.2. Update extensions.dtd 
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
for /f %%f in ('dir /b "%InputPath%"') do copy /y "%InputPath%\%%f\chrome\%%~nf\locale\%%~nf\mozapps\extensions\extensions.dtd" "%OutputPath%\%%~nf.extensions.dtd" 
exit /b %ERRORLEVEL%
:upinst
if not exist %InputPath% goto :eof
cls
for /f %%f in ('dir /b "%InputPath%"') do copy /y  "%OutputPath%\%%~nf.extensions.dtd" "%InputPath%\%%f\chrome\%%~nf\locale\%%~nf\mozapps\extensions\extensions.dtd"
exit /b %ERRORLEVEL%