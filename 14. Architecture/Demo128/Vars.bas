' - Demo128 -----------------------------------------------
' - Common Variables Module -------------------------------

' - Defines -----------------------------------------------
' Game modules. The module code must match the memory bank
' it's located in
#DEFINE MODULE_MENU 1
#DEFINE MODULE_GAME 4
#DEFINE MODULE_MINIGAMES 3
#DEFINE MODULE_GAMEOVER 7

' Common variables address (CommonVariables)
#DEFINE COMMONVARSADDR $6834

' Control types
#DEFINE CONTROL_UNDEFINED 0
#DEFINE CONTROL_KEYBOARD 1
#DEFINE CONTROL_KEMPSTON 2
#DEFINE CONTROL_SINCLAIR 3
#DEFINE CONTROL_CURSOR 4

' - Common Global Variables -------------------------------
' Module loading
DIM ModuleToExecute AS UByte AT COMMONVARSADDR
DIM Parameter1 AS UByte AT COMMONVARSADDR + 1
DIM Parameter2 AS UInteger AT COMMONVARSADDR + 2

' Configuration
DIM ControlType AS UByte AT COMMONVARSADDR + 4
DIM LeftKey AS UInteger AT COMMONVARSADDR + 5
DIM RightKey AS UInteger AT COMMONVARSADDR + 7
DIM UpKey AS UInteger AT COMMONVARSADDR + 9
DIM DownKey AS UInteger AT COMMONVARSADDR + 11
DIM FireKey AS UInteger AT COMMONVARSADDR + 13

' Game
DIM Lives AS UByte AT COMMONVARSADDR + 15
DIM Points AS ULong AT COMMONVARSADDR + 16
DIM HighScore AS ULong AT COMMONVARSADDR + 20
DIM Level AS UByte AT COMMONVARSADDR + 24
DIM BackpackObjects(8) AS UByte AT COMMONVARSADDR + 25
DIM Energy AS UByte AT COMMONVARSADDR + 36 ' 25 + 9 + 2

' - Switches the indicated bank into slot 3 ---------------
' Parameters:
'   bank (UByte): Bank to place in slot 3 (0-7)
SUB FASTCALL SwitchMemoryBank(bank AS UByte)
ASM
    ld d,a          ; With FASTCALL, bank is placed into A
    ld a,($5b5c)    ; We read BANKM
    and %11111000   ; We reset the first 3 bits
    or d            ; We adjust the first 3 bits with the
                    ; "bank"
    ld bc,$7ffd     ; Port where we'll do the OUT
    di              ; We disable interrupts
    ld ($5b5c),a    ; We update BANKM
    out (c),a       ; We do the OUT
    ei              ; We enable interrupts
END ASM
END SUB
