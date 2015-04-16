[Code]
//Setup exit code for check for running function.
procedure ExitProcess(exitCode:integer);
  external 'ExitProcess@kernel32.dll stdcall';

//Check for running process before initializing the installer (Boolean)
function IsAppRunning(const FileName : string): Boolean;
	var
		FSWbemLocator: Variant;
			FWMIService   : Variant;
		FWbemObjectSet: Variant;
	begin
		Result := false;
	try
		FSWbemLocator := CreateOleObject('WBEMScripting.SWBEMLocator');
		FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
		FWbemObjectSet := FWMIService.ExecQuery(Format('SELECT Name FROM Win32_Process Where Name="%s"',[FileName]));
	finally
		Result := (FWbemObjectSet.Count > 0);			
		FWbemObjectSet := Unassigned;
		FWMIService := Unassigned;
		FSWbemLocator := Unassigned;			
	except
			// Catch the exception, dump it to error log if /log set, and continue
			GetExceptionMessage;
			Result := false;
		end;		
	end;
//Initialize installer run check for running process.	
#if Arch == "amd64"
//Check and warn user if installing Cyberfox x64 bit on x86 OS.
#endif
function InitializeSetup(): Boolean;
	begin
		if (IsAppRunning(ExpandConstant ('{#MyAppExeName}'))) then
	begin
		msgbox(ExpandConstant ('{cm:ProcessName}{cm:IsAppRunning}'), mbInformation, MB_OK)
			ExitProcess(9); // Our Exit code for process is running.
	end
		else
	begin
		Result := true;
#if Arch == "amd64"		
		if not IsWin64 then
		begin
			msgbox(ExpandConstant ('{cm:Isx64BitOS}'), mbInformation, MB_OK)
			ExitProcess(10); // Our Exit code for incompatible OS.
		end	
#endif		
	end
end;
//Make sure to remove start-menu entries during install as not to have many of the same short-cuts in other languages.
procedure CurStepChanged(CurStep: TSetupStep);
	begin
			if CurStep = ssInstall then
	begin
		if FileOrDirExists(ExpandConstant('{group}')) then
				DelTree(ExpandConstant('{group}'), True, True, True);
				end

end;
//Get the uninstall string;
function GetUninstallString: string;
	var
		sUnInstPath: string;
		sUnInstallString: String;
	begin
		Result := '';
		sUnInstPath := ExpandConstant('{#UNINSTKEY}');
		sUnInstallString := '';
	if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
		RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
	Result := sUnInstallString;
end;
//Check if install exists of not disable clean install check-box
procedure CurPageChanged(CurPageID: Integer);
	begin
		if CurPageID = wpSelectTasks then
	begin
		if not RegValueExists(HKEY_LOCAL_MACHINE, ExpandConstant('{#UNINSTKEY}'), 'UninstallString') then 
			begin
				WizardForm.TasksList.Checked[1] := False;
				WizardForm.TasksList.ItemEnabled[0] := False;
				WizardForm.TasksList.ItemEnabled[1] := False;
		end
		else begin
				WizardForm.TasksList.Checked[1] := False;
		end;
	end;
end;	

//Check if cleanInstall has been selected
function NextButtonClick(CurPageID: Integer): Boolean;
	var
		iResultCode: Integer;
		sUnInstallString: string;
	begin
		Result := True;
	if CurPageID = wpSelectTasks then
	begin
		if WizardForm.TasksList.Checked[1] then
			//Perform clean install and uninstall existing installation.
			if RegValueExists(HKEY_LOCAL_MACHINE, ExpandConstant('{#UNINSTKEY}'), 'UninstallString') then
				begin
					sUnInstallString := GetUninstallString();
					sUnInstallString :=  RemoveQuotes(sUnInstallString);
					Wizardform.NextButton.Enabled := False;
					Wizardform.BackButton.Enabled := False;
					WizardForm.CancelButton.Enabled := False;
			if Exec(ExpandConstant(sUnInstallString), '/VERYSILENT', '', SW_SHOW, ewWaitUntilTerminated, iResultCode) then
			begin
				//Sleep for 2 seconds to ensure IO operations have completed.
				sleep(2000)
			end
			else begin
				if UninstallSilent() then begin ExitProcess(11); end; // Our Exit code for clean install fail.			
			end
		end
	end;
end;
//Initialize uninstaller run check for process
function InitializeUninstall(): Boolean;
begin
  if (IsAppRunning(ExpandConstant ('{#MyAppExeName}'))) then
	begin
		msgbox(ExpandConstant ('{cm:ProcessName}{cm:IsAppRunningUninstall}'), mbInformation, MB_OK)
			ExitProcess(9); // Our Exit code for process is running.		
	end
		else
	begin
		Result := true;
	end
end;
//Make sure to remove distribution folder on uninstall, Get user input if they want to delete profile data.
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
	begin
		if CurUninstallStep = usPostUninstall then
	begin
	
	if not UninstallSilent() then
		begin
			if FileOrDirExists(ExpandConstant('{app}\distribution')) then
				DelTree(ExpandConstant('{app}'), True, True, True);
		
			if MsgBox(ExpandConstant('{cm:DeleteProfileData}'), mbConfirmation, MB_YESNO) = IDYES  then begin
			if MsgBox(ExpandConstant('{cm:ConfirmDeleteProfileData}'),mbConfirmation, MB_YESNO) = IDYES then begin
				begin
					if FileOrDirExists(ExpandConstant('{localappdata}\{#MyAppPublisher}\{#MyAppName}')) then
						DelTree(ExpandConstant('{localappdata}\{#MyAppPublisher}\{#MyAppName}'), True, True, True);
					if FileOrDirExists(ExpandConstant('{userappdata}\{#MyAppPublisher}')) then
						DelTree(ExpandConstant('{userappdata}\{#MyAppPublisher}'), True, True, True);
					end
				end	
			end
		end
		else
			if FileOrDirExists(ExpandConstant('{app}\distribution')) then
			begin
				DelTree(ExpandConstant('{app}'), True, True, True);
		end				
	end
end;