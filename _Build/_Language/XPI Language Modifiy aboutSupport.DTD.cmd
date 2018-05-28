@echo off

title XPI Language Modifiy aboutSupport.dtd Version: 1.0 
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
if not exist "_AboutSupport" mkdir "_AboutSupport"
set OutputPath=_AboutSupport
set InputPath=_XPI_Folder
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Copy aboutSupport.dtd                #
ECHO.#        Press 2 to Update aboutSupport.dtd                     #
ECHO.#        Press 3 to exit                     #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Copy aboutSupport.dtd 
ECHO.2. Update aboutSupport.dtd 
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
for /f %%f in ('dir /b "%InputPath%"') do copy /y /z "%InputPath%\%%f\chrome\%%~nf\locale\%%~nf\global\aboutSupport.dtd" "%OutputPath%\%%~nf.aboutSupport.dtd" 
exit /b %ERRORLEVEL%
:upinst
if not exist %InputPath% goto :eof
cls
for /f %%f in ('dir /b "%InputPath%"') do copy /y /z "%OutputPath%\%%~nf.aboutSupport.dtd" "%InputPath%\%%f\chrome\%%~nf\locale\%%~nf\global\aboutSupport.dtd"
exit /b %ERRORLEVEL%