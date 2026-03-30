;# Create comprehensive ahk, using functions
;# Also create an issue in github
;https://github.com/kando-menu/kando/issues/433#issuecomment-2705506021

XButton1::
{
	MouseGetPos &startX, &startY
	triggered := false

	while GetKeyState("XButton1", "P") {
		MouseGetPos &currentX, &currentY
		distance := Sqrt((currentX - startX) ** 2 + (currentY - startY) ** 2)

		if (distance > 20 || A_TimeSinceThisHotkey > 300) {  ; 20px move or 300ms
			triggered := true
			; mouse move to startX, startY
			MouseMove startX, startY, 0
			Send "{Ctrl Down}{Alt Down}{Shift Down}{F18}"
			MouseMove currentX, currentY, 0
			KeyWait "XButton1"  ; Wait for release
			Send "{Shift Up}{Alt Up}{Ctrl Up}"
			break
		}
		Sleep 10  ; Reduce CPU usage
	}

	if (!triggered)
		Send "{XButton1}"
	return
}
