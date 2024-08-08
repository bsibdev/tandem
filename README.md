# smti_tandem
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
- Autolog (remote only) [ctrl + alt + y (account 1 & 2) / ctrl + alt + . (account 3 & 4)]

Future Features:
- Record/Stop record for OBS (remote only) [(ctrl + alt + shift + G) / (ctrl + alt + shift + L)] (Bind in OBS) (Not working consistently)

The game client ignores non-text key outputs from AutoHotkey, so only the mouse click feature works running ImagineClient natively.
Run each client under their own VMs/PCs connected via a remote tool like RDP or Parsec with a dedicated gpu or Gpu-paravirtualization to use the remaining features .

Key commands are sent exclusively to the target window.