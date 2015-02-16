[Run]
Filename: "{tmp}\7za.exe"; Parameters: "x  -aoa -o""{app}"" ""{tmp}\distribution.7z""";  Flags: runhidden; Description: "{cm:InstallingDocumentation}"; StatusMsg: "{cm:InstallingDocumentationStatus}"; Tasks: DefaultAustralis
Filename: "{app}\uninstall\helper.exe"; Parameters: "/SetAsDefaultAppUser"; WorkingDir: "{app}"; Flags: nowait postinstall skipifsilent; Description: "{cm:SetBrowserDefaults}"
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"
