set CD=%~DP0
set DestinPath=%CD%_XPI_Folder
for /f %%f in ('dir /b "%DestinPath%"') do del "%DestinPath%\%%f\browser\chrome\%%~nf\locale\browser\searchplugins\ddg.xml"
exit /b %ERRORLEVEL%