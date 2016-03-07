$packageName = 'cyberfox'
$installerType = 'exe'
$silentArgs = '/VERYSILENT'
$unpath = "$Env:ProgramFiles\${packageName}\unins000.exe"
$validExitCodes = @(0) 

Uninstall-ChocolateyPackage $packageName $installerType $silentArgs $unpath -validExitCodes $validExitCodes
