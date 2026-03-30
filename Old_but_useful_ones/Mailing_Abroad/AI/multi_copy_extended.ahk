#Requires AutoHotkey v2.0
WinWaitNotActive('ahk_exe kando.exe')

; TODO: make it an importable function to eaily load and save settings.
; ==============================
; Loading Settings, middle text
fileDir := IniRead("../Settings.ini", "CTX_instruction", "multy_copy_middleText_path", "Key Not Found")

if FileExist(fileDir) {
	middle_Text := FileRead(fileDir)
} else {
	reply := MsgBox("Set new location?", "OOPS! File not found!", 'YesNo')
	if (reply == 'Yes') {
		newLocation := InputBox("paste new location", "multi_copy middle text file not found")
		IniWrite("`"" newLocation.Value "`"", "../Settings.ini", "CTX_instruction", "multy_copy_middleText_path")
	}
}

; ==============================
; Functions

showToolTip() {
	ToolTip("copied: " loop_count "times`r`nCurrent Slot: " adding_slot "`r`nSlot 1: " StrLen(slot_1_text) "`r`nSlot 2: " StrLen(
		slot_2_text) "`r`nTotal Characters: " StrLen(slot_1_text slot_2_text), 100, 150)
}

; ==============================

loop_continue := true
loop_count := 1
adding_slot := 1
used_second_slot := false

A_Clipboard := ''
Send('^c')
ClipWait(1)
slot_1_text := A_Clipboard
slot_2_text := ''
A_Clipboard := ''

while (loop_continue) {
	; Wait for a key to be pressed, or clipboard to change
	while (true) {
		if (!GetKeyState('esc', 'P')) {
			; logic for changing first and second slot
			if (GetKeyState('1', 'P')) {
				adding_slot := 1
			} else if (GetKeyState('2', 'P')) {
				adding_slot := 2
				used_second_slot := true
			}
			showToolTip()
			if (ClipWait(0.5)) {
				break
			}
		} else {
			loop_continue := false
			break
		}
	}

	; append the clipboard to the total text
	if (adding_slot == 1) {
		slot_1_text := slot_1_text "`r`n`r`n" A_Clipboard
	} else if (adding_slot == 2) {
		slot_2_text := slot_2_text "`r`n`r`n" A_Clipboard
	}
	A_Clipboard := ''
	loop_count := loop_count + 1
}

; append the clipboard to the total text
if (used_second_slot) {
	total_text := slot_1_text middle_Text slot_2_text
} else {
	total_text := slot_1_text
}

; copy the total text to the clipboard
A_Clipboard := total_text
ToolTip("Done...`r`nTotal Characters: " StrLen(total_text), 100, 150)
SetTimer () => ToolTip(), -3000

Exit
