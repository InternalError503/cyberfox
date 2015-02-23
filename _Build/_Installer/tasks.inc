[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1
Name: "DefaultAustralis"; Description: "{cm:AustralisDescription}"; GroupDescription: "{cm:AustralisGroupDescription}"
#if PackageType == "amd86" || PackageType == "amd64" || PackageType == "intel86" || PackageType == "intel64"
Name: "DefaultAboutHomepage"; Description: "{cm:DefaultAboutHomepageDescription}"; GroupDescription: "{cm:DefaultAboutHomepageGroupDescription}"; Flags: unchecked
#endif