#Requires AutoHotkey v2.0
#SingleInstance Force

SetCapsLockState "AlwaysOff" ;prevent Capslock default toggle behavior. Make sure caps lock isn't active when this script is launched because you will need to stop this script to turn it back off. 

/*
Execute actions on multiple windows.
Requires two separate clients with unique filenames or PCs/VMs connected via remote toolS like RDP or Parsec with unique filenames.

Features:
- Mouse clicks
- quick switch [capslock + space] (recommend binding player/partner toggle to space and reassigning CallShoot from space in your game folder's KeyConfigOption.txt)
- Terminate imagine clients [CapsLock + P]
- WASD Movement (Remote only) [capslock + W,A,S,D]
- Spam Escape (Remote only) [capslock + Esc]
- Open map (Remote only) [CapsLock + b] (bind b in game)
- Up and Down arrows (Remote only) [CapsLock + Up/Down]
- character select (Remote only) [CapsLock + p] (Bind in game)
- Windows Key (Remote only)  [capslock + tab]
- Record/Stop record for OBS (remote only) [(ctrl + alt + shift + G) / (ctrl + alt + shift + L)] (Bind in OBS) (Not working consistently)


The game client ignores non-text key outputs from AutoHotkey, so only the mouse click feature works running ImagineClient natively.
Run each client under their own VMs/PCs connected via a remote tool like RDP or Parsec with a dedicated gpu or Gpu-paravirtualization to use the remaining features .

Key commands are sent exclusively to the target window.
*/


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
;Native & remote inclusive hotkey functions:
	;tandem clicks - can be used to do most of what can be done with key presses if UI elements are in the same position on each window. Windows need to be the same size
		#HotIf WinActive(client_a) or WinActive(client_b) 
		;left
			CapsLock & LButton:: {
				coordmode "mouse","client"
			
				if WinActive(client_a) {
					MouseGetPos &mousex, &mousey
					
					mouseClick "left",mousex,mousey,,,"D NA"
					sleep 20
					mouseClick "left",mousex,mousey,,,"U NA"
					
					WinActivate(client_b)
					
					mouseClick "left",mousex,mousey,,,"D NA"
					sleep 20
					mouseClick "left",mousex,mousey,,,"U NA"
			
					WinActivate(client_a)
	
					mousemove mousex,mousey
				}
			
				if WinActive(client_b) {
					MouseGetPos &mousex, &mousey
					
					mouseClick "left",mousex,mousey,,,"D NA"
					sleep 20
					mouseClick "left",mousex,mousey,,,"U NA"
					
					WinActivate(client_a)
					
					mouseClick "left",mousex,mousey,,,"D NA"
					sleep 20
					mouseClick "left",mousex,mousey,,,"U NA"
			
					WinActivate(client_b)
	
					mousemove mousex,mousey
				}
			}

		
		;right
		CapsLock & RButton:: {

			coordmode "mouse","client"
		
			if WinActive(client_a) {
					MouseGetPos &mousex, &mousey

					mouseClick "right",mousex,mousey,,,"D NA"
					sleep 20
					mouseClick "right",mousex,mousey,,,"U NA"
					
					WinActivate(client_b)
					
					mouseClick "right",mousex,mousey,,,"D NA"
					sleep 20
					mouseClick "right",mousex,mousey,,,"U NA"
			
					WinActivate(client_a)
	
					mousemove mousex,mousey
			}
		
			if WinActive(client_b) {
				MouseGetPos &mousex, &mousey

				mouseClick "right",mousex,mousey,,,"D NA"
				sleep 20
				mouseClick "right",mousex,mousey,,,"U NA"
				
				WinActivate(client_a)
				
				mouseClick "right",mousex,mousey,,,"D NA"
				sleep 20
				mouseClick "right",mousex,mousey,,,"U NA"
		
				WinActivate(client_b)

				mousemove mousex,mousey		
			}
		}
		#HotIf
	
	;quick switch, toggle active client
		capslock & space:: {
			if WinActive(client_a) {
				WinActivate(client_b)
			} else {
				WinActivate(client_a)
			}
	
		}	



;Native exclusive hotkey functions
	#HotIf !remote
	;terminate all open clients
	CapsLock & p:: {
		keyWait "CapsLock"
		keyWait "p"

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
			while getKeyState("capslock","P") && getKeyState("capslock","P") && getKeyState("w","P") {
				controlSend "{w down}",,client_a
				controlSend "{w down}",,client_b

			}
			keyWait "w" 
				controlSend "{w up}",,client_a
				controlSend "{w up}",,client_b
		}

		capslock & a:: {
			while getKeyState("capslock","P") && getKeyState("a","P") {
				controlSend "{a down}",,client_a
				controlSend "{a down}",,client_b	
			}
			keyWait "a"
				controlSend "{a up}",,client_a
				controlSend "{a up}",,client_b
		}

		capslock & s:: {
			while getKeyState("capslock","P") && getKeyState("s","P") {
				controlSend "{s down}",,client_a
				controlSend "{s down}",,client_b	
			}
			keyWait "s"
				controlSend "{s up}",,client_a
				controlSend "{s up}",,client_b
		}

		capslock & d:: {
			while getKeyState("capslock","P") && getKeyState("d","P") {
				controlSend "{d down}",,client_a
				controlSend "{d down}",,client_b	
			}
			keyWait "d"
				controlSend "{d up}",,client_a
				controlSend "{d up}",,client_b
		}

	;tandem arrows (change hotbar page)
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

	;tandem windows key (if immersive mode/keyboard capturing is turned on for remote client, then this might not trigger while the window is focused)
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
		^!+p:: { ;ctrl + shift + alt + p (Send signal to tandem_guest.ahk on PCs/VMs running the game natively)
			keywait "shift"
			keywait "ctrl"
			controlSend "{ctrl down} {alt down} {shift down} {p} {ctrl up} {alt up} {shift up}",,client_a
			controlSend "{ctrl down} {alt down} {shift down} {p} {ctrl up} {alt up} {shift up}",,client_b
		}

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
	;autolog
		^!+y:: {
			keyWait "y"
		
			controlSend "{ctrl down} {alt down} {shift down} {y} {ctrl up} {alt up} {shift up}",,"ahk_exe parsecd-a.exe"
			controlSend "{ctrl down} {alt down} {shift down} {y} {ctrl up} {alt up} {shift up}",,"ahk_exe parsecd-b.exe"
		}
		
		^!+.:: {
			keyWait "."
		
			controlSend "{ctrl down} {alt down} {shift down} {.} {ctrl up} {alt up} {shift up}",,"ahk_exe parsecd-a.exe"
			controlSend "{ctrl down} {alt down} {shift down} {.} {ctrl up} {alt up} {shift up}",,"ahk_exe parsecd-b.exe"
		}
	#HotIf