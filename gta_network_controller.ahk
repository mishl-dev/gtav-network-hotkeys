#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; ============================================================
; GTA Network Controller
; An AutoHotkey script for controlling GTA 5 network access
; ============================================================

; Global Constants
global APP_NAME := "GTA Network Controller"
global FIREWALL_RULE_GAME := "GTA5_NETWORK_BLOCK"
global FIREWALL_RULE_SAVE := "GTA5_SAVE_BLOCK"
global TOOLTIP_DURATION := 3000  ; milliseconds

; Set performance options
SetKeyDelay(0)
SetWinDelay(0)
SetControlDelay(0)
SetTitleMatchMode(2)

; Check for admin privileges and restart with elevation if needed
if !A_IsAdmin {
    try {
        Run("*RunAs " A_ScriptFullPath)
        ExitApp()
    } catch Error as e {
        MsgBox("Failed to restart with admin privileges. Error: " e.Message, APP_NAME, "Icon!")
    }
}

; Register exit handler
OnExit(AppExit)

; Setup tray menu
SetupTrayMenu()

; Initialize and display startup notification
ShowSplashScreen()

; ============================================================
; Hotkey Definitions
; ============================================================

; Exit application
!+f4::ExitApp()  ; Alt+Shift+F4

; Network Controls
^Numpad0::BlockGameNetwork()    ; Ctrl+Numpad0: Block network
^Numpad1::UnblockGameNetwork()  ; Ctrl+Numpad1: Unblock network

; Save Controls
^f9::DisableSaving()    ; Ctrl+F9: Disable saving
^f12::EnableSaving()    ; Ctrl+F12: Enable saving

; Legacy/Alternative Controls (for backwards compatibility)
^f5::BlockGameNetwork()    ; Ctrl+F5: Block network
^f6::UnblockGameNetwork()  ; Ctrl+F6: Unblock network

; Help
^f8::ShowHelp()          ; Ctrl+F8: Show help
^h::ShowHelp()           ; Ctrl+H: Alternative help shortcut

; ============================================================
; Functions
; ============================================================

; Setup the system tray menu
SetupTrayMenu() {
    ; Set custom tray icon (using default AutoHotkey icon as fallback)
    ; TraySetIcon("path\to\icon.ico") ; Uncomment and set path to use custom icon
    
    ; Create tray menu
    A_TrayMenu.Delete() ; Clear default menu
    A_TrayMenu.Add("GTA Network Controller", (*) => ShowHelp())
    A_TrayMenu.Add()  ; Add separator
    
    ; Network controls submenu
    A_TrayMenu.Add("Network Controls", (*) => {})
    A_TrayMenu.Add("   Block Network", (*) => BlockGameNetwork())
    A_TrayMenu.Add("   Unblock Network", (*) => UnblockGameNetwork())
    A_TrayMenu.Add()  ; Add separator
    
    ; Saving controls submenu
    A_TrayMenu.Add("Saving Controls", (*) => {})
    A_TrayMenu.Add("   Disable Saving", (*) => DisableSaving())
    A_TrayMenu.Add("   Enable Saving", (*) => EnableSaving())
    A_TrayMenu.Add()  ; Add separator
    
    ; Status information
    A_TrayMenu.Add("Show Help", (*) => ShowHelp())
    A_TrayMenu.Add("Check Status", (*) => CheckStatus())
    A_TrayMenu.Add()  ; Add separator
    
    ; Exit option
    A_TrayMenu.Add("Exit", (*) => ExitApp())
    
    ; Set default tray menu item
    A_TrayMenu.Default := "GTA Network Controller"
    
    ; Set tray tip
    A_IconTip := APP_NAME
}

; Block GTA 5 network communication
BlockGameNetwork() {
    try {
        RunWait('netsh advfirewall firewall add rule name="' FIREWALL_RULE_GAME '" dir=out action=block program="' GetGTAExecutablePath() '"', , "Hide")
        RunWait('netsh advfirewall firewall add rule name="' FIREWALL_RULE_GAME '" dir=in action=block program="' GetGTAExecutablePath() '"', , "Hide")
        ShowNotification("GTA5 NETWORK BLOCKED", "🔒")
    } catch Error as e {
        ShowError("Failed to block network: " e.Message)
    }
}

; Unblock GTA 5 network communication
UnblockGameNetwork() {
    try {
        RunWait('netsh advfirewall firewall delete rule name="' FIREWALL_RULE_GAME '"', , "Hide")
        ShowNotification("GTA5 NETWORK UNBLOCKED", "🔓")
    } catch Error as e {
        ShowError("Failed to unblock network: " e.Message)
    }
}

; Disable saving by blocking specific server
DisableSaving() {
    try {
        RunWait('netsh advfirewall firewall add rule name="' FIREWALL_RULE_SAVE '" dir=out action=block remoteip="192.81.241.171"', , "Hide")
        ShowNotification("SAVING DISABLED", "💀", 10, 10, true)
    } catch Error as e {
        ShowError("Failed to disable saving: " e.Message)
    }
}

; Enable saving by removing specific server block
EnableSaving() {
    try {
        RunWait('netsh advfirewall firewall delete rule name="' FIREWALL_RULE_SAVE '"', , "Hide")
        ShowNotification("SAVING ENABLED", ":3", 10, 10)
    } catch Error as e {
        ShowError("Failed to enable saving: " e.Message)
    }
}

; Check and display current status of firewall rules
CheckStatus() {
    try {
        ; Check if network blocking is active
        networkBlocked := false
        saveBlocked := false
        
        ; Run command to check firewall rules and save output
        tempFile := A_Temp "\gta_firewall_check.txt"
        RunWait('netsh advfirewall firewall show rule name="' FIREWALL_RULE_GAME '" > "' tempFile '"', , "Hide")
        
        ; Read the output file
        if FileExist(tempFile) {
            fileContent := FileRead(tempFile)
            if InStr(fileContent, FIREWALL_RULE_GAME)
                networkBlocked := true
            FileDelete(tempFile)
        }
        
        ; Check save blocking
        RunWait('netsh advfirewall firewall show rule name="' FIREWALL_RULE_SAVE '" > "' tempFile '"', , "Hide")
        
        ; Read the output file
        if FileExist(tempFile) {
            fileContent := FileRead(tempFile)
            if InStr(fileContent, FIREWALL_RULE_SAVE)
                saveBlocked := true
            FileDelete(tempFile)
        }
        
        ; Create status message
        statusText := "GTA Network Controller Status`n"
                   . "================================`n"
                   . "Network Blocking: " (networkBlocked ? "ACTIVE ⛔" : "INACTIVE ✅") "`n"
                   . "Save Blocking: " (saveBlocked ? "ACTIVE 💀" : "INACTIVE ✅") "`n`n"
                   . "GTA Executable: " (GetGTAExecutablePath() ? GetGTAExecutablePath() : "Not found - using general rules")
        
        MsgBox(statusText, APP_NAME, "")
    } catch Error as e {
        ShowError("Failed to check status: " e.Message)
    }
}

; Display help information
ShowHelp() {
    helpText := APP_NAME " - Hotkey Guide`n"
             . "======================================`n"
             . "Network Controls:`n"
             . "  Ctrl+Numpad0 or Ctrl+F5: Block network`n"
             . "  Ctrl+Numpad1 or Ctrl+F6: Unblock network`n`n"
             . "Save Controls:`n"
             . "  Ctrl+F9: Disable saving mode`n"
             . "  Ctrl+F12: Enable saving mode`n`n"
             . "Other:`n"
             . "  Ctrl+F8 or Ctrl+H: Show this help`n"
             . "  Alt+Shift+F4: Exit application`n`n"
             . "You can also use the system tray menu (right-click`n"
             . "the script icon in the system tray) to access all functions."
    
    MsgBox(helpText, APP_NAME, "")
}

; Display a notification tooltip
ShowNotification(text, icon := "", x := 0, y := 0, persist := false, duration := TOOLTIP_DURATION) {
    if (icon != "")
        text := icon " " text
        
    ToolTip(text, x, y)
    
    if (!persist) {
        SetTimer(() => ToolTip(), -duration)
    }
}

; Display an error message
ShowError(message) {
    MsgBox("Error: " message, APP_NAME, "Icon!")
}

; Display a splash screen on startup
ShowSplashScreen() {
    splashText := APP_NAME " is running!`n"
               . "Right-click the tray icon for options`n"
               . "or press Ctrl+H for help"
    
    ToolTip(splashText, 0, 0)
    SetTimer(() => ToolTip(), -3000)
}

; Get GTA V executable path (with fallback)
GetGTAExecutablePath() {
    ; Common installation paths
    possiblePaths := [
        A_ProgramFiles "\Rockstar Games\Grand Theft Auto V\GTA5.exe",
        A_ProgramFiles "\Epic Games\GTAV\GTA5.exe",
        "D:\Program Files\Rockstar Games\Grand Theft Auto V\GTA5.exe",
        "E:\Program Files\Rockstar Games\Grand Theft Auto V\GTA5.exe"
    ]
    
    ; Check if any of the paths exist
    for path in possiblePaths {
        if FileExist(path)
            return path
    }
    
    ; If no path found, return empty string (will create a general rule not tied to executable)
    return ""
}

; Cleanup function when script exits
AppExit(*) {
    try {
        ; Clean up all firewall rules created by this script
        RunWait('netsh advfirewall firewall delete rule name="' FIREWALL_RULE_GAME '"', , "Hide")
        RunWait('netsh advfirewall firewall delete rule name="' FIREWALL_RULE_SAVE '"', , "Hide")
    } catch Error as e {
        ; Silently fail on exit
    }
}