' - BeepFXDemo --------------------------------------------
' https://tinyurl.com/5dcy3ujm

' Call the main subroutine
Main()
STOP


' - Includes ----------------------------------------------
#INCLUDE <Input.bas>    ' For the INPUT command
#INCLUDE "BeepFX.bas"   ' Our sound library


' - Main subroutine ----------------------------------------
SUB Main()
    DIM sound AS UByte ' Sound to play
    DIM txt AS String   ' Text from INPUT
    
    ' Prepare the screen
    BORDER 0
    PAPER 0
    INK 6

    ' Repeat until the end of time
    DO
        ' Clear the screen
        CLS
        ' Print some text
        PRINT AT 5,0;"Enter code, (0-58): "; 
        ' Read input from the keyboard
        txt = INPUT$(2)
        ' sound = the numerical value entered
        sound = VAL(txt)
        ' If the value is between 0 and 58...
        IF sound >= 0 AND sound <= 58 THEN
            ' Play the sound
            BeepFX_Play(sound)
        END IF
    LOOP    
END SUB
