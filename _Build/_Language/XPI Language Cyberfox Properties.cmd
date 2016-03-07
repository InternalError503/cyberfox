@echo off

title XPI Language Cyberfox Properties Version: 1.0 
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#              Copyright(c) 2016 8pecxstudios             #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#                      8pecxstudios                       #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
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
ECHO.#        Press 1 to Cyberfox Properties                        #
ECHO.#        Press 2 to exit                                  #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Copy Cyberfox Properties
ECHO.2. Exit.
ECHO.Any Key. Cancel.             
ECHO.----------- 
SET /P uin=Choose an option (1,2)? 
if /i {%uin%}=={1} (goto :copinst)
if /i {%uin%}=={2} (goto :eof)
goto :eof


:copinst
if not exist %InputPath% goto :eof

for /f %%f in ('dir /b "%InputPath%"') do (
	if exist "%PatchFile%\%%~nf.cyberfox.properties" (
		copy /y "%PatchFile%\%%~nf.cyberfox.properties" "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\cyberfox.properties"
	) else (
		copy /y "%PatchFile%\en-US.cyberfox.properties" "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\cyberfox.properties"
	)
)
exit /b %ERRORLEVEL%