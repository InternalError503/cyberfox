[Files]
#if PackageType == "amd86" || PackageType == "amd64" || PackageType == "intel86" || PackageType == "intel64"
Source: "{content}\browser\{#PackageType}\browser\components\browsercomps.dll"; DestDir: "{app}\browser\components"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\browser\components\components.manifest"; DestDir: "{app}\browser\components"; Flags: ignoreversion
#endif 
Source: "{content}\browser\{#PackageType}\browser\extensions\{972ce4c6-7e08-4474-a285-3208198ce6fd}.xpi"; DestDir: "{app}\browser\extensions"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\features\CTR@8pecxstudios.com.xpi"; DestDir: "{app}\browser\features"; Tasks: cyberctr; Flags: promptifolder replacesameversion
#if PackageType == "beta86" || PackageType == "beta64"
Source: "{content}\browser\{#PackageType}\browser\features\disableSHA1rollout@mozilla.org.xpi"; DestDir: "{app}\browser\features"; Flags: promptifolder replacesameversion
#endif 
Source: "{content}\browser\{#PackageType}\browser\features\firefox@getpocket.com.xpi"; DestDir: "{app}\browser\features"; Tasks: pocket; Flags: promptifolder replacesameversion
Source: "{content}\browser\{#PackageType}\browser\features\langpack-*@8pecxstudios.com.xpi"; DestDir: "{app}\browser\features"; Tasks: languages; Flags: promptifolder replacesameversion
Source: "{content}\browser\{#PackageType}\browser\VisualElements\VisualElements_70.png"; DestDir: "{app}\browser\VisualElements"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\VisualElements\VisualElements_150.png"; DestDir: "{app}\browser\VisualElements"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\agents.json"; DestDir: "{app}\browser"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\blocklist.xml"; DestDir: "{app}\browser"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\chrome.manifest"; DestDir: "{app}\browser"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\omni.ja"; DestDir: "{app}\browser"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\ua-update.json"; DestDir: "{app}\browser"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\defaults\pref\channel-prefs.js"; DestDir: "{app}\defaults\pref"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\dictionaries\en-US.aff"; DestDir: "{app}\dictionaries"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\dictionaries\en-US.dic"; DestDir: "{app}\dictionaries"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\fonts\EmojiOneMozilla.ttf"; DestDir: "{app}\fonts"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\gmp-clearkey\0.1\clearkey.dll"; DestDir: "{app}\gmp-clearkey\0.1"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\gmp-clearkey\0.1\clearkey.info"; DestDir: "{app}\gmp-clearkey\0.1"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\uninstall\helper.exe"; DestDir: "{app}\uninstall"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\api-ms-win-*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\application.ini"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\Cyberfox.exe"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\Cyberfox.VisualElementsManifest.xml"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\d3dcompiler_47.dll"; DestDir: "{app}"; Flags: ignoreversion
#if Arch == "i368"
Source: "{content}\browser\{#PackageType}\D3DCompiler_43.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\wow_helper.exe"; DestDir: "{app}"; Flags: ignoreversion signonce
#endif 
Source: "{content}\browser\{#PackageType}\dependentlibs.list"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\freebl3.chk"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\freebl3.dll"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\lgpllibs.dll"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\libEGL.dll"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\libGLESv2.dll"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\mozavcodec.dll"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\mozavutil.dll"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\mozglue.dll"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\msvcp*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\nss3.dll"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\nssckbi.dll"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\nssdbm3.chk"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\nssdbm3.dll"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\omni.ja"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\platform.ini"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\plugin-container.exe"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\plugin-hang-ui.exe"; DestDir: "{app}"; Flags: ignoreversion signonce
#if PackageType == "amd86" || PackageType == "amd64" || PackageType == "intel86" || PackageType == "intel64"
Source: "{content}\browser\{#PackageType}\precomplete"; DestDir: "{app}"; Flags: ignoreversion
#endif
Source: "{content}\browser\{#PackageType}\removed-files"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\softokn3.chk"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\softokn3.dll"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\ucrtbase.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\update.ini"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\updater.exe"; DestDir: "{app}"; Flags: ignoreversion signonce
Source: "{content}\browser\{#PackageType}\vcruntime*.dll"; DestDir: "{app}"; Flags: ignoreversion
#if PackageType == "amd86" || PackageType == "amd64"
Source: "{content}\browser\{#PackageType}\vcomp*.dll"; DestDir: "{app}"; Flags: ignoreversion
#endif
Source: "{content}\browser\{#PackageType}\xul.dll"; DestDir: "{app}"; Flags: ignoreversion signonce

Source: "{content}\browser\{#PackageType}\voucher.bin"; DestDir: "{app}"; Flags: ignoreversion