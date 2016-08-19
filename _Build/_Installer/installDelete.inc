[InstallDelete]
Type: filesandordirs; Name: "{app}\distribution"
Type: files; Name: "{app}\browser\features\CTR@8pecxstudios.com.xpi"
Type: files; Name: "{app}\browser\features\loop@mozilla.org.xpi"
Type: files; Name: "{app}\browser\features\firefox@getpocket.com.xpi"
#if True == VS2015
Type: files; Name: "{app}\msvcr120.dll"
Type: files; Name: "{app}\msvcp120.dll"
Type: files; Name: "{app}\sandboxbroker.dll"
#endif