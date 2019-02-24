#SingleInstance, Off
Gui, Font, s11
Gui, Add, Text, w190 h40 x5 y5 Center, This program will allow you`nto change your wallpaper.
Gui, Add, Text, w190 h20 x5 y60 Center, Current wallpaper path:
RegRead, RegCurrentWallpaper, HKEY_CURRENT_USER\Control Panel\Desktop, WallPaper
Gui, Font, s8
Gui, Add, Edit, w190 h20 x5 y80 Center vCurrentWallpaper r1 ReadOnly, %RegCurrentWallpaper%
Gui, Font, s11
Gui, Add, Text, w190 h20 x5 y110 Center, New wallpaper path:
Gui, Font, s8
Gui, Add, Edit, w190 h20 x5 y130 Center vNewWallpaper r1 ReadOnly
Gui, Font, s11
Gui, Add, Button, w100 h20 x50 y155 gBrowse, Browse
Gui, Add, Button, w66 h20 x22 y200 gChange vChange Disabled, Change
Gui, Add, Button, w66 h20 x110 y200 gCancel, Cancel
Gui, +ToolWindow
Gui, Show, w200, Wallpaper Changer
Return

Browse:
FileSelectFile, SelectedFile, 3, \\dc1\students$\%A_Username%\My Documents, Selected the picture to use as your wallpaper., Pictures (*.PNG; *.JPG; *.JPEG; *.BMP; *.DIB; *.JFIF; *.JPE; *.GIF; *.TIF; *.TIFF; *.WDP)
If !FileExist(SelectedFile) {
	MsgBox, 0, Wallpaper Changer, The file could not be found.
	Return
}
GuiControl,, NewWallpaper, %SelectedFile%
GuiControl, Enable, Change
Return

Change:
SPI_SETDESKWALLPAPER := 20
SPIF_SENDWININICHANGE := 2  
DllCall("SystemParametersInfo", UINT, SPI_SETDESKWALLPAPER, UINT, uiParam, STR, SelectedFile, UINT, SPIF_SENDWININICHANGE)
If (ErrorLevel = 1) {
	MsgBox, 0, Wallpaper Changer, An error has occured changing the wallpaper.`nPlease try again.
	Return
}
MsgBox, 0, Wallpaper Changer, Wallpaper changed!
Return

GuiClose:
Cancel:
MsgBox, 4, Wallpaper Changer, Are you sure you want to exit?
IfMsgBox, Yes
	ExitApp
Return