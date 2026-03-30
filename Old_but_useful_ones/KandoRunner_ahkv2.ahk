XButton1:: {
	MouseGetPos(&startX, &startY)
	startTime := A_TickCount
	triggered := false

	while GetKeyState("XButton1", "P") {
		MouseGetPos(&currentX, &currentY)
		distance := Sqrt((currentX - startX) ** 2 + (currentY - startY) ** 2)
		timeSinceHotkey := A_TickCount - startTime

		if (distance > 20 || timeSinceHotkey > 300) {  ; 20px move or 300ms
			triggered := true
			MouseMove(startX, startY, 0)
			Send("{Ctrl down}{Alt down}{Shift down}{F18}")
			MouseMove(currentX, currentY, 0)
			KeyWait("XButton1")  ; Wait for release
			Send("{Shift up}{Alt up}{Ctrl up}")
			break
		}
		Sleep(10)  ; Reduce CPU usage
	}

	if (!triggered)
		Send("{XButton1}")
	return
}
