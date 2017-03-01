@echo off

title XPI Language Modifiy list.json Version: 1.0 
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
set CD=%~DP0
if not exist "_listJSON" mkdir "_listJSON"
set OutputPath=_listJSON
set InputPath=_XPI_Folder
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Copy list.json                #
ECHO.#        Press 2 to Update list.json                    #
ECHO.#        Press 3 to exit                     #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Copy list.json
ECHO.2. Update list.json
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
for /f %%f in ('dir /b "%InputPath%"') do copy /y "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\searchplugins\list.json" "%OutputPath%\%%~nf.list.json" 
exit /b %ERRORLEVEL%
:upinst
if not exist %InputPath% goto :eof
cls
for /f %%f in ('dir /b "%InputPath%"') do copy /y  "%OutputPath%\%%~nf.list.json" "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\searchplugins\list.json"
exit /b %ERRORLEVEL%