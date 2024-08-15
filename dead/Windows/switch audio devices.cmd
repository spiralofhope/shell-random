:: Switch audio devices
:: UNFINISHED, using some example code
:: 2020-10-21 on Windows (version not recorded)

:: https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/pnputil


:: @ECHO OFF


:: pnputil.exe  /enum-interfaces  /enabled



:: Yeti Nano (audio)
:: No idea..

:: BenQ GW220 (NVIDIA High Definition Audio)
SET __="HDAUDIO\FUNC_01&VEN_10DE&DEV_0081&SUBSYS_1458375D&REV_1001\5&313a449a&0&0001"


:: can't disable and enable..
pnputil.exe  /disable-device  %__%
:: pnputil.exe  /enable-device  %__%

:: I can't figure out how to do this..
:: pnputil.exe  /restart-device  %__%
