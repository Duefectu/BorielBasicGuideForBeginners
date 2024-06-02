' - Demo128 -----------------------------------------------
' - Mini-Game Module ---------------------------------------
' Parameter1: Code of the selected mini-game
' Parameter2: Not used


MiniGame()
STOP


' - Includes ------------------------------------------------
#INCLUDE "Vars.bas"


' - Main Loop of the Game ----------------------------------
SUB MiniGame()   
    ' Clear the screen
    BORDER 2
    PAPER 0
    INK 5
    CLS
    
    ' Wait for no key to be pressed
    WHILE INKEY$ <> ""
    WEND

    ' Draw the fixed text
    PRINT AT 0,1;"Mini-Game Module"
    IF ControlType = CONTROL_KEYBOARD
        PRINT AT 1,1;"Control: Keyboard";
    ELSEIF ControlType = CONTROL_KEMPSTON
        PRINT AT 1,1;"Control: Kempston";
    ELSEIF ControlType = CONTROL_SINCLAIR
        PRINT AT 1,1;"Control: Sinclair";
    ELSEIF ControlType = CONTROL_CURSOR
        PRINT AT 1,1;"Control: Cursor";
    END IF
    PRINT AT 2,1;"Mini-Game: ";Parameter1;
    
    ' Infinite loop
    DO
        ' Print the scores
        PRINT AT 3,1;"Lives: ";Lives;
        PRINT AT 4,1;"Points: ";Points;
        PRINT AT 5,1;"Energy: ";Energy;
    
        ' Print the options
        PRINT AT 6,5;"W. Mini-game won";
        PRINT AT 7,5;"L. Mini-game lost";
        
        ' Wait for a key to be pressed
        WHILE INKEY$ = ""
        WEND
                
        IF INKEY$ = "w" THEN
            'W to win the mini-game
            Points = Points + 10
            ModuleToExecute = MODULE_GAME
            Parameter1 = 1
            Parameter2 = 0
            RETURN
        ELSEIF INKEY$ = "l" THEN
            ' L to lose the mini-game
            ModuleToExecute = MODULE_GAME
            Parameter1 = 2
            Parameter2 = 0
            RETURN        
        END IF
    LOOP
END SUB
