' - Crazy Flowerpots -------------------------------------
' - Game Module -----------------------------------------

' Declare the "DetectCollisions" function
DECLARE FUNCTION DetectCollisions() AS Byte


' - Main game module ------------------------------------
SUB Game()
    ' Local variables
    DIM c, n, potHit AS UByte
    DIM k AS String
    
    ' Start the game
    StartGame()
    
    ' Repeat while there are lives left
    WHILE Lives > 0
        ' Initialize the level
        InitializeLevel()
        ' Draw the scoreboard (fixed elements)
        Scoreboard_Draw()
        ' Update the scoreboard
        Scoreboard_Update()
        
        ' Print the text LEVEL
        INK 2
        DoubleSizeText(60,140,"LEVEL "+STR(Level))
        ' Draw the flowerpots to collect
        Scoreboard_DrawFlowerpots()
        ' Update the flowerpots' state
        Scoreboard_UpdateFlowerpots()

        ' Wait for a key press
        PauseKey()
        ' Move the Level text to the left
        FOR n = 0 TO 32
            WinScrollLeft(0,0,31,8)
        NEXT n
        
        ' Infinite loop
        DO
            ' Synchronize with the screen refresh
            waitretrace
            
            ' Print and move the sprite
            DrawAndMoveSprite()            
            
            ' Control
            k = INKEY$
            IF k <> "" THEN
                IF k = "p" THEN
                    IF Ix<29 THEN
                        Io = 1
                    END IF
                ELSEIF k = "o" THEN
                    IF Ix>1 THEN
                        Io = 2
                    END IF
                END IF
            END IF
            
            ' Create a flowerpot, if needed
            CreateThing()
            ' Draw the falling flowerpots
            DrawThings()
            
            ' Collisions
            c = DetectCollisions()           
            ' If there are collisions, c is not 255...
            IF c <> 255 THEN
              ' Process collision
              potHit = 0
              ' Check if it's in the sequence to collect
              FOR n = 0 TO 7
                ' If the flowerpot is in the sequence...
                IF FlowerpotsSequence(n,0) = c THEN
                    ' If we haven't collected it...
                    IF FlowerpotsSequence(n,1) = 0 THEN
                      ' Mark it as collected
                      FlowerpotsSequence(n,1) = 1
                      ' Add 1 point
                      Points = Points + 1
                      ' One less flowerpot falling
                      FallingThings = FallingThings - 1
                      ' Update the scoreboard
                      Scoreboard_Update()
                      ' Count and update flowerpots
                      IF Scoreboard_UpdateFlowerpots()=0 THEN
                          ' If they're all collected, level up
                          Level = Level + 1
                          ' Exit the infinite loop
                          EXIT DO
                      END IF
                      ' If not all collected, continue
                      potHit = 1
                      EXIT FOR
                    END IF
                END IF
              NEXT n
              ' If a flowerpot fell that shouldn't have
              IF potHit = 0 THEN
                  ' One less life
                  Lives = Lives - 1
                  ' If there are lives left...
                  IF Lives > 0 THEN
                      ' Print Dead
                      INK 2
                      PRINT AT 5,10;"Dead!!!";
                      ' Wait for a key
                      PauseKey()
                  END IF
                  ' Exit to restart the level
                  EXIT DO
              END IF
            END IF                               
        LOOP             
    WEND
    
    ' If we get here, there are no lives left
    INK 2
    DoubleSizeText(50,140,"GAME OVER!")    
    INK 1
    DoubleSizeText(50,110,"Points:"+STR(Points))
    ' Check if you beat the record
    IF Points > Record THEN
        Record = Points
        INK 3
        DoubleSizeText(40,80,"New Record")
    ELSE
        DoubleSizeText(40,80,"Record:"+STR(Record))
    END IF
    ' Wait for a key to exit
    PauseKey()
END SUB


' - Initialize a new game --------------------------------
SUB StartGame()
    ' Reset the scoreboards
    Points = 0
    Lives = 3
    Level = 0
END SUB


' - Initialize a new level --------------------------------
SUB InitializeLevel()
    ' Local variable
    DIM n AS UByte
    
    ' Initialize the random number generator seed
    RANDOMIZE 0
    
    ' Reset Ingrid's state
    Ix = 15
    Iy = 15
    Io = 0
    Ip = 0
    Isf = 0
    
    ' Default colors
    PAPER 7
    INK 0
    CLS
    
    ' Draw the ground
    FOR n = 0 TO 30 STEP 2
        putChars(n,17,2,2,@Things_Floor(0))
    NEXT n
    
    ' Reset the falling flowerpots
    FOR n = 0 TO THINGS_MAX
        Things(n,THING_TYPE) = 0
    NEXT n
    ' Nothing is falling at the start
    FallingThings = 0
    
    ' Create a sequence of 8 flowerpots to collect
    FOR n = 0 TO 7
        ' Flowerpot type (0 to 3)
        FlowerpotsSequence(n,0) = RND * 4
        ' 0 if pending to collect, 1 if collected 
        FlowerpotsSequence(n,1) = 0
    NEXT n
END SUB


' - Draw and move Ingrid's sprite, if applicable
SUB DrawAndMoveSprite()
    ' If we are standing still...
    IF Io = 0 THEN
        ' Draw Ingrid standing still
        putChars(Ix,Iy,2,2,@Ingrid_Stand(Ip,0)) 
        ' Fill with black color
        paint(Ix,Iy,2,2,%111000)
        ' If the subframe counter is 10...
        IF Isf = 10 THEN
            ' Reset the counter
            Isf = 0
            ' If the frame is 0...
            IF Ip = 0 THEN
                ' Set the frame to 1
                Ip = 1
            ' If the frame is not 0...
            ELSE
                ' Set the frame to 0
                Ip = 0
            END IF
        ' If the subframe counter is not 10...
        ELSE
            ' Increment the subframe counter
            Isf = Isf + 1
        END IF
    ' If we are walking to the right...        
    ELSEIF Io = 1 THEN
        ' Draw Ingrid walking to the right
        putChars(Ix,Iy,3,2,@Ingrid_Walk_right(Ip,0))
        ' Fill with black color
        paint(Ix,Iy,3,2,%111000)
        ' If the frame is equal to 3...
        IF Ip = 3 THEN
            ' Reset the frame counter
            Ip = 0
            ' Stop the movement (look forward)
            Io = 0
            ' Increment the sprite's x position
            Ix = Ix + 1
        ' If the frame is not equal to 3...
        ELSE
            ' Increment the frame counter
            Ip = Ip + 1
        END IF
    ' If we are walking to the left
    ELSE
        ' If the frame counter is 0
        IF Ip = 0 THEN
            ' Decrement x
            Ix = Ix - 1
        END IF
        ' Draw Ingrid walking to the left
        putChars(Ix,Iy,3,2,@Ingrid_Walk_left(Ip,0))
        ' Fill with black color
        paint(Ix,Iy,3,2,%111000)
        ' If the frame is 3...
        IF Ip = 3 THEN
            ' Reset the frame counter
            Ip = 0
            ' Stop the movement (look forward)
            Io = 0
        ' If the frame is not 3...
        ELSE
            ' Increment the frame counter
            Ip = Ip + 1
        END IF
    END IF
END SUB


' - Create a new pot, if she feels like it --------------
SUB CreateThing()
    ' Local variables
    DIM r, n AS UByte
    
    ' The level determines the number of pots
    ' that fall at the same time
    ' If it can create a pot...
    IF FallingThings <= Level THEN
        ' Roll a 100-sided die
        r = RND * 100
        ' If the number rolled is greater than 95...
        IF r > 95 THEN
            ' Look for a spot to create the pot
            FOR n = 0 TO THINGS_MAX
                ' We can use the element of the matrix if
                ' THING_TYPE is equal to 0...
                IF Things(n,THING_TYPE) = 0 THEN
                    ' X coordinate of the pot
                    Things(n,THING_X) = (RND * 29) + 1
                    ' Y coordinate of the pot
                    Things(n,THING_Y) = 0
                    ' Pot frame set to zero
                    Things(n,THING_FRAME) = 0
                    ' Type of pot, from 1 to 4
                    Things(n,THING_TYPE) = (RND * 4) + 1
                    ' Add 1 to the pot counter
                    FallingThings = FallingThings + 1
                    RETURN
                END IF
            NEXT n
        END IF
    END IF
END SUB


' - Draw the falling pots -------------------
SUB DrawThings()
    ' Local variables
    DIM n, t, f, x, y AS UByte
    DIM dir AS UInteger
    
    ' Iterate over all elements of the "Things" matrix
    FOR n = 0 TO THINGS_MAX
        ' Pot type
        t = Things(n,THING_TYPE)
        ' If the type is 0, there is no pot...
        IF t <> 0 THEN
            ' Pot frame
            f = Things(n,THING_FRAME)
            ' Direction of the sprite to print
            dir = PotsDir(t-1) + (CAST(UInteger,f) * 48)
            ' X coordinate
            x = Things(n,THING_X)
            ' Y coordinate
            y = Things(n,THING_Y)
            ' Draw the pot
            putChars(x,y,2,3,dir)
            ' Fill with the pot's color
            paint(x,y,2,3,t bOR %111000)
                        
            ' If the pot frame is 7...
            IF f = 7 THEN
                ' Reset to frame 0
                Things(n,THING_FRAME) = 0
                ' If it has hit the ground...
                IF y = 14 THEN
                    ' Mark the pot as free
                    Things(n,THING_TYPE) = 0
                    ' One less pot falling
                    FallingThings = FallingThings - 1
                    ' Erase the pot
                    putChars(x,13,2,2,@Things_Blank)
                    putChars(x,15,2,2,@Things_Blank)
                ' If it has not hit the ground...
                ELSE
                    ' Increment y, only increments
                    ' every 8 frames (pixels)
                    Things(n,THING_Y) = y + 1
                END IF
            ' If the pot frame is not 7...
            ELSE
                ' Increment the pot frame
                Things(n,THING_FRAME) = f + 1
            END IF            
        END IF
    NEXT n
END SUB


' - Detect collisions with the pots -----------------
' Returns:
'   Byte: THING_TYPE of the pot that collides with Ingrid
FUNCTION DetectCollisions() AS Byte
    ' Local variables
    DIM n, t, xc1, xc2, xs1, xs2 AS UByte
    
    ' Create a collision area for Ingrid from xs1 to xs2
    ' Convert from characters to pixels
    xs1 = Ix * 8
    ' If we are standing still...
    IF Io = 0 THEN
        ' The collision area starts at +2
        xs1 = xs1 + 2
        ' And ends at +11
        xs2 = xs1 + 11
    ' If we are walking to the right...
    ELSEIF Io = 1 THEN
        ' The collision area starts at +4 + the frame x 2
        xs1 = xs1 + 4 + (Ip * 2)
        ' And ends at +10 pixels
        xs2 = xs1 + 10
    ' If we are walking to the left...
    ELSE
        ' If the frame is 0...
        IF Ip = 0 THEN
            ' The area starts at +1 - the frame x 2
            xs1 = xs1 + 1 - (Ip * 2)
        ' If the frame is not 0...
        ELSE
            ' The area starts at +9 - the frame x 2
            xs1 = xs1 + 9 - (Ip * 2)
        END IF
        ' And ends at +10
        xs2 = xs1 + 10
    END IF
    
    ' Examine all falling pots
    FOR n = 0 TO THINGS_MAX
        ' Pot type
        t = Things(n,THING_TYPE)
        ' If it's not 0, it's falling...
        IF t <> 0 THEN
            ' If the y coordinate is greater than 12...
            IF Things(n,THING_Y) > 12 THEN
                ' Create a pot collision area
                ' Convert THING_X from characters to pixels
                xc1 = Things(n,THING_X) * 8
                ' The collision area ends at +16
                xc2 = xc1 + 16
                ' If the pot ends before the start
                ' of the character, discard it
                IF xc2 < xs1 THEN CONTINUE FOR
                ' If the pot starts after the end
                ' of the character, discard it
                IF xc1 > xs2 THEN CONTINUE FOR
                ' If we reach here, it has collided
                ' Stop the pot from falling 
                Things(n,THING_TYPE) = 0
                ' Erase the pot
                putChars(Things(n,THING_X), _
                    Iy,2,2,@Things_Blank)
                putChars(Things(n,THING_X), _
                    Iy-2,2,2,@Things_Blank)
                ' Draw Ingrid
                putChars(Ix,Iy,2,2,@Ingrid_Stand(0,0))
                ' Return the pot's code - 1
                RETURN t-1
            END IF
        END IF
    NEXT n
    
    ' No collision with any pot
    RETURN 255
END FUNCTION
