' - Demo128 -----------------------------------------------
' - Game Module --------------------------------------------


Game()
STOP


' - Includes ------------------------------------------------
#INCLUDE "Vars.bas"


' - Main game loop -----------------------------------------
SUB Game()
    ' If Parameter1 is 0 (New game)...
    IF Parameter1 = 0 THEN
        ' Initialize the game
        InitializeGame()
    ' If Parameter1 is 2 (Dead)...
    ELSEIF Parameter1 = 2 THEN
        ' Subtract one life
        Lives = Lives - 1
    END IF
    
    ' Clear the screen
    BORDER 1
    PAPER 0
    INK 6
    CLS
    
    ' Wait for no key to be pressed
    WHILE INKEY$ <> ""
    WEND

    ' Draw fixed text
    PRINT AT 0,1;"Game Module";
    IF ControlType = CONTROL_KEYBOARD THEN
        PRINT AT 1,1;"Control: Keyboard";
    ELSEIF ControlType = CONTROL_KEMPSTON THEN
        PRINT AT 1,1;"Control: Kempston";
    ELSEIF ControlType = CONTROL_SINCLAIR THEN
        PRINT AT 1,1;"Control: Sinclair";
    ELSEIF ControlType = CONTROL_CURSOR THEN
        PRINT AT 1,1;"Control: Cursor";
    END IF
    
    ' While we have lives left
    WHILE Lives > 0
        ' Print scores
        PRINT AT 2,1;"Lives: ";Lives;
        PRINT AT 3,1;"Points: ";Points;
        PRINT AT 4,1;"Energy: ";Energy;
    
        ' Print options
        PRINT AT 6,5;"P. Add points";
        PRINT AT 7,5;"M. Minigame";
        PRINT AT 8,5;"L. Lose a life";
        
        ' Wait for a key to be pressed
        WHILE INKEY$ = ""
        WEND
                
        IF INKEY$ = "p" THEN
            ' P to increase points
            Points = Points + 1
        ELSEIF INKEY$ = "m" THEN
            ' M to load a minigame
            ModuleToExecute = MODULE_MINIGAMES
            ' Random minigame
            Parameter1 = RND * 10
            Parameter2 = 0
            RETURN
        ELSEIF INKEY$ = "l" THEN
            ' L to lose a life
            Lives = Lives - 1
            ' Wait for key release
            WHILE INKEY$ <> ""
            WEND
        END IF
    WEND
    
    ' No lives left, load GameOver
    ModuleToExecute = MODULE_GAMEOVER
    Parameter1 = 0
    Parameter2 = 0
END SUB


' - Initialize the game ------------------------------------
SUB InitializeGame()
    DIM n AS UByte
    
    ' Default values when starting the game
    Lives = 3
    Points = 0
    Level = 0
    Energy = 10
    
    ' No objects in the backpack
    FOR n = 0 TO 8
        BackpackObjects(n) = 0
    NEXT n
    
    ' Random number generator
    RANDOMIZE 0
END SUB
