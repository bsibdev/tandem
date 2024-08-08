#Requires AutoHotkey v2.0
#SingleInstance Force

SetCapsLockState "AlwaysOff" ;prevent Capslock default toggle behavior. Make sure caps lock isn't active when this script is launched because you will need to stop this script to turn it back off.

/*
Run on PC/VM being remotely accessed.
*/

client := "ahk_exe ImagineClient.exe"
client_path := "C:\SMTI\"
window := "ahk_class GFC_StdWindowClass"
res_x := 1920 ;client resolution
res_y := 1080
client_split := StrSplit(client," ")
imagine_process := client_split[2]

;terminate imagine clients
^!+p:: {
   while ProcessExist(imagine_process) {
        ProcessClose(imagine_process)
   }
}

/*
;tandem Screen Recording ()
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
*/
;tandem autolog
     ;functions
     launchImagine() {
          Send "{LWin down} {r} {lwin up}"
          WinWaitActive ("Run")
          controlSendText client_path . imagine_process,"edit1","Run"
          controlSend "{Enter}","edit1","Run"
          sleep 1500
          WinActivate "ahk_exe ImagineClient.exe"
          sleep 100
    
        loop {
            sleep 100
        if PixelSearch(&Px,&Py,res_x/2.5, res_y/2.4,res_x/1.7,res_y/1.74,0xFFFFFF,1)
            {
        continue
                }
            else
            {
                loop 10 {
                    click("down",res_x/2,res_y/2.033898305084746)
                    sleep 25
                    click("up",res_x/2,res_y/2.033898305084746)
                }
                sleep 1000
                break
                }
            }
            return
            }
       
  login(user,pwd) {
      login_screen := 0
      Loop Files "image_match\login\*" { ;verify that login screen is visible; 
          if (ImageSearch(&found_x,&found_y,0,0,res_x,res_y,"*n150 " . A_LoopFilePath)) {
              send user
              sleep 15
              Send "{Tab}"
              sleep 15
              send  pwd
              sleep 15
              send "{Enter}"
              login_screen := 1
              break
          }    
      }
      if (!login_screen) {
          msgbox "Login screen not found`nTake a screenshot of the LOGIN button and add it to image_match/login/","Tandem_guest","T3"
      }
    }

^!y:: {
     keywait "ctrl"
     keywait "alt"
     keywait "y"
     logins := StrSplit(FileRead("C:\SMTI\logins.txt"),"`n") ;change contents to logins you want to use for that client, and make sure the path matches. 
     account := StrSplit(logins[1],",") ;logins[n] n=line of logins.txt
     
     user := account[1]
     pwd := account[2]
     
     launchImagine()
     sleep 500
     login(user,pwd)
}
^!.:: {
     keywait "ctrl"
     keywait "alt"
     keywait "."
     logins := StrSplit(FileRead("C:\SMTI\logins.txt"),"`n") ;copy logins.txt to game folder and change contents to logins you want to use for that client.
     account := StrSplit(logins[2],",") ;logins[n] n=line of logins.txt
     
     user := account[1]
     pwd := account[2]
     
     launchImagine()
     sleep 500
     login(user,pwd)          
}