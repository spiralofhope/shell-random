
#SingleInstance Force

initialTime := FileGetTime(A_ScriptFullPath, "M")
SetTimer CheckFileChange, 2000


Loop 10
{
    Hotkey A_Index "Joy1", ButtonPressed
}

ButtonPressed(key)
{
    MsgBox key " - Triangle"
}



CheckFileChange()
{
    currentTime := FileGetTime(A_ScriptFullPath, "M")
    if (currentTime != initialTime)
    {
        Reload
        Sleep 2000
        MsgBox "Reload failed!"
    }
}