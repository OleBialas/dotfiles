#Requires AutoHotkey v2.0

; --- Virtual Desktop support via VirtualDesktopAccessor.dll ---
; DLL source: https://github.com/Ciantic/VirtualDesktopAccessor/releases
; Place VirtualDesktopAccessor.dll in the same directory as this script
DllPath := A_ScriptDir "\VirtualDesktopAccessor.dll"
hVDA := DllCall("LoadLibrary", "Str", DllPath, "Ptr")

EnsureDesktopExists(num) {
    global hVDA
    count := DllCall("VirtualDesktopAccessor\GetDesktopCount")
    while (count < num) {
        DllCall("VirtualDesktopAccessor\CreateDesktop")
        count++
    }
}

GoToDesktop(num) {
    global hVDA
    EnsureDesktopExists(num)
    DllCall("VirtualDesktopAccessor\GoToDesktopNumber", "Int", num - 1)
}

MoveWindowToDesktop(num) {
    global hVDA
    EnsureDesktopExists(num)
    hwnd := WinGetID("A")
    DllCall("VirtualDesktopAccessor\MoveWindowToDesktopNumber", "Ptr", hwnd, "Int", num - 1)
    GoToDesktop(num)
}

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

; Win+1-9: Switch to virtual desktop
#1:: GoToDesktop(1)
#2:: GoToDesktop(2)
#3:: GoToDesktop(3)
#4:: GoToDesktop(4)
#5:: GoToDesktop(5)
#6:: GoToDesktop(6)
#7:: GoToDesktop(7)
#8:: GoToDesktop(8)
#9:: GoToDesktop(9)

; Win+Shift+1-9: Move active window to virtual desktop and follow
#+1:: MoveWindowToDesktop(1)
#+2:: MoveWindowToDesktop(2)
#+3:: MoveWindowToDesktop(3)
#+4:: MoveWindowToDesktop(4)
#+5:: MoveWindowToDesktop(5)
#+6:: MoveWindowToDesktop(6)
#+7:: MoveWindowToDesktop(7)
#+8:: MoveWindowToDesktop(8)
#+9:: MoveWindowToDesktop(9)

; Win+Q: Close current window
#q::
{
    WinClose "A"
}

; Win+Shift+Q: Close current virtual desktop and move left
#+q::
{
    global hVDA
    current := DllCall("VirtualDesktopAccessor\GetCurrentDesktopNumber")
    fallback := current > 0 ? current - 1 : 0
    DllCall("VirtualDesktopAccessor\RemoveDesktop", "UInt", current, "UInt", fallback)
}
