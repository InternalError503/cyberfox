@echo off

title XPI language modifiy browser.properties Version: 1.0 
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#              Copyright(c) 2018 8pecxstudios             #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#                      8pecxstudios                       #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
set CD=%~DP0
set folder=_BrowserProperties
if not exist "%folder%" mkdir "%folder%"
set OutputPath=%folder%
set InputPath=_XPI_Folder
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Copy browser.properties                #
ECHO.#        Press 2 to Update browser.properties                   #
ECHO.#        Press 3 to exit                     #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Copy browser.properties
ECHO.2. Update browser.properties
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
for /f %%f in ('dir /b %InputPath%') do copy /y /z "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\browser.properties" "%OutputPath%\%%~nf.browser.properties" 
exit /b %ERRORLEVEL%
:upinst
if not exist %InputPath% goto :eof
for /f %%f in ('dir /b %InputPath%') do copy /y /z "%OutputPath%\%%~nf.browser.properties" "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\browser.properties"
exit /b %ERRORLEVEL%