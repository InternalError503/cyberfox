@echo off

:top
title XPI Language Modifiy appstrings.properties Version: 1.0 
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
if not exist "_AppStrings" mkdir "_AppStrings"
set OutputPath=_AppStrings
set InputPath=_XPI_Folder
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Copy appstrings.properties                #
ECHO.#        Press 2 to Update appstrings.properties                   #
ECHO.#        Press 3 to exit                     #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Copy appstrings.properties
ECHO.2. Update appstrings.properties
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
for /f %%f in ('dir /b %InputPath%') do copy /y "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\appstrings.properties" "%OutputPath%\%%~nf.appstrings.properties" 
exit /b %ERRORLEVEL%
:upinst
if not exist %InputPath% goto :eof
for /f %%f in ('dir /b %InputPath%') do del "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\appstrings.properties" 
for /f %%f in ('dir /b %InputPath%') do copy /y  "%OutputPath%\%%~nf.appstrings.properties" "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\"
for /f %%f in ('dir /b %InputPath%') do ren  "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\%%~nf.appstrings.properties" "appstrings.properties"
exit /b %ERRORLEVEL%