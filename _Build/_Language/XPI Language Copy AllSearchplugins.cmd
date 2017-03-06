@echo off

title XPI Language Modifiy All Searchplugins Version: 1.0 
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
if not exist "_Searches" mkdir "_Searches"
set OutputPath=_Searches
set InputPath=_XPI_Folder
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Copy Searchplugins               #
ECHO.#        Press 2 to Update Searchplugins                   #
ECHO.#        Press 3 to exit                     #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Copy Searchplugins
ECHO.2. Update Searchplugins
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
for /f %%f in ('dir /b "%InputPath%"') do (
	mkdir "%OutputPath%\%%~nf"
	copy /y "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\searchplugins\*.*" "%OutputPath%\%%~nf\"
	del "%OutputPath%\%%~nf\duckduckgo.xml"
	del "%OutputPath%\%%~nf\ixquick.xml"
	del "%OutputPath%\%%~nf\list.json"
	del "%OutputPath%\%%~nf\privatelee.xml"
	del "%OutputPath%\%%~nf\qwant.xml"
	del "%OutputPath%\%%~nf\startpage.xml"
	del "%OutputPath%\%%~nf\unbubbleeu.xml"
	del "%OutputPath%\%%~nf\youtube.xml"
)
exit /b %ERRORLEVEL%
:upinst
if not exist %InputPath% goto :eof
cls
for /f %%f in ('dir /b "%InputPath%"') do (
	copy /y  "%OutputPath%\%%~nf\*.*" "%InputPath%\%%f\browser\chrome\%%~nf\locale\browser\searchplugins\"
)
exit /b %ERRORLEVEL%