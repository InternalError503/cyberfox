$packageName = 'cyberfox'
$installerType = 'exe'
$version = '51.0.1'
$url = "https://8pecxstudios.com/download/latest/Cyberfox-${version}.en-US.win32.intel.exe"
$url64 = "https://8pecxstudios.com/download/latest/Cyberfox-${version}.en-US.win64-x86_64.intel.exe"
$silentArgs = '/VERYSILENT'
$validExitCodes = @(0) 
$is64bit = (Get-ProcessorBits) -eq 64

if ($is64bit) {
	Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes
} else {
	Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"  -validExitCodes $validExitCodes
}