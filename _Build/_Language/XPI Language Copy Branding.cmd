@echo off

title XPI Language Modifiy Branding Version: 3.0 
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
if not exist "_Branding" mkdir "_Branding"
set OutputPath=_Branding
set Branding=_XPI_Branding
set PatchFile=_Language-patches
set InputPath=_XPI_Folder
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Copy Branding                         #
ECHO.#        Press 2 to Update Branding                       #
ECHO.#        Press 3 to exit                                  #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Copy Branding
ECHO.2. Update Branding
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
for /f %%f in ('dir /b "%InputPath%"') do copy /y "%InputPath%\%%f\browser\chrome\%%~nf\locale\branding\brand.dtd" "%OutputPath%\%%~nf.brand.dtd" 
for /f %%f in ('dir /b "%InputPath%"') do copy /y "%InputPath%\%%f\browser\chrome\%%~nf\locale\branding\brand.properties" "%OutputPath%\%%~nf.brand.properties"
for /f %%f in ('dir /b "%InputPath%"') do copy /y "%Branding%\brand.dtd" "%OutputPath%\%%~nf.brand.dtd" 
for /f %%f in ('dir /b "%InputPath%"') do copy /y "%Branding%\brand.properties" "%OutputPath%\%%~nf.brand.properties" 
for /f %%f in ('dir /b "%InputPath%"') do if exist "%PatchFile%\%%~nf.brand.dtd" copy /y "%PatchFile%\%%~nf.brand.dtd" "%OutputPath%\%%~nf.brand.dtd"
for /f %%f in ('dir /b "%InputPath%"') do if exist "%PatchFile%\%%~nf.brand.properties" copy /y "%PatchFile%\%%~nf.brand.properties" "%OutputPath%\%%~nf.brand.properties"
exit /b %ERRORLEVEL%

:upinst
if not exist %InputPath% goto :eof
for /f %%f in ('dir /b "%InputPath%"') do copy /y  "%OutputPath%\%%~nf.brand.dtd" "%InputPath%\%%f\browser\chrome\%%~nf\locale\branding\brand.dtd"
for /f %%f in ('dir /b "%InputPath%"') do copy /y  "%OutputPath%\%%~nf.brand.properties" "%InputPath%\%%f\browser\chrome\%%~nf\locale\branding\brand.properties"
exit /b %ERRORLEVEL%