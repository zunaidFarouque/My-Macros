; --- Global Variables for Easy Modification ---
global sleepTime := 10 		; Sleep time in milliseconds for loop (adjust for CPU usage vs responsiveness)
global timeThresholdGlobal := 300	; time threshold in milliseconds (adjust for sensitivity)
global triggerRadius := 20 	; Mouse movement trigger radius in pixels (adjust to your preference)

; --- Modifier Key Conversion ---
modifierSymbols := Map( ; DONT TOUCH THIS
	"{Win}", "#",
	"{Alt}", "!",
	"{Ctrl}", "^",
	"{Shift}", "+"
)

; --- Hotkey Definitions using the Modular Function ---

; --- Main things to modify ---

; Example 1: XButton1 triggers Ctrl+Alt+Shift+F18 - using global triggerRadius and timeThreshold - No modifiers for the base hotkey
ConditionalHotkey("", "XButton1", "{Ctrl down}{Alt down}{Shift down}{F11}") ; "" for no modifier keys

; Example 2: Ctrl + XButton1 triggers Ctrl+Alt+Shift+F17 - using global triggerRadius and timeThreshold
ConditionalHotkey("{Ctrl}", "XButton1", "{Ctrl down}{Alt down}{Shift down}{F17}")

; Example 3: Shift + XButton1 triggers Ctrl+Alt+Shift+F16 - using global triggerRadius and timeThreshold, but overriding triggerRadius to 25px
ConditionalHotkey("{Shift}", "XButton1", "{Ctrl down}{Alt down}{Shift down}{F16}", 25)

; Example 4: Alt + XButton1 triggers Ctrl+Alt+Shift+F15 - overriding both triggerRadius and timeThreshold
ConditionalHotkey("{Alt}", "XButton1", "{Ctrl down}{Alt down}{Shift down}{F15}", 30, 400)

; Example 5: Ctrl + Shift + Alt + XButton1 triggers Ctrl+Alt+Shift+F14
ConditionalHotkey("{Ctrl}{Shift}{Alt}", "XButton1", "{Ctrl down}{Alt down}{Shift down}{F14}")

; Browser related gestures
ConditionalHotkey("", "XButton2", "{Ctrl down}{Alt down}{Shift down}{F13}") ;

;
;
;
; ------------ NO NEED TO TOUCH ANYTHING BELOW THIS LINE ------------

; --- ConditionalHotkey Function Definition ---
/*
Function: ConditionalHotkey
    Creates a hotkey that performs an action based on mouse movement or time held, with optional modifier keys.

Parameters:
    modifierKeys      - (Optional) Modifier keys using AHK's modifier key syntax (e.g., "{Ctrl}{Alt}{Shift}", ""). Default: "".
    triggerButton     - The button to monitor (e.g., "XButton1", "LButton", "RButton").
    hotkeyToSend      - The hotkey combination to send when triggered (e.g., "{Ctrl down}{Alt down}{Shift down}{F18}").
    distanceThreshold - (Optional) Mouse movement radius in pixels to trigger the action. Overrides global triggerRadius if provided. Default: global triggerRadius.
    timeThreshold     - (Optional) Time in milliseconds to trigger the action if mouse doesn't move enough. Overrides default timeThreshold if provided. Default: global sleepTime * 30.

Credits:
	@SlayVict for the idea
	@vfxturjo for modularization

Returns:
    None
*/
ConditionalHotkey(modifierKeys, triggerButton, hotkeyToSend, distanceThreshold := -1, timeThreshold := -1) {
	local distThreshold := (distanceThreshold == -1) ? triggerRadius : distanceThreshold ; Use global triggerRadius if distanceThreshold is not provided
	local timeThresh := (timeThreshold == -1) ? timeThresholdGlobal : timeThreshold  ; Use default timeThreshold (scaled sleepTime) if timeThreshold is not provided
	local hotkeyName := "" ; Initialize hotkeyName
	local remainingModifiers := modifierKeys ; Working string for modifier keys

	; --- Convert modifier key strings to symbols ---
	for keyString, symbol in modifierSymbols {
		if (InStr(remainingModifiers, keyString)) {
			hotkeyName .= symbol ; Append the symbol to hotkeyName
			remainingModifiers := StrReplace(remainingModifiers, keyString) ; Remove the processed modifier string
		}
	}
	hotkeyName .= triggerButton ; Append the base trigger button

	; --- InnerHotkey Function Definition (now nested within ConditionalHotkey) ---
	InnerHotkey(_) { ; Inner function to handle hotkey logic
		MouseGetPos &startX, &startY ; Get initial mouse position when hotkey is pressed
		startTime := A_TickCount  ; Record the starting time
		triggered := false ; Initialize triggered flag to false

		while GetKeyState(triggerButton, "P") { ; Loop as long as the trigger button is physically held down (modifier state is handled by hotkey)
			MouseGetPos &currentX, &currentY ; Get current mouse position in each loop iteration
			distance := Sqrt((currentX - startX) ** 2 + (currentY - startY) ** 2) ; Calculate distance from starting position
			timeSinceHotkey := A_TickCount - startTime ; Calculate time elapsed since hotkey press

			if (distance > distThreshold || timeSinceHotkey > timeThresh) { ; Check trigger condition (distance OR time)
				triggered := true ; Set triggered flag to true
				MouseMove startX, startY, 0 ; Move mouse back to the starting position instantly (optional visual cue)
				Send hotkeyToSend ; Send the specified hotkey combination
				MouseMove currentX, currentY, 0 ; Move mouse back to the current position instantly

				KeyWait triggerButton ; Wait for the trigger button to be released
				Send "{Shift up}{Alt up}{Ctrl up}" ; Ensure modifier keys are released after sending hotkey - Removed this line, not needed and can cause issues
				break ; Exit the while loop as action is triggered
			}
			Sleep sleepTime ; Pause for a short duration to reduce CPU usage (using global sleepTime)
		}

		if (!triggered) { ; If the loop finished without triggering the action (button released too quickly or mouse didn't move enough)
			Send "{Blind}" . "{" . triggerButton . "}" ; Send the original button press (perform normal button action), also allow for modifier keys to be held down
		}
		return ; Exit InnerHotkey function
	}
	; --- End of InnerHotkey Function Definition ---

	Hotkey hotkeyName, InnerHotkey ; Dynamically create hotkey with modifiers, linking to InnerHotkey function
}
