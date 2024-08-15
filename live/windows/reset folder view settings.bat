@echo off
:: Resets folder view settings, window size, and position of all folders
Reg Delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /F
Reg Delete "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /F
:: To reset "Apply to Folders" views to default for all folder types
REG Delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults" /F
:: To reset size of details, navigation, preview panes to default for all folders
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer" /F
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\NavPane" /F
:: To reset size of Save as and Open dialogs to default for all folders
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CIDOpen" /F
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CIDSave" /F
Reg Delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32" /F
:: To kill and restart explorer process
taskkill /f /im explorer.exe
start explorer.exe
