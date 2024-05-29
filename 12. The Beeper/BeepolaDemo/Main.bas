' - BeepolaDemo -------------------------------------------
' https://tinyurl.com/yy7zfm4x

' Call the main subroutine
Main()
STOP

' - Includes ----------------------------------------------
#INCLUDE <retrace.bas>      ' Library for waitretrace
#INCLUDE <Keys.bas>         ' Library for MultiKeys
#INCLUDE "Triptone.bas"     ' Triptone Motor
#INCLUDE "TheMusicBox.bas"  ' The Music Box Motor


' - Main subroutine ----------------------------------------
SUB Main()
    ' Call the Intro module
    Intro()
    ' After the intro, the game menu follows
    Menu()
    
    CLS
    DO
    LOOP
END SUB


' - Demo intro ---------------------------------------------
SUB Intro()
    ' Adjust screen colors
    BORDER 0
    PAPER 0
    INK 6
    CLS ' This deletion is optional
    
    ' Print something
    PRINT AT 5,2;"THIS IS THE INTRO MUSIC";
    PRINT AT 15,2;"Press any key to continue...";
    
    ' Play the song
    Triptone_Play()
END SUB


' - Demo menu ----------------------------------------------
SUB Menu()
    ' Initialize The Music Box motor
    TheMusicBox_Init()
    
    ' Print the menu
    CLS
    INK 6    
    PRINT AT 5,10;"  MAIN MENU";
    PRINT AT 6,10;"-------------";
    INK 5
    PRINT AT 10,11;"1. KEYBOARD";
    PRINT AT 12,11;"2. JOYSTICK";
    PRINT AT 14,11;"0. PLAY";
    
    ' Infinite loop
    DO  
        ' Check the keyboard
        IF MultiKeys(KEY0) THEN
            ' Play option
            RETURN
        ELSEIF MultiKeys(KEY1) THEN
            ' Keyboard
            RETURN
        ELSEIF MultiKeys(KEY2) THEN
            ' Joystick
            RETURN
        END IF
            
        ' Wait for the next screen refresh
        waitretrace
        ' Play the next note
        TheMusicBox_PlayNote()
    LOOP
END SUB
