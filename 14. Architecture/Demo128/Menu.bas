' - Demo128 -----------------------------------------------
' - Menu Module -------------------------------------------
' Parameter1: Not used
' Parameter2: Not used


Menu()
STOP


' - Includes ----------------------------------------------
#INCLUDE <keys.bas>
#INCLUDE "Vars.bas"


' - Game Menu --------------------------------------------
SUB Menu()
    ' If no control type defined...
    IF ControlType = CONTROL_UNDEFINED THEN
        ' Initialize controls
        Initialize()
    END IF
    
    ' Clear the screen
    BORDER 7
    PAPER 7
    INK 0
    CLS
    
    ' Wait until no key is pressed
    WHILE INKEY$ <> ""
    WEND
    
    DO
        ' Display the menu
        PRINT AT 5,11;"Demo 128"
        PRINT AT 7,8;"Game Menu"
        
        ' Print control options
        PrintOption(10,10,"1. Keyboard",CONTROL_KEYBOARD)
        PrintOption(11,10,"2. Kempston",CONTROL_KEMPSTON)
        PrintOption(12,10,"3. Sinclair",CONTROL_SINCLAIR)
        PrintOption(13,10,"4. Cursor",CONTROL_CURSOR)
        ' Print remaining options
        INK 0
        PRINT AT 14,10;"5. Redefine keys"
        PRINT AT 16,10;"0. Start game"
        ' Print high score
        PRINT AT 20,5;"High score: ";HighScore;
    
        ' Wait until a key is pressed
        WHILE INKEY$ = ""
        WEND
        
        ' React based on the pressed key
        IF INKEY$="1" THEN
            ControlType = CONTROL_KEYBOARD
        ELSEIF INKEY$="2" THEN
            ControlType = CONTROL_KEMPSTON
        ELSEIF INKEY$="3" THEN
            ControlType = CONTROL_SINCLAIR
        ELSEIF INKEY$="4" THEN
            ControlType = CONTROL_CURSOR
        ELSEIF INKEY$="5" THEN
            ' TODO: Redefine keys
        ELSEIF INKEY$="0" THEN
            ' Start game
            ' Module to load: Game
            ModuleToExecute = MODULE_GAME
            ' Parameters set to 0 to indicate new game
            Parameter1 = 0
            Parameter2 = 0
            ' Exit the module
            RETURN
        END IF
    LOOP
END SUB


' - Initialize the system ---------------------------------
SUB Initialize()
    ' Default control type
    ControlType = CONTROL_KEYBOARD
    ' Default keys: OPQA SPACE
    LeftKey = KEYO
    RightKey = KEYP
    UpKey = KEYQ
    DownKey = KEYA
    FireKey = KEYSPACE
    ' Other values
    HighScore = 10
END SUB


' - Print an option, highlighting if selected --------------
SUB PrintOption(y AS UByte, x AS UByte, txt AS String, _
    type AS UByte)
    
    ' Print in red if the option is selected
    IF ControlType = type THEN
        INK 2
    ' Print in black if not
    ELSE
        INK 0
    END IF
    ' Print the option
    PRINT AT y,x;txt;
END SUB
