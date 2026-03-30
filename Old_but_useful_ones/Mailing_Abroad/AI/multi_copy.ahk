#Requires AutoHotkey v2.0
WinWaitNotActive('ahk_exe kando.exe')

loop_continue := true
loop_count := 1

A_Clipboard := ''
Send('^c')
ClipWait(1)
total_text := A_Clipboard
A_Clipboard := ''

while (loop_continue) {
	ToolTip("copied: " loop_count "times`r`nTotal Characters: " StrLen(total_text), 100, 150)

	; Wait for a key to be pressed, or clipboard to change
	while (true) {
		if (!GetKeyState('esc', 'P')) {
			if (ClipWait(0.5)) {
				break
			}
		} else {
			loop_continue := false
			break
		}
	}

	; append the clipboard to the total text
	total_text := total_text "`r`n`r`n" A_Clipboard
	A_Clipboard := ''
	loop_count := loop_count + 1
}

; copy the total text to the clipboard
A_Clipboard := total_text
ToolTip("Done...`r`nTotal Characters: " StrLen(total_text), 100, 150)
SetTimer () => ToolTip(), -3000

Exit
