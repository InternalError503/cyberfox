Here we have added a way to the new build system to just generate the installer script to quickly debug it.
How it works is from reading `preprocessor.txt`
```
app.config
setup.inc
languages.inc
messages.inc
customMessages.64.inc
tasks.inc
files.inc
icons.inc
registry.registry
code.inc
run.inc
```
__BuildInstallScript.exe__ reads each item in __`preprocessor.txt`__ then builds __`installscript.iss`__, It joins all sections of the installer script into one compilable script called __`installscript.iss`__

Now in the case of __`customMessages.64.inc`__ this will require it to be changed to __`customMessages.86.inc`__ for x86 install script generation.

__BuildInstallScript.exe__ has 2 defined exit codes (0) success (1) error failed

__Note:__ BuildInstallScript.exe does not generate the app.config parameters for (____ARCH____), 
(____PACKAGE____), (____VERSION____) or (____SIGNTOOL____).