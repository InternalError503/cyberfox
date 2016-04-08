[Run]
#if PackageType == "amd86" || PackageType == "amd64" || PackageType == "intel86" || PackageType == "intel64"
Filename: "{app}\uninstall\helper.exe"; Parameters: "/SetAsDefaultAppUser"; WorkingDir: "{app}"; Flags: nowait postinstall skipifsilent; Description: "{cm:SetBrowserDefaults}"; OnlyBelowVersion: 0,10.0
#endif
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"
