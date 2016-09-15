@ECHO OFF
TITLE XPI Language Copy Bookmarks Version: 2.4
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
SET CD=%~DP0
IF NOT EXIST "_XPI_Folder" GOTO :END
SET INPUTPATH=_XPI_Folder
SET PATCHFILE=_Language-patches

FOR /F %%F IN ('DIR /B "%INPUTPATH%"') DO (
	IF EXIST "%PATCHFILE%\%%~NF.bookmarks.html" (
		COPY /Y "%PATCHFILE%\%%~NF.bookmarks.html" "%INPUTPATH%\%%F\browser\defaults\profile"
	) ELSE (
		COPY /Y "%PATCHFILE%\en-US.bookmarks.html" "%INPUTPATH%\%%F\browser\defaults\profile"
	)
)
EXIT /B %ERRORLEVEL%