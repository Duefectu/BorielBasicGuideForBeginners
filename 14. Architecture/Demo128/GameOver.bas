' - Demo128 -----------------------------------------------
' - Game Over Module ---------------------------------------
' Parameter1: Not used
' Parameter2: Not used


GameOver()
STOP


' - Includes ------------------------------------------------
#INCLUDE "Vars.bas"


' - Game Over ------------------------------------------------
SUB GameOver()
    ' Clear the screen
    BORDER 3
    PAPER 0
    INK 2
    CLS
    
    ' Wait for no key to be pressed
    WHILE INKEY$ <> ""
    WEND
    
    ' Print the text and the score
    PRINT AT 5,10;"GAME OVER!"
    PRINT AT 10,5;"Score: ";Points;
    
    ' If the high score has not been beaten...
    IF HighScore > Points THEN
        ' Print the high score
        PRINT AT 15,5;"High Score: ";HighScore;
    ' If the high score has been beaten...
    ELSE
        ' Update the high score
        HighScore = Points
        ' Inform the player of the achievement
        PRINT AT 15,5;"New High Score!!!";
    END IF

    ' Wait for a key to be pressed
    WHILE INKEY$ = ""
    WEND
    
    ' Return to the game menu
    ModuleToExecute = MODULE_MENU
    Parameter1 = 0
    Parameter2 = 0
END SUB
