[Setup]
#if Arch == "i368"
#if PackageType == "beta86"
AppId={{A7689C89-E92D-4051-A3B7-92C92DA5D1DF}
AppName={#MyAppName} (x86)
#else
AppId={{DA42BA39-9916-4F32-83AC-27AAE5CFA09E}
AppName={#MyAppName} (x86)
#endif
#elif Arch == "amd64"
#if PackageType == "beta64"
AppId={{A7689C89-E92D-4051-A3B7-92C92DA5D1DF}
AppName={#MyAppName}
#else
AppId={{5EFB52C0-4EC9-46B4-80EB-8432C6599641}
AppName={#MyAppName}
#endif
#endif
#define UNINSTKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\"+SetupSetting("AppId")+"_is1"
#if Arch == "i368"
#define RegPath "Software\Clients\StartMenuInternet"
#else
#define RegPath "Software\Wow6432Node\Clients\StartMenuInternet"
#endif
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
#if Arch == "i368"
DefaultGroupName={#MyAppName} (x86)
#elif Arch == "amd64"
DefaultGroupName={#MyAppName}
#endif
LicenseFile={content}\setupFiles\eula.rtf
OutputBaseFilename={#PackageOutPutName}
SetupIconFile={#PackageBranding}\{#MyAppName}.ico
#if Arch == "i368"
Compression=lzma2/ultra
#elif Arch == "amd64"
Compression=lzma2/ultra64
#endif
SolidCompression=yes
AlwaysUsePersonalGroup=True
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppDescription} {#MyAppDescriptionB}
VersionInfoTextVersion={#MyAppVersion}
VersionInfoCopyright={#MyAppCopyright}
#if Arch == "i368"
VersionInfoProductName={#MyAppName} (x86)
#elif Arch == "amd64"
VersionInfoProductName={#MyAppName}
#endif
VersionInfoProductVersion={#MyAppVersion}
VersionInfoProductTextVersion={#MyAppVersion}
#if True == SignedInstall
SignTool=__SIGNTOOL__
SignedUnInstaller=yes
#endif
#if Arch == "i368"
InternalCompressLevel=ultra
#else
InternalCompressLevel=ultra64
#endif
AppCopyright={#MyAppPublisher}
AppComments={#MyAppDescriptionB}
AppContact={#MyAppContact}
UninstallDisplayName={#MyAppDescription}
UninstallDisplayIcon={app}\{#MyAppExeName},5
#if Arch == "amd64"
ArchitecturesInstallIn64BitMode=x64
#endif
DisableDirPage=auto
DisableProgramGroupPage=auto
AllowNoIcons=True
WizardImageBackColor=clWindowText
WizardImageFile={#PackageBranding}\WizModernImage.bmp
WizardSmallImageFile={#PackageBranding}\WizModernSmallImage.bmp
OutputDir={#PackageOutPutPath}
MinVersion=0,6.0sp2