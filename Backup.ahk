#SingleInstance force
Gui, select:Add, Text, x10 y20 w160 h60, Select the backup to connect to.`n`n(The buttons for unreachable/`n offline backups are disabled.)
Gui, select:Add, Button, gSelect vSelect1 x40 y80 w20 h20, 1
Gui, select:Add, Button, gSelect vSelect2 x60 y80 w20 h20, 2
Gui, select:Add, Button, gSelect vSelect3 x80 y80 w20 h20, 3
Gui, select:Add, Button, gSelect vSelect4 x100 y80 w20 h20, 4
Gui, select:Add, Button, gSelect vSelect5 x120 y80 w20 h20, 5
Gui, select:Show, w180
Return

Select:
If (A_GuiControl = "Select1") {
	FolderPath := "C:\Users\Public\Backup\"
} else If (A_GuiControl = "Select2") {
	FolderPath := "\\INSERT_COMPURTER_NAME_HERE\Users\Public\Backup\"
} else If (A_GuiControl = "Select3") {
	FolderPath := "\\INSERT_COMPURTER_NAME_HERE\Users\Public\Backup\"
} else If (A_GuiControl = "Select4") {
	FolderPath := "\\INSERT_COMPURTER_NAME_HERE\Users\Public\Backup\"
} else If (A_GuiControl = "Select5") {
	FolderPath := "\\INSERT_COMPURTER_NAME_HERE\Users\Public\Backup\"
} else {
	MsgBox, 0, `t, An error has occurred.`nPlease try again.`n`nIf the problem persists`, talk to Alex.
}
If !FileExist(FolderPath) {
	FileCreateDir, %FolderPath%
	FileSetAttrib, +SH, %FolderPath%, 2, 0				;!!!!! For some reason this doesn't work.
}
If !FileExist(FolderPath . A_Username) {
	FileCreateDir, %FolderPath%%A_UserName%
	Sleep, 100
	FileSetAttrib, +SH, %FolderPath%%A_UserName%, 2, 0	;!!!!! Yet this does?!
}
FolderPath := FolderPath . A_UserName
Gui, access:Default
Gui, access:Add, ListView, x0 y0 w400 h250 gLVInput AltSubmit NoSortHdr -LV0x10 vFileList, Name|Type|Size
LV_ModifyCol(1, "200")
LV_ModifyCol(2, "100")
LV_ModifyCol(3, "75 Right")
Loop, Files, %FolderPath%\*.*, D
{
	If InStr(FileExist(A_LoopFileLongPath), "S")
		Continue
	LV_Add(, A_LoopFileName, "Folder", "")
}
Loop, Files, %FolderPath%\*.*, F
{
	If InStr(FileExist(A_LoopFileLongPath), "S")
		Continue
	FileGetSize, FileSize, %A_LoopFileLongPath%, M
	ListFileSize := FileSize . " MB"
	If (FileSize = 0) {
		FileGetSize, FileSize, %A_LoopFileLongPath%, K
		ListFileSize := FileSize . " KB"
		If (FileSize = 0){
			FileGetSize, FileSize, %A_LoopFileLongPath%
			ListFileSize := FileSize . "    B"
		}
	}
	LV_Add(, A_LoopFileName, "File", ListFileSize)
}
Gui, access:Add, Button, gOpen x70 y262 w60 h25, Open
Gui, access:Add, Button, gDownload x270 y262 w60 h25, Download
Gui, access:Show, w400 h300
Return


LVInput:
If (A_GuiEvent = "Normal")
	SelectedRow := A_EventInfo
Return

Open:
LV_GetText(EntryFilename, SelectedRow, 1)
Run, "%FolderPath%\%EntryFilename%"
Return


Download:
LV_GetText(EntryFilename, SelectedRow, 1)
LV_GetText(DownloadIsFolder, SelectedRow, 2)
If (DownloadIsFolder = "Folder") {
	FileCopyDir, %FolderPath%\%EntryFilename%, \\dc1\studnets$\%A_Username%\, 0
	if ErrorLevel
		MsgBox, 0, `t, The folder could not be copied.`nThe folder already exists on your account.
} else if (DownloadIsFolder = "File") {
	FileCopy, %FolderPath%\%EntryFilename%, \\dc1\studnets$\%A_Username%\, 0
	if ErrorLevel
		MsgBox, 0, `t, The file could not be copied.`nThe file already exists on your account.
} else {
	MsgBox, 0, `t, An error has occurred.`nPlease try again.`n`nIf the problem persists`, talk to Alex.
}
Return

selectGuiClose:
accessGuiClose:
ExitApp
Return