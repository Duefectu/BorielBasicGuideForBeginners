' - Main Game Module ---------------------------------------

' - Game Loop ----------------------------------------------
SUB Game() 
    ' Initialize game    
    InitializeGame()
    ' Draw score panel
    DrawScorePanel()
    ' Update score panel
    UpdateScorePanel()
    
    ' If using double buffer, activate it now
#IFDEF DOUBLE_BUFFER
    ActivateBuffer()
#ENDIF

    ' Initialize mapping
    Mapping_Initialize()
    ' Infinite loop
    DO
        ' If using double buffer...
#IFDEF DOUBLE_BUFFER
        ' Copy buffer to screen
        BufferToScreen()
#ELSE
        ' If not using double buffer, wait for retrace
        waitretrace
        ' Adjust visible attribute in game area
        paint(0,8,31,8,%00111000)
#ENDIF
        
        ' Print warrior sprite
        IF Walking = 0 THEN
            ' Print sprite when standing still
            PrintSpriteStanding()
        ELSE
            ' Print sprite when moving
            PrintSpriteMovement()
        END IF
        
        ' Movement
        IF SubPosMap = 0 THEN
            ' If in even position, handle movement from keyboard
            ControlMovement()
        END IF
    LOOP    
END SUB


' - Initialize Game -----------------------------------------
SUB InitializeGame()
    ' Internal loop counter variable
    DIM n AS UByte
    
    ' Initial position and state of the warrior
    PX = 4
    PY = 14
    Frame = 0
    SubFrame = 0
    Orientation = 1
    Walking = 0
    
    ' Change attributes of hiding areas to white paper with white ink
    paint(0,0,1,18,%00111111)
    paint(31,0,1,18,%00111111)


    ' Print ground directly on the screen
    FOR n=0 TO 30 STEP 2
        putChars(n,16,2,2,@Tiles_Town(1,0))
    NEXT n
END SUB


' - Print sprite when standing still ------------------------
SUB PrintSpriteStanding()
    ' Restore map background
    RestoreBackground(PosMap,SubPosMap,PY)
    
    ' If facing right...
    IF Orientation = 1 THEN
        ' Print mask with AND
        putCharsOverMode(PX,PY,2,2,2,@Ingrid_Stand_right_Mask(Frame,0))
        ' Print sprite with OR
        putCharsOverMode(PX,PY,2,2,3,@Ingrid_Stand_right(Frame,0))
    ' If facing left...
    ELSE
        ' Print mask with AND
        putCharsOverMode(PX,PY,2,2,2,@Ingrid_Stand_left_Mask(Frame,0))
        ' Print sprite with OR
        putCharsOverMode(PX,PY,2,2,3,@Ingrid_Stand_left(Frame,0))
    END IF
    
    ' Draw foreground trees
    DrawForegroundTrees(PosMap, SubPosMap, PY-2)
    
    ' Increment subframe
    SubFrame = SubFrame + 1
    ' If subframe is 4...
    IF SubFrame = 4 THEN
        ' Reset subframe
        SubFrame = 0
        ' Add 1 to current frame
        Frame = Frame + 1
        ' If frame is 2, reset frame
        IF Frame = 2 THEN
            Frame = 0
        END IF
    END IF
END SUB


' - Print sprite when moving --------------------------------
SUB PrintSpriteMovement()
    ' Restore map background
    RestoreBackground(PosMap,SubPosMap,PY)

    ' If facing right...
    IF Orientation = 1 THEN
        ' If not at edge...
        IF PX < 26 THEN                
            ' Increment sprite position
            PX = PX + 1
        ELSE
            ' If not at end of map...
            IF PosMap < 14 THEN
                ' Scroll screen
                MoveScreen(Orientation)
                ' If in intermediate position...
                IF SubPosMap = 1 THEN
                    ' Reset SubPosMap
                    SubPosMap = 0
                    ' Increment map position
                    PosMap = PosMap + 1
                    ' Draw tile to the right
                    Mapping_DrawRight(PosMap)
                ' If not in intermediate position
                ELSE
                    SubPosMap = 1
                END IF
            ' If at end of map...
            ELSE
                ' Prevent further movement
                PosMap = 14
                SubPosMap = 0
            END IF
        END IF
        ' Print warrior mask with AND
        putCharsOverMode(PX,PY,2,2,2,@Ingrid_Walk_right_Mask(Frame,0))
        ' Print Ingrid sprite with OR
        putCharsOverMode(PX,PY,2,2,3,@Ingrid_Walk_right(Frame,0))
    ' If facing left...
    ELSE
        ' If not at left edge...
        IF PX > 4 THEN
            ' Decrement sprite position
            PX = PX - 1
        ' If at left edge...
        ELSE
            ' If not at beginning of map...
            IF PosMap > 0 THEN
                ' Scroll screen
                MoveScreen(Orientation)
                ' If in intermediate position...
                IF SubPosMap = 1 THEN
                    ' Reset SubPosMap
                    SubPosMap = 0
                    ' Decrement map position
                    PosMap = PosMap - 1
                    ' Draw tile to the left
                    Mapping_DrawLeft(PosMap)
                ELSE
                    SubPosMap = 1
                END IF
            ' If at beginning of map...
            ELSE
                ' Prevent further movement            
                PosMap = 0
                SubPosMap = 0
            END IF
        END IF
        ' Print warrior mask with AND
        putCharsOverMode(PX,PY,2,2,2,@Ingrid_Walk_left_Mask(Frame,0))
        ' Print Ingrid sprite with OR
        putCharsOverMode(PX,PY,2,2,3,@Ingrid_Walk_left(Frame,0))
    END IF
    
    ' Draw foreground trees
    DrawForegroundTrees(PosMap, SubPosMap, PY-2)
    
    ' If sprite frame is 3...
    IF Frame = 3 THEN
        ' Reset frame
        Frame = 0
        ' Stop walking
        Walking = 0
    ' If sprite frame is not three
    ELSE
        ' Increment frame
        Frame = Frame + 1
    END IF
    
    ' If in intermediate map position...
    IF SubPosMap = 1 THEN
        ' If standing, make it walk
        IF Walking = 0 THEN
            Walking = 1
        END IF
    END IF
END SUB


' - Control warrior movement --------------------------------
SUB ControlMovement()
    ' Variable to store pressed key
    DIM k AS String
    
    ' Read pressed key
    k = INKEY$
    ' If key is "O"...
    IF k = "o" THEN
        ' If NOT facing left or NOT walking...
        IF NOT(Orientation = 0 AND Walking = 1) THEN
            ' Reset frame
            Frame = 0
        END IF
        ' Set orientation to left
        Orientation = 0
        ' Start walking
        Walking = 1
    ' If key is "P"...
    ELSEIF k = "p" THEN
        ' If NOT facing right or NOT walking...
        IF NOT(Orientation = 1 AND Walking = 1) THEN
            ' Reset frame
            Frame = 0
        END IF
        ' Set orientation to right
        Orientation = 1
        ' Start walking
        Walking = 1
    END IF
END SUB


' - Draw score panel ----------------------------------------
SUB DrawScorePanel()
    ' Change attributes of score panel to yellow paper with black ink
    paint(1,18,30,5,%00110000)

    ' Print the panel with GDUs and colors!!!
    PAPER 7
    INK 0
    PRINT AT 18,1;"\A";
    PRINT AT 18,30;"\B";
    PRINT AT 22,1;"\D";
    PRINT AT 22,30;"\C";    
    PRINT AT 17,0;"    \F    \F\F    \F   \F     \F   \F ";
    PAPER 6
    PRINT AT 18,2;"\E\E \E\E\E\E  \E\E\E\E \E\E\E \E\E\E\E\E \E\E\E";
    PRINT AT 19,1;"\H";
    PRINT AT 19,30;"\G";
    PRINT AT 20,0;PAPER 7;"\G";
    PRINT AT 20,30;"\G";
    PRINT AT 21,1;"\H";
    PRINT AT 21,31;PAPER 7;"\H";
    PRINT AT 22,2;"\F\F \F\F\F   \F  \F\F \F   \F\F   \F  \F";
    PAPER 7
    PRINT AT 23,2;"  \E   \E\E\E \E\E  \E \E\E\E  \E\E\E \E\E";
END SUB


' - Update score panel (just kidding) -----------------------
SUB UpdateScorePanel()
    ' Simulate score values
    PAPER 6
    INK 1
    PRINT AT 19,2;"LITTLE HOUSE ON THE PRAIRIE";
    PRINT AT 21,2;"LIVES: ";INK 2;"\I \J \K";
    PRINT AT 21,21;INK 0;"\L \L";INK 1;" :KEYS";
END SUB
