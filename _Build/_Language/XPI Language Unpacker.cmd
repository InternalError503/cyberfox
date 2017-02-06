@echo off
:top
title XPI Language Unpacker Version: 2.0.5
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
set DestinPath=%CD%_XPI_Folder
set OutputPath=..\_Installation\Language
if not exist "..\_7ZipPortable\App\7-Zip\7za.exe" goto :exit
set SevenZip=..\_7ZipPortable\App\7-Zip\7za.exe
set Originals=%CD%_Originals
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Create directory tree                 #
ECHO.#        Press 2 to Package xpi files                    #
ECHO.#                                                                     #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Create directory tree.
ECHO.2. Package xpi files.
ECHO.Any Key. Cancel.             
ECHO.----------- 
SET /P uin=Choose an option (1,2)? 
if /i {%uin%}=={1} (goto :createtree)
if /i {%uin%}=={2} (goto :package)
goto :exit

:createtree
cls
@echo off
for /f %%f in ('dir /b "%Originals%"') do md "%DestinPath%\%%f"
for /f %%f in ('dir /b "%Originals%"') do copy /y "%Originals%\%%f" "%DestinPath%\%%f" 
goto :extract

:extract
for /f %%f in ('dir /b "%DestinPath%"') do %SevenZip% x -mmt "%DestinPath%\%%f\%%f" -o"%DestinPath%\%%f\"
for /f %%f in ('dir /b "%DestinPath%"') do del "%DestinPath%\%%f\%%f"
goto :exit

:package
cls
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press y to Package packs                         #
ECHO.#        Press n to Exit.                                 #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.y. Confirm.
ECHO.n. Cancel.            
ECHO.----------- 
SET /P eTask=Do you want to package (Y/N)? 
if /i {%eTask%}=={y} (goto :fTask)
if /i {%eTask%}=={yes} (goto :fTask) 
if /i {%eTask%}=={n} (goto :exit)
if /i {%eTask%}=={no} (goto :exit)
goto :exit

:fTask
for /f %%f in ('dir /b "%DestinPath%"') do if exist "%DestinPath%\%%f\%%f" del "%DestinPath%\%%f\%%f"
::----
for /f %%f in ('dir /b "%DestinPath%"') do %SevenZip% a -mmt -mx9 -tzip "%DestinPath%\%%f\%%f" "%CD%_XPI_Folder\%%f\*"
::----
if not exist "%OutputPath%" mkdir "%OutputPath%"
for /f %%f in ('dir /b "%DestinPath%"') do copy /y "%DestinPath%\%%f\%%f" "%OutputPath%\"
::----
for /f %%f in ('dir /b "%DestinPath%"') do del "%DestinPath%\%%f\%%f"

:exit
cls
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                    Complete Enjoy                       #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Thank you for using XPI Language Unpacker        #
ECHO.#                                                         #
ECHO.#                                                         #
ECHO.#             Copyright(c) 2017 8pecxstudios              #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
popd
exit /b %ERRORLEVEL%