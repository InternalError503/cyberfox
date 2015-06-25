@echo off
:top
title XPI Language Unpacker Version: 2.0.2
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
set DestinPath=%CD%_XPI_Folder
set OutputPath=..\_Installation\Language
if not exist "..\_7ZipPortable\App\7-Zip\7za.exe" goto :bye
set SevenZip=..\_7ZipPortable\App\7-Zip\7za.exe
set Originals=%CD%_Originals
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press 1 to Create directory tree                 #
ECHO.#        Press 2 to Extract xpi files.                    #
ECHO.#        Press 3 to Package xpi files                     #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.1. Create directory tree.
ECHO.2. Extract xpi files.
ECHO.3. Package xpi files.
ECHO.Any Key. Cancel.             
ECHO.----------- 
SET /P uin=Choose an option (1,2,3)? 
if /i {%uin%}=={1} (goto :createtree)
if /i {%uin%}=={2} (goto :next) 
if /i {%uin%}=={3} (goto :package)
goto :exit

:createtree
cls
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press y to Create directory tree                 #
ECHO.#        Press n to Exit.                                 #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.y. Confirm.
ECHO.n. Cancel.            
ECHO.----------- 
SET /P gTask=Do you want to create tree (Y/N)? 
if /i {%gTask%}=={y} (goto :doTask)
if /i {%gTask%}=={yes} (goto :doTask) 
if /i {%gTask%}=={n} (goto :exit)
if /i {%gTask%}=={no} (goto :exit)
goto :exit

:doTask
@echo off
for /f %%f in ('dir /b "%Originals%"') do md "%DestinPath%\%%f"
for /f %%f in ('dir /b "%Originals%"') do copy /y "%Originals%\%%f" "%DestinPath%\%%f" 
goto :next

echo.
echo.
echo.


:next
cls
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press y to Extract packs                         #
ECHO.#        Press n to Exit.                                 #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.y. Confirm.
ECHO.n. Cancel.            
ECHO.----------- 
SET /P cTask=Do you want to extract packs (Y/N)? 
if /i {%cTask%}=={y} (goto :extract)
if /i {%cTask%}=={yes} (goto :extract) 
if /i {%cTask%}=={n} (goto :exit)
if /i {%cTask%}=={no} (goto :exit)
goto :exit

:extract
for /f %%f in ('dir /b "%DestinPath%"') do %SevenZip% x "%DestinPath%\%%f\%%f" -o"%DestinPath%\%%f\"
goto :cleanup

:cleanup
for /f %%f in ('dir /b "%DestinPath%"') do del "%DestinPath%\%%f\%%f"
goto :package

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
for /f %%f in ('dir /b "%DestinPath%"') do %SevenZip% a -tzip "%DestinPath%\%%f\%%f" "%CD%_XPI_Folder\%%f\*"
::----
if not exist "%OutputPath%" mkdir "%OutputPath%"
for /f %%f in ('dir /b "%DestinPath%"') do copy /y "%DestinPath%\%%f\%%f" "%OutputPath%\"

:exit
cls
ECHO.
ECHO.###########################################################
ECHO.#                                                         #
ECHO.#                 Please Select Option                    #
ECHO.#         ---------------------------------------         #
ECHO.#                                                         #
ECHO.#        Press y to Exit                                  #
ECHO.#        Press n to Return to start.                      #
ECHO.#                                                         #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
ECHO.----------- 
ECHO.y. Confirm.
ECHO.n. Cancel.            
ECHO.----------- 
SET /P jTask=Do you want to exit (Y/N)? 
if /i {%jTask%}=={y} (goto :bye)
if /i {%jTask%}=={yes} (goto :bye)
if /i {%jTask%}=={n} (goto :top)
if /i {%jTask%}=={no} (goto :top)

:bye
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
ECHO.#             Copyright(c) 2014 8pecxstudios              #
ECHO.#         ---------------------------------------         #
ECHO.###########################################################
ECHO.
popd
exit /b %ERRORLEVEL%