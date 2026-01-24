#Requires AutoHotkey v2.0
WinWaitNotActive('ahk_exe kando.exe')

fileDir := IniRead("../Settings.ini", "CTX_instruction", "context_Instruction_path", "CTX INSTRCTN FILE NOT FOUND")
prev_clipboard := A_Clipboard

if FileExist(fileDir) {
	CTX_instuction := FileRead(fileDir)
	; MsgBox(CTX_instuction, "File found or not", 0)
	A_Clipboard := ''
	A_Clipboard := CTX_instuction
	ClipWait()
	Send('^v')
	Sleep(50)
}
else {
	reply := MsgBox("Set new location?", "OOPS! File not found!", 'YesNo')
	if (reply == 'Yes') {
		newLocation := InputBox("paste new location", "CTX Instruction file not found")
		IniWrite(newLocation, "../Settings.ini", "CTX_instruction", "context_Instruction_path")
	}
}

A_Clipboard := prev_clipboard
