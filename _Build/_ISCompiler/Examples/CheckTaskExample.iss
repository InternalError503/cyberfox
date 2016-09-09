; -- CheckTaskExample.iss --
; Demonstrates checking for task in task scheduler windows 7 - 10

[Setup]
AppName=My Program
AppVersion=1.5
DefaultDirName={pf}\My Program
DefaultGroupName=My Program
UninstallDisplayIcon={app}\MyProg.exe
Compression=lzma2
SolidCompression=yes
OutputDir=userdocs:Inno Setup Examples Output

[Files]
Source: "MyProg.exe"; DestDir: "{app}"
Source: "MyProg.chm"; DestDir: "{app}"
Source: "Readme.txt"; DestDir: "{app}"; Flags: isreadme

[Icons]
Name: "{group}\My Program"; Filename: "{app}\MyProg.exe"

[code]
//Check for task in task scheduler windows 7 - 10 (Boolean)
function TaskExist(const TaskName : String): Boolean;	
	var 
		rootFolder: Variant;
		objTask: Variant;
		TScheduler: Variant;
	begin
		Result := false;
	try
		TScheduler := CreateOleObject('Schedule.Service');
		TScheduler.Connect();
		rootFolder := TScheduler.GetFolder('\');
		objTask := rootFolder.GetTask(TaskName);
	finally
	    objTask := Unassigned;
		rootFolder := Unassigned;
		TScheduler := Unassigned;
		Result := true;
	except
	    objTask := Unassigned;
		rootFolder := Unassigned;
		TScheduler := Unassigned;
		// Catch the exception, dump it to error log if /log set, and continue.
		GetExceptionMessage;
		Result := false;
	end;	
end;

//Usage example
procedure CurPageChanged(CurPageID: Integer);
	begin
		if CurPageID = wpSelectTasks then
	begin
		// If the task is in a folder use the folder name then backslash task name 'FOLDER\TASKNAME'
		// If the task has no folder just use the task name 'TASKNAME'
		if (TaskExist('TASKNAME')) then
		begin
			msgbox('Your task was found!', mbInformation, MB_OK)
		end
		else begin
			msgbox('Your task was not found!', mbInformation, MB_OK)
		end;
	end;
end;	