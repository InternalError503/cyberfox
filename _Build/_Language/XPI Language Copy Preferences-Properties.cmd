@echo off

title XPI Language Modifiy preferences.properties Version: 1.1 
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
if not exist "_Preferences" mkdir "_Preferences"
set OutputPath=_Preferences
set InputPath=_XPI_Folder
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Copy preferences.properties           #
ECHO.#        Press 2 to Update preferences.properties         #
ECHO.#        Press 3 to exit                                  #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Copy preferences.properties
ECHO.2. Update preferences.properties
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
for /f %%f in ('dir /b "%InputPath%"') do copy /y "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\preferences\preferences.properties" "%OutputPath%\%%~nf.preferences.properties" 
exit /b %ERRORLEVEL%
:upinst
if not exist %InputPath% goto :eof
for /f %%f in ('dir /b "%InputPath%"') do copy /y  "%OutputPath%\%%~nf.preferences.properties" "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\preferences\preferences.properties"
exit /b %ERRORLEVEL%