:: https://www.tenforums.com/tutorials/17707-reset-folder-view-settings-default-windows-10-a.html



@echo off

:: Resets folder view settings, window size and position of all folders
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\Shell\BagMRU" /F
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags" /F

Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\ShellNoRoam\Bags" /F
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\ShellNoRoam\BagMRU" /F

Reg Delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /F
Reg Delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /F

Reg Delete "HKCU\SOFTWARE\Classes\Wow6432Node\Local Settings\Software\Microsoft\Windows\Shell\Bags" /F
Reg Delete "HKCU\SOFTWARE\Classes\Wow6432Node\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /F


:: To reset "Apply to Folders" views to default for all folder types
REG Delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults" /F


:: To reset size of details, navigation, preview panes to default for all folders
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer" /F
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\NavPane" /F


:: To reset size of Save as and Open panes to default for all folders
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CIDOpen" /F
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CIDSave" /F
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32" /F


:: To kill and restart explorer process
taskkill /f /im explorer.exe
start explorer.exe
