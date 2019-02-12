;	This is the 'Download As Target' script.
#SingleInstance off
#NoTrayIcon
Try UrlDownloadToFile, % A_Args[1], % A_Args[2]
ExitApp