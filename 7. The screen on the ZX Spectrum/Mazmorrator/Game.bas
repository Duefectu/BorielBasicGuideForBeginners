' - Game engine ------------------------------------------

' - Main game loop ---------------------------------------
SUB Game()   
    ' Pause counter
    DIM wr AS UInteger
    
    ' Start game
    screen = 0
    score = 0
    lives = 3    
    
    ' Lives loop
    WHILE lives > 0
        ' Start screen
        x = 2
        y = 2
        frame = 0
        orientation = 1
        walking = 0
        
        ' Draw screen
        DrawScreen(screen)
        
        ' Game loop
        DO
            ' Pause for slowing down
            FOR wr = 0 TO 3
                waitretrace 
            NEXT wr
            
            ' Check if standing still or moving
            IF walking = 0 THEN
                ' Print static sprite
                PrintStaticSprite()                
            ELSE
                ' Print moving sprite
                PrintMovingSprite()                
            END IF
            
            ' Manage controls (keyboard)
            ManageControls()
        LOOP
    WEND        
END SUB


' - Prints the sprite when not walking -------------------
SUB PrintStaticSprite()
    ' Standstill, print according to orientation
    IF orientation = 0 THEN
        ' Facing up
        putChars(x,y,2,2,@Ingrid_Stand_up(frame,0))
    ELSEIF orientation = 1 THEN
        ' Facing right
        putChars(x,y,2,2,@Ingrid_Stand_right(frame,0))
    ELSEIF orientation = 2 THEN
        ' Facing down
        putChars(x,y,2,2,@Ingrid_Stand_down(frame,0))
    ELSE
        ' Facing left by default
        putChars(x,y,2,2,@Ingrid_Stand_left(frame,0))
    END IF
    
    ' Increment subFrame
    subFrame = subFrame + 1
    IF subFrame > 4 THEN
        ' If subFrame is 5, increment frame
        frame = frame + 1
        IF frame = 2 THEN
            ' If frame exceeds limit, reset to 0
            frame = 0
        END IF
        subFrame = 0
    END IF   
END SUB   


' - Prints the sprite when moving ------------------------
SUB PrintMovingSprite()
    ' Tile for collision detection
    DIM tileTest AS UByte

    ' Walking, print according to orientation
    IF orientation = 0 THEN
        ' Walking up
        ' Get tile above
        tileTest = GetTile(screen,x,y-1)
        ' If tile is 0, we can move
        IF tileTest = 0 THEN
            ' Erase bottom row
            putChars(x,y+1,2,1,@Ingrid_Blank_horizontal(0))
            y = y - 1            
        END IF       
        ' Print sprite
        putChars(x,y,2,2,@Ingrid_Walk_up(frame,0))
    ELSEIF orientation = 1 THEN
        ' Walking right
        ' Get tile to the right
        tileTest = GetTile(screen,x+2,y)
        ' If tile is 0, we can move
        IF tileTest = 0 THEN
            ' Erase left column
            putChars(x,y,1,2,@Ingrid_Blank_vertical(0))
            x = x + 1             
        END IF
        ' Print sprite
        putChars(x,y,2,2,@Ingrid_Walk_right(frame,0))
    ELSEIF orientation = 2 THEN
        ' Walking down
        ' Get tile below
        tileTest = GetTile(screen,x,y+2)
        ' If tile is 0, we can move
        IF tileTest = 0 THEN
            ' Erase top row
            putChars(x,y,2,1,@Ingrid_Blank_horizontal(0))
            y = y + 1           
        END IF
        ' Print sprite
        putChars(x,y,2,2,@Ingrid_Walk_down(frame,0))
    ELSE
        ' Walking left by default
        ' Erase left column
        putChars(x+1,y,1,2,@Ingrid_Blank_vertical(0))
        ' Get tile to the left
        tileTest = GetTile(screen,x-1,y)
        ' If tile is 0, we can move
        IF tileTest = 0 THEN
            x = x - 1
        END IF
        ' Print sprite
        putChars(x,y,2,2,@Ingrid_Walk_left(frame,0))
    END IF
    
    ' Increment frame, no subFrame here
    frame = frame + 1
    IF frame = 4 THEN
        frame = 0
        walking = 0
    END IF
END SUB  


' - Manages controls (keyboard) ---------------------------
SUB ManageControls()
    ' Stores pressed key
    DIM k AS String
    
    ' Read keyboard
    k = INKEY$
    ' If key o is pressed
    IF k = "o" THEN
        ' Orient left
        orientation = 3
        ' Walk
        walking = 1
    ELSEIF k = "p" THEN
        ' Orient right
        orientation = 1
        ' Walk
        walking = 1
    ELSEIF k = "q" THEN
        ' Orient up
        orientation = 0
        ' Walk
        walking = 1
    ELSEIF k = "a" THEN
        ' Orient down
        orientation = 2
        ' Walk
        walking = 1
    END IF
END SUB
