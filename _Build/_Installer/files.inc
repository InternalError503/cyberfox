[Files]
Source: "{content}\browser\{#PackageType}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{content}\omni\{#PackageType}\omni.ja"; DestDir: "{app}\browser\"; Flags: ignoreversion; Tasks: DefaultAboutHomepage
Source: "{content}\ThirdParty\7za.exe"; DestDir: "{tmp}"; Tasks: DefaultAustralis
Source: "{content}\ThirdParty\license.txt"; DestDir: "{tmp}"; Tasks: DefaultAustralis
Source: "{content}\ThirdParty\distribution.7z"; DestDir: "{tmp}"; Tasks: DefaultAustralis