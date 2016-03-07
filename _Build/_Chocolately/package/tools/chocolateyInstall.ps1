$packageName = 'cyberfox'
$installerType = 'exe'
$version = '44.0.2'
$url = "https://download.8pecxstudios.com/latest/Cyberfox-${version}.en-US.win32.intel.exe"
$url64 = "https://download.8pecxstudios.com/latest/Cyberfox-${version}.en-US.win64-x86_64.intel.exe"
$silentArgs = '/VERYSILENT'
$validExitCodes = @(0) 

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes