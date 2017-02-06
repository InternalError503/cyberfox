@echo off

title XPI Language Modifiy newTab.DTD Version: 2.0 
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
if not exist "_newTabDTD" mkdir "_newTabDTD"
set OutputPath=_newTabDTD
set InputPath=_XPI_Folder
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Copy newTab.dtd                #
ECHO.#        Press 2 to Update newTab.dtd                     #
ECHO.#        Press 3 to exit                     #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Copy newTab.dtd 
ECHO.2. Update newTab.dtd 
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
for /f %%f in ('dir /b "%InputPath%"') do copy /y "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\newTab.dtd" "%OutputPath%\%%~nf.newTab.dtd" 
exit /b %ERRORLEVEL%
:upinst
if not exist %InputPath% goto :eof
cls
for /f %%f in ('dir /b "%InputPath%"') do copy /y  "%OutputPath%\%%~nf.newTab.dtd" "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\newTab.dtd"
exit /b %ERRORLEVEL%