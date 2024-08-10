#Requires AutoHotkey v2.0
#SingleInstance Force

SetCapsLockState "AlwaysOff" ;prevent Capslock default toggle behavior. Make sure caps lock isn't active when this script is launched because you will need to stop this script to turn it back off. 


;settings
	remote := 1 ; 0 if using imagineclient natively, 1 if connecting remotely

	native_exe_a := "ahk_exe imagineclient-a.exe" ;imagine client-a "ahk_exe [Filename]"
	native_exe_b := "ahk_exe imagineclient-b.exe" ;imagine client-b "ahk_exe [Filename]"
	native_window := "ahk_class GFC_StdWindowClass" ;window class as shown by AutoHotkey's windowspy
	remote_exe_a := "ahk_exe parsecd-a.exe" ;Remote client-a "ahk_exe [Filename]"
	remote_exe_b := "ahk_exe parsecd-b.exe" ;Remote client-b "ahk_exe [Filename]"
	remote_window := "ahk_class MTY_Window" ;window class as shown by AutoHotkey's windowspy

	if(!remote) { ;check if remote or native
		client_a := native_exe_a
		client_b := native_exe_b
		window := native_window
		
		} else {
			client_a := remote_exe_a
			client_b := remote_exe_b
			window := remote_window
		}
loop { ;suspend hotkeys if client windows not open
	if WinExist(client_a) && WinExist(client_b) {
		suspend(0)
	} else {
		suspend (1)
	}
	sleep 1000
}
;Native & remote inclusive hotkey functions:
	;tandem clicks - can be used to do most of what can be done with key presses if UI elements are in the same position on each window. Windows need to be the same size
		#HotIf WinActive(client_a) or WinActive(client_b) 
		;left
			CapsLock & LButton:: {
				coordmode "mouse","client"
			
				if WinActive(client_a) {
					MouseGetPos &mousex, &mousey

					mouseClick "left",mousex,mousey,,,"D NA"
					sleep 25
					mouseClick "left",mousex,mousey,,,"U NA"

					sleep 15

					WinActivate(client_b)
					mouseClick "left",mousex,mousey,,,"D NA"
					sleep 25
					mouseClick "left",mousex,mousey,,,"U NA"

					sleep 15

					WinActivate(client_a)
					mousemove mousex,mousey
					sleep 100
				}
		
				if WinActive(client_b) {
					MouseGetPos &mousex, &mousey

					mouseClick "left",mousex,mousey,,,"D NA"
					sleep 25
					mouseClick "left",mousex,mousey,,,"U NA"
				
					sleep 15

					WinActivate(client_a)

					mouseClick "left",mousex,mousey,,,"D NA"
					sleep 25
					mouseClick "left",mousex,mousey,,,"U NA"

					sleep 15

					WinActivate(client_b)
					mousemove mousex,mousey
					sleep 100		
				}
			}

		
		;right
			CapsLock & RButton:: {

				coordmode "mouse","client"
			
				if WinActive(client_a) {
						MouseGetPos &mousex, &mousey

						mouseClick "right",mousex,mousey,,,"D NA"
						sleep 25
						mouseClick "right",mousex,mousey,,,"U NA"

						sleep 15

						WinActivate(client_b)
						mouseClick "right",mousex,mousey,,,"D NA"
						sleep 25
						mouseClick "right",mousex,mousey,,,"U NA"

						sleep 15

						WinActivate(client_a)
						mousemove mousex,mousey
						sleep 100
				}
			
				if WinActive(client_b) {
					MouseGetPos &mousex, &mousey

					mouseClick "right",mousex,mousey,,,"D NA"
					sleep 25
					mouseClick "right",mousex,mousey,,,"U NA"
				
					sleep 15

					WinActivate(client_a)

					mouseClick "right",mousex,mousey,,,"D NA"
					sleep 25
					mouseClick "right",mousex,mousey,,,"U NA"

					sleep 15

					WinActivate(client_b)
					mousemove mousex,mousey
					sleep 100		
				}
			}
		#HotIf

	;tandem mousewheel up & down
		capslock & WheelDown:: {
			ControlClick ,client_a,,"WD"
			ControlClick ,client_b,,"WD"
		}
		capslock & WheelUp:: {
			ControlClick ,client_a,,"WU"
			ControlClick ,client_b,,"WU"
		}	
	;quick switch, toggle active client
		capslock & space:: {
			if WinActive(client_a) {
				MouseGetPos &mouse_x,&mouse_y
				WinActivate(client_b)
				mouseMove mouse_x,mouse_y
			} else {
				MouseGetPos &mouse_x,&mouse_y
				WinActivate(client_a)
				mouseMove mouse_x,mouse_y
			}
	
		}	



;Native exclusive hotkey functions
	#HotIf !remote
	;terminate all open clients
	^!p:: {
		
		keyWait "p"
		msgbox "Open clients will now close `n`Reload Tandem.ahk to cancel"
		client_a_split := StrSplit(client_a," ")
		process_a := client_a_split[2]

		client_b_split := StrSplit(client_b," ")
		process_b := client_b_split[2]

	   while ProcessExist(process_a) {
			ProcessClose(process_a)
	   }
	   while ProcessExist(process_b) {
			ProcessClose(process_b)
	   }
	}
	#HotIf

;Remote exclusive hotkey functions:
	#HotIf remote
	;movement
		capslock & w:: {
			while getKeyState("w","P") {
				controlSend "{w down}",,client_a
				controlSend "{w down}",,client_b

			} 
				controlSend "{w up}",,client_a
				controlSend "{w up}",,client_b
		}

		capslock & a:: {
			while getKeyState("capslock","P") && getKeyState("a","P") {
				controlSend "{a down}",,client_a
				controlSend "{a down}",,client_b	
			}
				controlSend "{a up}",,client_a
				controlSend "{a up}",,client_b
		}

		capslock & s:: {
			while getKeyState("s","P") {
				controlSend "{s down}",,client_a
				controlSend "{s down}",,client_b	
			}
				controlSend "{s up}",,client_a
				controlSend "{s up}",,client_b
		}

		capslock & d:: {
			while getKeyState("capslock","P") && getKeyState("d","P") {
				controlSend "{d down}",,client_a
				controlSend "{d down}",,client_b	
			}
				controlSend "{d up}",,client_a
				controlSend "{d up}",,client_b
		}

	;tandem arrows (change hotbar page) (redundant with tandem mouse wheel)
		capslock & up:: {
			while getKeyState("up","P") {
				controlSend "{up down}",,client_a
				controlSend "{up down}",,client_b
			}
			keyWait "up"
				controlSend "{up up}",,client_a
				controlSend "{up up}",,client_b
		}

		capslock & down:: {
			while getKeyState("down","P") {
				controlSend "{down down}",,client_a
				controlSend "{down down}",,client_b
			}
			keyWait "down"
				controlSend "{down up}",,client_a
				controlSend "{down up}",,client_b
		}

	;tandem escape (spam while held down)
		CapsLock & Esc:: {

			while getKeyState("Esc","P") {
				controlSend "{esc down} {esc up}",,client_b
				controlSend "{esc down} {esc up}",,client_a
				sleep 50
			}
		}

	;tandem toggle map
		CapsLock & b:: { ;bind "map of current location" to "b" in game 
			keyWait "b"
			controlSend "{b down} {b up}",,client_a
			controlSend "{b down} {b up}",,client_b
			}

	;tandem windows key 
		Capslock & tab:: { 
			keyWait "space"
			controlSend "{LWin}",,client_a
			controlSend "{LWin}",,client_b
		}	
	;character select (bind shift + k in-game)
		^!+u:: {
			keyWait "u"
			sleep 200
			controlSend "{shift down} {k} {shift up}",,client_a
			controlSend "{shift down} {k} {shift up}",,client_b
		}
	;terminate imagineclients signal
		^!p:: { ;ctrl + alt + p (Send signal to tandem_guest.ahk on PCs/VMs running the game natively)
			keywait "p"
			msgbox "Imagine clients open on VMs will now close `n`Reload Tandem.ahk to cancel"
			controlSend "{ctrl down} {alt down} {p} {ctrl up} {alt up}",,client_a
			controlSend "{ctrl down} {alt down} {p} {ctrl up} {alt up}",,client_b
		}

/*
		;Screen Recording
		;start recording (bind (ctrl + alt + shift + G) in OBS)
			^!+G:: {
				keywait "shift"
				keywait "ctrl"
				controlSend "{ctrl down} {alt down} {shift down} {G} {ctrl up} {alt up} {shift up}",,"ahk_exe parsecd-a.exe"
				controlSend "{ctrl down} {alt down} {shift down} {G} {ctrl up} {alt up} {shift up}",,"ahk_exe parsecd-b.exe"
			}

		;stop recording (bind (ctrl + alt + shift + L) in OBS)
			^!+L:: {
				keywait "shift"
				sleep 500
				controlSend "{ctrl down} {alt down} {shift down} {L} {ctrl up} {alt up} {shift up}",,"ahk_exe parsecd-a.exe"
				controlSend "{ctrl down} {alt down} {shift down} {L} {ctrl up} {alt up} {shift up}",,"ahk_exe parsecd-b.exe"
			}
*/
	;autologin - send key combination to trigger login on tandem_guest.ahk
		^!y:: {
			keyWait "y"
		
			controlSend "{ctrl down} {alt down} {y} {ctrl up} {alt up} ",,"ahk_exe parsecd-a.exe"
			controlSend "{ctrl down} {alt down} {y} {ctrl up} {alt up} ",,"ahk_exe parsecd-b.exe"
		}
		
		^!.:: {
			keyWait "."
			
			controlSend "{ctrl down} {alt down} {.} {ctrl up} {alt up} ",,"ahk_exe parsecd-a.exe"
			controlSend "{ctrl down} {alt down} {.} {ctrl up} {alt up} ",,"ahk_exe parsecd-b.exe"
		}

	;tandem teleport to lobby
		thread_options := Map(
			"Nakano Ruins",13,
			"Shibuya Quartz",14,
			"Celu Tower",15,
			"Ueno Mirage",19,
			"Dark Babel",32,
			)
		
		^!+a:: {
			keywait "ctrl"
			keywait "shift"
			keywait "alt"
			keywait "a"
		
			/*
			if !WinActive(client_a) and !WinActive(client_b){
				winActivate(client_b)
				winActivate(client_a)
			}
			*/
			sleep 50
		
			pgdn_count := thread_options["Shibuya Quartz"]
			loop 2 {
				ControlSend "{F12 down}",,client_a
				ControlSend "{F12 down}",,client_b
				sleep 15
				ControlSend "{F12 up}",,client_a
				ControlSend "{F12 up}",,client_b
				sleep 5
			}
			sleep 500
			loop pgdn_count {
			ControlSend "{PgDn}",,client_a
			ControlSend "{PgDn}",,client_b
			}
			
			sleep 300
			controlSend "{ctrl down} {shift down} {alt down} {a} {ctrl up} {shift up} {alt up}",,client_a
			controlSend "{ctrl down} {shift down} {alt down} {a} {ctrl up} {shift up} {alt up}",,client_b
		}

		enhance() {
			controlSend "{0 down}",,"ahk_exe parsecd-b.exe"
				sleep 50
			controlSend "{0 up}",,"ahk_exe parsecd-b.exe"
				sleep 1500
			controlSend "{2 Down}",,"ahk_exe parsecd-b.exe"
			sleep 50
			controlSend "{2 Up}",,"ahk_exe parsecd-b.exe"
				sleep 1500
			controlSend "{3 Down}",,"ahk_exe parsecd-b.exe"
			sleep 50
			controlSend "{3 Up}",,"ahk_exe parsecd-b.exe"
				sleep 1500
			controlSend "{4 Down}",,"ahk_exe parsecd-b.exe"
			sleep 50
			controlSend "{4 Up}",,"ahk_exe parsecd-b.exe"
				sleep 1000
			controlSend "{5 Down}",,"ahk_exe parsecd-b.exe"
			sleep 50
			controlSend "{5 Up}",,"ahk_exe parsecd-b.exe"
			sleep 100
			loop 70 {
				controlSend "{F9 Down}",,"ahk_exe parsecd-b.exe"
			sleep 10
			controlSend "{F9 Up}",,"ahk_exe parsecd-b.exe"
			}
		}
		;enhancer loop toggle
		capslock & e:: {
			keywait "e"
			enhance()
		}
		;Make windows shortcuts behave like using immersive mode on parsec clients
		#Hotif winactive(client_a) or winactive(client_b)
		Lwin:: {
			if winactive(client_a) {
				while getKeyState("LWin","P") {
				ControlSend "{Lwin down}",,client_a
				}
				ControlSend "{Lwin up}",,client_a
			}
			if winactive(client_b) {
				while getKeyState("LWin","P") {
				ControlSend "{Lwin down}",,client_b
				}
				ControlSend "{Lwin up}",,client_b
			}
		}
		#Hotif
	#HotIf
