[InstallDelete]
Type: filesandordirs; Name: "{app}\distribution"
Type: files; Name: "{app}\browser\features\CTR@8pecxstudios.com.xpi"
Type: files; Name: "{app}\browser\features\loop@mozilla.org.xpi"
#if PackageType == "beta86" || PackageType == "beta64"
Type: files; Name: "{app}\browser\features\firefox@getpocket.com.xpi"
#endif