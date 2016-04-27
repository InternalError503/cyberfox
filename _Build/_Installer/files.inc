[Files]
Source: "{content}\browser\{#PackageType}\application.ini"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\Cyberfox.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\d3dcompiler_47.dll"; DestDir: "{app}"; Flags: ignoreversion
#if Arch == "i368"
Source: "{content}\browser\{#PackageType}\D3DCompiler_43.dll"; DestDir: "{app}"; Flags: ignoreversion
#endif 
Source: "{content}\browser\{#PackageType}\dependentlibs.list"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\freebl3.chk"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\freebl3.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\icudt*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\icuin*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\icuuc*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\lgpllibs.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\libEGL.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\libGLESv2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\mozavcodec.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\mozavutil.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\mozglue.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\msvcp*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\msvcr*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\nss3.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\nssckbi.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\nssdbm3.chk"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\nssdbm3.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\omni.ja"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\platform.ini"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\plugin-container.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\plugin-hang-ui.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\precomplete"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\removed-files"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\sandboxbroker.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\SHA512SUMS"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\softokn3.chk"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\softokn3.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\xul.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\agents.json"; DestDir: "{app}\browser"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\blocklist.xml"; DestDir: "{app}\browser"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\chrome.manifest"; DestDir: "{app}\browser"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\omni.ja"; DestDir: "{app}\browser"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\ua-update.json"; DestDir: "{app}\browser"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\components\browsercomps.dll"; DestDir: "{app}\browser\components"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\components\components.manifest"; DestDir: "{app}\browser\components"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\extensions\{972ce4c6-7e08-4474-a285-3208198ce6fd}.xpi"; DestDir: "{app}\browser\extensions"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\browser\features\CTR@8pecxstudios.com.xpi"; DestDir: "{app}\browser\features"; Tasks: cyberctr; Flags: promptifolder replacesameversio
Source: "{content}\browser\{#PackageType}\browser\features\loop@mozilla.org.xpi"; DestDir: "{app}\browser\features"; Tasks: loop; Flags: promptifolder replacesameversion
Source: "{content}\browser\{#PackageType}\browser\features\firefox@getpocket.com.xpi"; DestDir: "{app}\browser\features"; Tasks: pocket; Flags: promptifolder replacesameversion
Source: "{content}\browser\{#PackageType}\defaults\pref\channel-prefs.js"; DestDir: "{app}\defaults\pref"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\dictionaries\en-US.aff"; DestDir: "{app}\dictionaries"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\dictionaries\en-US.dic"; DestDir: "{app}\dictionaries"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\gmp-clearkey\0.1\clearkey.dll"; DestDir: "{app}\gmp-clearkey\0.1"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\gmp-clearkey\0.1\clearkey.info"; DestDir: "{app}\gmp-clearkey\0.1"; Flags: ignoreversion
Source: "{content}\browser\{#PackageType}\uninstall\helper.exe"; DestDir: "{app}\uninstall"; Flags: ignoreversion
#if PackageType == "amd86" || PackageType == "amd64"
Source: "{content}\browser\{#PackageType}\vcomp*.dll"; DestDir: "{app}"; Flags: ignoreversion
#endif
