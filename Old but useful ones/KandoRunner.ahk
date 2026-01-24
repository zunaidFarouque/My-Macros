/*
^XButton1::{
	; Run('C:\Users\Turjo\AppData\Local\kando\app-1.3.0\Kando.exe --menu "Mailing Works"')
	Send("^!+{F12}")
	return
}
*/

^XButton1:: {
	/* Run('C:\Users\Turjo\AppData\Local\kando\app-1.3.0\Kando.exe --menu "Mailing Works"') */
	Send("^!+{F11}")
	return
}

^XButton2:: {
	/* Run('C:\Users\Turjo\AppData\Local\kando\app-1.3.0\Kando.exe --menu "Mailing Works"') */
	Send("^!+{F12}")
	return
}

/* Remapping XButton1+LButton to OCR Copy Line *\
XButton1::{
	Send("{XButton1}")
}

XButton1 & LButton::{
	Send("#!``")
	return
}
*/
