#SingleInstance force
Gui, select:Add, Text, x10 y20 w160 h60, Select the backup to connect to.`n`n(The buttons for unreachable/`n offline backups are disabled.)
Gui, select:Add, Button, gSelect vSelect1 x40 y80 w20 h20, 1
Gui, select:Add, Button, gSelect vSelect2 x60 y80 w20 h20, 2
Gui, select:Add, Button, gSelect vSelect3 x80 y80 w20 h20, 3
Gui, select:Add, Button, gSelect vSelect4 x100 y80 w20 h20, 4
Gui, select:Add, Button, gSelect vSelect5 x120 y80 w20 h20, 5
If !FileExist("C:\Users\Public\")
	GuiControl, select:Disable, Select1
If !FileExist("\\INSERT_COMPURTER_NAME_HERE\Users\Public\")
	GuiControl, select:Disable, Select2
If !FileExist("\\INSERT_COMPURTER_NAME_HERE\Users\Public\")
	GuiControl, select:Disable, Select3
If !FileExist("\\INSERT_COMPURTER_NAME_HERE\Users\Public\")
	GuiControl, select:Disable, Select4
If !FileExist("\\INSERT_COMPURTER_NAME_HERE\Users\Public\")
	GuiControl, select:Disable, Select5
Gui, select:+ToolWindow +AlwaysOnTop
Gui, select:Show, w180, Select Backup
Return

Select:
Gui, select:Hide
If (A_GuiControl = "Select1") {
	FolderPath := "C:\Users\Public\Backup"
} else If (A_GuiControl = "Select2") {
	FolderPath := "\\INSERT_COMPURTER_NAME_HERE\Users\Public\Backup"
} else If (A_GuiControl = "Select3") {
	FolderPath := "\\INSERT_COMPURTER_NAME_HERE\Users\Public\Backup"
} else If (A_GuiControl = "Select4") {
	FolderPath := "\\INSERT_COMPURTER_NAME_HERE\Users\Public\Backup"
} else If (A_GuiControl = "Select5") {
	FolderPath := "\\INSERT_COMPURTER_NAME_HERE\Users\Public\Backup"
} else {
	MsgBox, 0, `t, An error has occurred setting the path.`nPlease try again.`n`nIf the problem persists`, talk to Alex.
	ExitApp
}
If FileExist(FolderPath . "\" . A_UserName . "_pass") {
	FileRead, ReadBackupPass, %FolderPath%\%A_UserName%_pass
	If !(ReadBackupPass = "none") {
		InputBox, InputPass, Open Backup, Please type in the password., HIDE
		If errorlevel
			ExitApp
		OpenPasswordLetters := StrSplit(InputPass)
		OpenPasswordHash := 1
		loop, % OpenPasswordLetters.MaxIndex()
			OpenPasswordHash *= Ord(OpenPasswordLetters[A_Index])
		If !(ReadBackupPass = OpenPasswordHash) {
			MsgBox, 0, Open Backup, Incorrect password!
			ExitApp
		}
	}
}
If !FileExist(FolderPath) {
	FileCreateDir, %FolderPath%
	Sleep, 100
	FileSetAttrib, +SH, %FolderPath%, 2, 0
}
If !FileExist(FolderPath . "\" . A_Username) {
	Gui, createbackup:Add, Text,, You do not have a folder here.`nIt either has yet to be made`,`nor was deleted.`n`nPlease set a password.
	Gui, createbackup:Add, Text, w150 x25 h20 y80, Type Password:
	Gui, createbackup:Add, Edit, r1 vPassword1 Password w150 x25 h20 y95
	Gui, createbackup:Add, Text, w150 x25 h20 y120, Confirm Password:
	Gui, createbackup:Add, Edit, r1 vPassword2 Password w150 x25 h20 y135
	Gui, createbackup:Add, Button, gEnterPass w100 x50 h20 y170, Submit Password
	Gui, createbackup:Add, Button, gNoSetPass w150 x25 h20 y200, Don't set a password
	Gui, createbackup:-SysMenu +ToolWindow +AlwaysOnTop
	Gui, createbackup:Show, w200 h230, Setup backup
	Return
}
If !FileExist(FolderPath . "\" . A_UserName . "_pass") {
	Gui, newpass:Add, Text,, This folder is missing`nthe set password.`n`nPlease set new a password.
	Gui, newpass:Add, Text, w150 x25 h20 y80, Type Password:
	Gui, newpass:Add, Edit, r1 vPassword1 Password w150 x25 h20 y95
	Gui, newpass:Add, Text, w150 x25 h20 y120, Confirm Password:
	Gui, newpass:Add, Edit, r1 vPassword2 Password w150 x25 h20 y135
	Gui, newpass:Add, Button, gEnterNewPass w100 x50 h20 y170, Submit Password
	Gui, newpass:Add, Button, gNoSetNewPass w150 x25 h20 y200, Don't set a password
	Gui, newpass:-SysMenu +ToolWindow +AlwaysOnTop
	Gui, newpass:Show, w200 h230, Set password
	Return
}
OpenFolder:
FolderPath := FolderPath . "\" . A_UserName
Gui, access:Default
Gui, access:Add, ListView, x0 y0 w400 h250 NoSortHdr -LV0x10 vFileList -Multi, Name|Added|Size
LV_ModifyCol(1, "200")
LV_ModifyCol(2, "100")
LV_ModifyCol(3, "75 Right")
Loop, Files, %FolderPath%\*.*, F
{
	FileGetTime, FileAddTime, A_LoopFileLongPath, M
	FileGetSize, FileSize, %A_LoopFileLongPath%, M
	ListFileSize := FileSize . " MB"
	If (FileSize = 0) {
		FileGetSize, FileSize, %A_LoopFileLongPath%, K
		ListFileSize := FileSize . " KB"
		If (FileSize = 0) {
			FileGetSize, FileSize, %A_LoopFileLongPath%
			ListFileSize := FileSize . "    B"
		}
	}
	LV_Add(, A_LoopFileName, FileAddTime, ListFileSize)
}
Gui, access:Add, Button, gOpen x80 y262 w60 h25, &Open
Gui, access:Add, Button, gUpload x140 y262 w60 h25, &Upload
Gui, access:Add, Button, gDownload x200 y262 w60 h25, Down&load
Gui, access:Add, Button, gDelete x260 y262 w60 h25, &Delete
Gui, access:Show, w400 h300, Backed up files
Return


Open:
SelectedRow := LV_GetNext()
LV_GetText(EntryFilename, SelectedRow, 1)
Run, "%FolderPath%\%EntryFilename%",, UseErrorLevel
If ErrorLevel
	MsgBox, 4096, Backup, No file selected!
Return


Download:
SelectedRow := LV_GetNext()
LV_GetText(EntryFilename, SelectedRow, 1)
FileCopy, %FolderPath%\%EntryFilename%, \\dc1\studnets$\%A_Username%\, 0
if ErrorLevel
	MsgBox, 0, `t, The file could not be copied.`nThe file already exists on your account.
FileSetAttrib, -SH, \\dc1\studnets$\%A_Username%\%EntryFilename%, 1, 0
Return

Upload:
FileSelectFile, UploadPathGet, M, \\dc1\students$\%A_Username%\, Select the file(s) to upload.
If ErrorLevel
	Return
Loop, parse, UploadPathGet, `n
{
	If (A_Index = "1") {
		UploadPath := A_LoopField
		Continue
	}
	If FileExist(FolderPath . "\" . A_LoopField) {
		MsgBox, 4, Upload File, The file already exists.`nOverwrite?
		IfMsgBox, Yes
			FileCopy, %UploadPath%\%A_LoopField%, %FolderPath%\*.*, 1
		else
			Continue
	} else {
		FileCopy, %UploadPath%\%A_LoopField%, %FolderPath%\*.*, 0
	}
	FileSetTime, %A_Now%, %FolderPath%\%A_LoopField%, M, 0, 0
	FileSetAttrib, +SH, %FolderPath%\%A_LoopField%, 0, 0
}
LV_Delete()
Loop, Files, %FolderPath%\*.*, F
{
	FileGetTime, FileAddTime, A_LoopFileLongPath, M
	FileGetSize, FileSize, %A_LoopFileLongPath%, M
	ListFileSize := FileSize . " MB"
	If (FileSize = 0) {
		FileGetSize, FileSize, %A_LoopFileLongPath%, K
		ListFileSize := FileSize . " KB"
		If (FileSize = 0) {
			FileGetSize, FileSize, %A_LoopFileLongPath%
			ListFileSize := FileSize . "    B"
		}
	}
	LV_Add(, A_LoopFileName, FileAddTime, ListFileSize)
}
MsgBox, 0, Upload File, File(s) uploaded!
Return

Delete:
SelectedRow := LV_GetNext()
LV_GetText(EntryFilename, SelectedRow, 1)
MsgBox, 4, Delete File, Are you sure you want to delete the file`n"%EntryFilename%"?
IfMsgBox, Yes
{
	FileDelete, %FolderPath%\%EntryFilename%
	LV_Delete()
	Loop, Files, %FolderPath%\*.*, F
	{
		FileGetTime, FileAddTime, A_LoopFileLongPath, M
		FileGetSize, FileSize, %A_LoopFileLongPath%, M
		ListFileSize := FileSize . " MB"
		If (FileSize = 0) {
			FileGetSize, FileSize, %A_LoopFileLongPath%, K
			ListFileSize := FileSize . " KB"
			If (FileSize = 0) {
				FileGetSize, FileSize, %A_LoopFileLongPath%
				ListFileSize := FileSize . "    B"
			}
		}
		LV_Add(, A_LoopFileName, FileAddTime, ListFileSize)
	}
}
Return

selectGuiClose:
accessGuiClose:
ExitApp
Return


EnterPass:
Gui, createbackup:Submit
If (Password1 = "") {
	Goto, NoSetPass
	Return
}
If (Password1 = Password2) {
	PasswordLetters := StrSplit(Password1)
	PasswordHash := 1
	loop, % PasswordLetters.MaxIndex()
		PasswordHash *= Ord(PasswordLetters[A_Index])
} else {
	MsgBox, 0, Setup backup., The passwords do not match.`nPlease try again.
	Gui, createbackup:Show, w200 h230, Setup backup
	Return
}
FileCreateDir, %FolderPath%\%A_UserName%
FileDelete, %FolderPath%\%A_UserName%_pass
FileAppend, %PasswordHash%, %FolderPath%\%A_UserName%_pass
Sleep, 100
FileSetAttrib, +SH, %FolderPath%\%A_UserName%, 2, 0
FileSetAttrib, +SH, %FolderPath%\%A_UserName%_pass, 0, 0
MsgBox, 0, Setup backup, The backup has been created.
Goto, OpenFolder
Return

NoSetPass:
Gui, createbackup:Hide
MsgBox, 4, Setup backup, Are you sure you don't want a password?`n`nWithout a password`, anyone on your account`ncan access & delete your backups!`n`nThe password protects your backups if`na staff member logs onto your account.
IfMsgBox, Yes
{
	FileCreateDir, %FolderPath%\%A_UserName%
	FileDelete, %FolderPath%\%A_UserName%_pass
	FileAppend, none, %FolderPath%\%A_UserName%_pass
	Sleep, 100
	FileSetAttrib, +SH, %FolderPath%\%A_UserName%, 2, 0
	FileSetAttrib, +SH, %FolderPath%\%A_UserName%_pass, 0, 0
	MsgBox, 0, Setup backup, The backup has been created without a password.
	Goto, OpenFolder
	Return
} else {
	Gui, createbackup:Show, w200 h230, Setup backup
	Return
}
Return


EnterNewPass:
Gui, newpass:Submit
If (Password1 = "") {
	Goto, NoSetNewPass
	Return
}
If (Password1 = Password2) {
	PasswordLetters := StrSplit(Password1)
	PasswordHash := 1
	loop, % PasswordLetters.MaxIndex()
		PasswordHash *= Ord(PasswordLetters[A_Index])
} else {
	MsgBox, 0, Set password., The passwords do not match.`nPlease try again.
	Gui, newpass:Show, w200 h230, Set password
	Return
}
FileCreateDir, %FolderPath%\%A_UserName%
FileDelete, %FolderPath%\%A_UserName%_pass
FileAppend, %PasswordHash%, %FolderPath%\%A_UserName%_pass
Sleep, 100
FileSetAttrib, +SH, %FolderPath%\%A_UserName%, 2, 0
FileSetAttrib, +SH, %FolderPath%\%A_UserName%_pass, 0, 0
MsgBox, 0, Set password, The password has been set.
Goto, OpenFolder
Return

NoSetNewPass:
Gui, newpass:Hide
MsgBox, 4, Set password, Are you sure you don't want a password?`n`nWithout a password`, anyone on your account`ncan access & delete your backups!`n`nThe password protects your backups if`na staff member logs onto your account.
IfMsgBox, Yes
{
	FileCreateDir, %FolderPath%\%A_UserName%
	FileDelete, %FolderPath%\%A_UserName%_pass
	FileAppend, none, %FolderPath%\%A_UserName%_pass
	Sleep, 100
	FileSetAttrib, +SH, %FolderPath%\%A_UserName%, 2, 0
	FileSetAttrib, +SH, %FolderPath%\%A_UserName%_pass, 0, 0
	MsgBox, 0, Set password, The backup was not given a new password.
	Goto, OpenFolder
	Return
} else {
	Gui, newpass:Show, w200 h230, Set password
	Return
}
Return
