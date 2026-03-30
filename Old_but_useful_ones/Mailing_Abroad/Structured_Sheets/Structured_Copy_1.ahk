#Requires AutoHotkey v2

collectedInfo := Map() ; Map to store collected information
infoTypes := ["Name", "Profile Link", "Email", "Designation", "Research Interest"] ; Array of information types to collect
userChoice := ""
isCollectingInfo := false ; Global flag to indicate info collection mode

; --- Function to Check if Process was Cancelled ---
CheckCancelled(infoResult) {
    if (infoResult = "Cancelled") {
        MsgBox("Process Cancelled by user.")
		ExitApp ; --------------------------------
        return true ; Indicate cancellation
    }
    return false ; Indicate not cancelled
}

; --- Function for Timed ToolTip ---
TimedToolTip(tooltipText, displayTimeMs, xOffset := 10, yOffset := 10) {
    MouseGetPos(&cursorX, &cursorY)
    ToolTip(tooltipText, cursorX + xOffset, cursorY + yOffset)
    Sleep(displayTimeMs)
    ToolTip() ; Remove the tooltip
}

; --- Function to Get Information with Tooltip and Actions (Using #HotIf Context) ---
GetInfo(infoType) {
    global userChoice, isCollectingInfo ; Declare userChoice and isCollectingInfo as global

    userChoice := "" ; Reset userChoice for each call
    isCollectingInfo := true ; SET to TRUE - Activate hotkeys context

    ; --- Explicitly get cursor position before ToolTip ---
    MouseGetPos(&cursorX, &cursorY)

    tooltipText := "Copy " . infoType
    ToolTip(tooltipText, cursorX + 10, cursorY + 10) ; Show tooltip near mouse cursor

    ; --- Wait for user action ---
    while (userChoice == "") {  ; Simplified while condition
        MouseGetPos(&cursorX, &cursorY)
        ToolTip(tooltipText, cursorX + 10, cursorY + 10)
        Sleep(100) ; Increased Sleep to 100ms for testing
    }

    ToolTip() ; Ensure tooltip is removed
    isCollectingInfo := false ; SET to FALSE - Deactivate hotkeys context
    return GetInfoNextPart(userChoice)

}

GetInfoNextPart(userChoice) {
    ; --- Process user action and return result DIRECTLY from GetInfo ---
    if (userChoice == "Cancelled") {
        return "Cancelled"
    } else if (userChoice == "Skipped") {
        return "Skipped"
    } else if (userChoice == "Copy") {
        return SaveClip()
    }
    return "" ; Default return in case of unexpected userChoice value
}

SaveClip() {
    A_Clipboard := '' ; Clear clipboard first for reliability
    Send('^c')
    if ClipWait(0.5, 0)
        return A_Clipboard
    return "Error Copying" ; Indicate error if clipboard doesn't get data
}

; --- #HotIf Context for Hotkeys ---
#HotIf isCollectingInfo

XButton1:: ; Copy - Global Hotkey with #HotIf condition
{
    global userChoice
    userChoice := "Copy"
    return
}

Tab:: ; Skip - Global Hotkey with #HotIf condition
{
    global userChoice
    userChoice := "Skip"
    return
}

Esc:: ; Cancel - Global Hotkey with #HotIf condition
{
    global userChoice
    userChoice := "Cancelled"
    return
}

#HotIf ; Turn off #HotIf condition for subsequent hotkeys

; --- Main Script Execution - Triggered by F11 ---
/* F11::
{ 
*/
    global collectedInfo, userChoice ; Declare collectedInfo and userChoice as global in F11 scope

    for each, infoType in infoTypes { ; Loop through infoTypes array
        userChoice := "" ; Explicitly reset userChoice before each GetInfo call in F11 loop

        infoResult := GetInfo(infoType) ; Get info for current type

        if CheckCancelled(infoResult) ; Check if cancelled using function
            return ; Exit F11 hotkey subroutine if cancelled

        collectedInfo[infoType] := infoResult ; Store collected info in temporary Map
    }

    ; --- Format Collected Information for Google Sheets (Tab-Separated) - ENSURE CORRECT ORDER ---
    tsvData := ""
    for each, infoType in infoTypes  ; Loop through infoTypes ARRAY to control order
    {
        tsvData .= collectedInfo[infoType] . "`t" ; Get value from collectedInfo using infoType from array as key
    }
    tsvData := RTrim(tsvData, "`t") ; Remove trailing tab at the end

    ; --- Put Tab-Separated Data on Clipboard ---
    A_Clipboard := tsvData

    ; --- Use TimedToolTip instead of MsgBox for confirmation ---
    TimedToolTip("Done!", 2000) ; Show "Done!" tooltip for 2 seconds

	ExitApp
/*
    collectedInfo := Map() ; Clear collected info for next use if needed.
    return ; Exit the F11 hotkey subroutine
}

*/