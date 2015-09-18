[Run]
Filename: "{tmp}\7za.exe"; Parameters: "x -mmt -aoa -o""{app}"" ""{tmp}\distribution.7z""";  Flags: runhidden; Description: "{cm:InstallingDocumentation}"; StatusMsg: "{cm:InstallingDocumentationStatus}"; Tasks: DefaultAustralis
#if PackageType == "amd86" || PackageType == "amd64" || PackageType == "intel86" || PackageType == "intel64"
Filename: "{app}\uninstall\helper.exe"; Parameters: "/SetAsDefaultAppUser"; WorkingDir: "{app}"; Flags: nowait postinstall skipifsilent; Description: "{cm:SetBrowserDefaults}"; OnlyBelowVersion: 0,6.3
#endif
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"
