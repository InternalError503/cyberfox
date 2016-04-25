[Run]
Filename: "{app}\uninstall\helper.exe"; Parameters: "/SetAsDefaultAppUser"; WorkingDir: "{app}"; Flags: nowait postinstall skipifsilent; Description: "{cm:SetBrowserDefaults}"; OnlyBelowVersion: 0,10.0
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"
