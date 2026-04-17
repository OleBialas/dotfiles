#Requires AutoHotkey v2.0

; Win+Enter: Open WezTerm (focus if already open)
#Enter::
{
    if WinExist("ahk_exe wezterm-gui.exe")
    {
        WinActivate
        WinMaximize
    }
    else
    {
        Run "wezterm-gui.exe"
        WinWait "ahk_exe wezterm-gui.exe",, 5
        WinActivate
        WinMaximize
    }
}

; Win+1: Open Zen Browser (focus if already open)
#1::
{
    if WinExist("ahk_exe zen.exe")
    {
        WinActivate
        WinMaximize
    }
    else
    {
        Run "zen.exe"
        WinWait "ahk_exe zen.exe",, 5
        WinMaximize
    }
}

; Win+2: Open Obsidian (focus if already open)
#2::
{
    if WinExist("ahk_exe Obsidian.exe")
    {
        WinActivate
        WinMaximize
    }
    else
    {
        Run A_AppData "\..\Local\Programs\Obsidian\Obsidian.exe"
        WinWait "ahk_exe Obsidian.exe",, 5
        WinMaximize
    }
}

; Win+3: Open VSCode (focus if already open)
#3::
{
    if WinExist("ahk_exe Code.exe")
    {
        WinActivate
        WinMaximize
    }
    else
    {
        Run "code"
        WinWait "ahk_exe Code.exe",, 5
        WinMaximize
    }
}

; Win+Q: Close current window
#q::
{
    WinClose "A"
}
