#Requires AutoHotkey v2.0
#SingleInstance Force

SetCapsLockState "AlwaysOff" ;prevent Capslock default toggle behavior. Make sure caps lock isn't active when this script is launched because you will need to stop this script to turn it back off.

/*
Run on PC/VM being remotely accessed.
*/

client := "ahk_exe ImagineClient.exe"
window := "ahk_class GFC_StdWindowClass"

;terminate imagine clients
^!+p:: {
    client_split := StrSplit(client," ")
    imagine_process := client_split[2]

   while ProcessExist(imagine_process) {
        ProcessClose(imagine_process)
   }
}

;Screen Recording
		;start recording (bind (ctrl + alt + shift + G) in OBS)
          ^!+G:: {
               keywait "shift"
               sleep 500
               controlSend "{ctrl down} {shift down} {G} {ctrl up} {shift up}",,"ahk_exe obs64.exe"
               controlSend "{ctrl down} {shift down} {G} {ctrl up} {shift up}",,"ahk_exe obs64.exe"
          }

     ;stop recording (bind (ctrl + alt + shift + L) in OBS)
          ^!+L:: {
               keywait "shift"
               sleep 500
               controlSend "{ctrl down} {shift down} {L} {ctrl up} {shift up}",,"ahk_exe obs64.exe"
               controlSend "{ctrl down} {shift down} {L} {ctrl up} {shift up}",,"ahk_exe obs64.exe"
          }