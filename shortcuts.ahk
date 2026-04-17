#Requires AutoHotkey v2.0

; Prevent Start menu from opening on lone Win key press
A_MenuMaskKey := "vkE8"
~LWin::Send("{Blind}{vkE8}")
~RWin::Send("{Blind}{vkE8}")

; --- Virtual Desktop support via VirtualDesktopAccessor.dll ---
; DLL source: https://github.com/Ciantic/VirtualDesktopAccessor/releases
; Place VirtualDesktopAccessor.dll in the same directory as this script
DllPath := A_ScriptDir "\VirtualDesktopAccessor.dll"
hVDA := DllCall("LoadLibrary", "Str", DllPath, "Ptr")

; --- Persistent desktop indicator (above taskbar) ---
DesktopIndicator := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
DesktopIndicator.BackColor := "111111"
DesktopIndicator.MarginX := 4
DesktopIndicator.MarginY := 4
DesktopIndicator.SetFont("s11", "Consolas")
DesktopLabels := []
Loop 9 {
    opt := A_Index = 1 ? "x4 y4" : "x+2 yp"
    DesktopLabels.Push(DesktopIndicator.AddText(opt " c555555", " " A_Index " "))
}
WinSetTransparent(220, DesktopIndicator)
DesktopIndicator.Show("NoActivate AutoSize")

LastDesktopState := ""
UpdateDesktopIndicator() {
    global hVDA, DesktopIndicator, DesktopLabels, LastDesktopState
    count := DllCall("VirtualDesktopAccessor\GetDesktopCount")
    current := DllCall("VirtualDesktopAccessor\GetCurrentDesktopNumber")
    state := current ":" count
    if (state = LastDesktopState)
        return
    LastDesktopState := state
    Loop 9 {
        idx := A_Index - 1
        if (idx = current)
            DesktopLabels[A_Index].SetFont("c4488CC bold")
        else if (A_Index <= count)
            DesktopLabels[A_Index].SetFont("c4488CC norm")
        else
            DesktopLabels[A_Index].SetFont("c555555 norm")
    }
    DesktopIndicator.GetPos(,, &w, &h)
    DesktopIndicator.Show("NoActivate x100 y" (A_ScreenHeight - 48 - h - 30))
    WinSetAlwaysOnTop(true, DesktopIndicator)
}

UpdateDesktopIndicator()
SetTimer(UpdateDesktopIndicator, 150)

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
