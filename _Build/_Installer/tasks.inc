[Tasks]
;Note when changing task ordering, Need to update array order for clean install checkbox in code section.
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "cleaninstall"; Description: "{cm:CleanInstallDescription}"; GroupDescription: "{cm:CleanInstallGroupDescription}"; Flags: dontinheritcheck unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1
Name: "cyberctr"; Description: "{cm:CyberCTRInstallDescription}"; GroupDescription: "{cm:SystemAddonsGroupDescription}"
Name: "loop"; Description: "{cm:LoopInstallDescription}"; GroupDescription: "{cm:SystemAddonsGroupDescription}"; Flags: unchecked
#if PackageType == "beta86" || PackageType == "beta64"
Name: "pocket"; Description: "{cm:PocketInstallDescription}"; GroupDescription: "{cm:SystemAddonsGroupDescription}"; Flags: unchecked
#endif