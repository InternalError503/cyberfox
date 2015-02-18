Here we have added a way to the new build system to just generate the installer script to quickly debug it.
How it works is from reading `*.txt` that contains the list of scripts to compile together.

For more information on a specific commands, See below

| Command | Description |
------------- | -------------
--PRELIST | *Path to the preprocessor list.
--OUTPUT | *Path to output the generated installer script.
--HELP | Shows helpful information.

For items marked with `*` are required parameters, all parameters must be set.

#### Example preprocessor.txt:
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
__BuildInstallScript.exe__ reads each item in __`preprocessor list`__ then builds __`installer script`__, It joins all sections of the installer script into one compilable script.

Now in the case of __`customMessages.64.inc`__ this will require it to be changed to __`customMessages.86.inc`__ for x86 install script generation.

__BuildInstallScript.exe__ has 3 defined exit codes: 
- (0) [Success] all tasks completed successfully
- (1) [Error] something has gone wrong or was incorrectly configured.
- (2) when help documentation was shown.

__Note:__ BuildInstallScript.exe does not generate the app.config parameters for (____ARCH____), 
(____PACKAGE____), (____VERSION____) or (____SIGNTOOL____) for script compilation see Readme-BuildISS.md.

See _BuildInstallScript-Example.bat for usage example.