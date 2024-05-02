' - Mouse demo --------------------------------------------
' - Main game loop -----------------------------------------


' Declaring the DrawMonsters function
DECLARE FUNCTION DrawMonsters() AS UByte


' - Main game loop -----------------------------------------
SUB Game()
    ' Local variables
    DIM pressed AS UByte

    ' Initialize the game
    InitializeGame()

    DO
        ' Synchronize with screen refresh
        waitretrace
        ' Print the score marker
        PRINT AT 0,0;INK 4;"Score: ";Score;" ";
        ' Print the level marker
        PRINT AT 23,0;INK 5;"Level: ";Level;"."; _
            NumMonsters;
        
        ' Read the mouse state
        ReadMouse()
        ' Update the crosshair position
        UpdateSprite(MouseX+32,256-MouseY+32,0,0,0,0)

        ' If not pressed in the previous iteration...
        IF pressed = 0 THEN
            ' If the left button is pressed...
            IF MouseButtonL <> 0 THEN
                ' Set debounce to 1
                pressed = 1
                ' Create a new shot
                CreateShot()
            END IF
        ' If the button was pressed before (pressed)...
        ELSE
            ' If the left button is not being pressed...
            IF MouseButtonL = 0 THEN
                ' Reset debounce
                pressed = 0
            END IF
        END IF

        ' Draw the shots
        DrawShots()
        
        ' Create monsters, if applicable
        CreateMonsters()
        ' Draw monsters and check if killed...
        IF DrawMonsters() = 1 THEN
            ' If killed, exit loop
            EXIT DO
        END IF
    LOOP
    
    ' Remove all sprites
    FOR n = 0 TO 127
        RemoveSprite(n,0)
    NEXT n
    
    ' Print "DEAD!!!"
    PrintCentered16(2,"DEAD!!!")
    ' Print "POINTS: 0" centered
    PrintCentered16(4,"Score: " + STR(Score))
    ' If we beat the record...
    IF Score > Record THEN
        ' New record and text
        Record = Score
        PrintCentered16(6,"NEW RECORD!")
    ELSE
        ' Print current record
        PrintCentered16(6,"RECORD: " + STR(Record))
    END IF
    ' Wait for mouse click
    PrintCentered16(8,"CLICK MOUSE!")       
    PauseClick()
END SUB


' - Initialize a game --------------------------------------
SUB InitializeGame()
    DIM n AS UByte
    
    ' Clear the ULA screen
    CLS
    ' Clear the Layer 2 screen
    CLS256(0)
    
    ' Reset counters
    Score = 0
    Level = 0
    NumMonsters = 0
    ' Reset the shots array
    FOR n = 0 TO DIS_MAX
        Shots(n,DIS_STATE) = 0
    NEXT n
    ' Reset the monsters array
    FOR n = 0 TO MONS_MAX
        Monsters(n,MONS_STATE) = 0
    NEXT n
    ' Print the record marker
    PRINT AT 0,20;INK 2;"Record: ";Record;
END SUB

' - Create a new shot, if possible -------------------------
SUB CreateShot()
    DIM n, x, y AS UByte

    ' Traverse the entire shots array
    FOR n = 0 TO DIS_MAX
        ' If the shot is not in use...
        IF Shots(n,DIS_STATE) = 0 THEN
            ' Shot coordinates
            x = MouseX
            y = 256 - MouseY
            ' Update the shots array
            Shots(n,DIS_X) = x
            Shots(n,DIS_Y) = y + 32
            ' Initial state 20
            Shots(n,DIS_STATE) = 20
            ' Check if we hit something
            CheckShot(x,y)
            ' Each shot deducts 50 points
            IF Score > 50 THEN
                Score = Score - 50
            ELSE
                Score = 0
            END IF
            ' Exit to create only one shot
            RETURN
        END IF
    NEXT n
END SUB


' - Check if we hit something -----------------------------
SUB CheckShot(x AS UInteger, y AS UInteger)
    DIM x1, x2, y1, y2 AS UInteger
    DIM xs1, xs2, ys1, ys2 AS UInteger
    DIM n, t AS UInteger
    
    ' Shot collision box
    x1 = x + 32
    y1 = y + 32
    x2 = x1 + 16
    y2 = y1 + 16
    
    ' Traverse the entire monsters array
    FOR n = 0 TO MONS_MAX
        ' If the monster is active...
        IF Monsters(n,MONS_STATE) = 1 THEN
            ' Create the monster's collision box
            xs1 = Monsters(n,MONS_X)
            xs2 = xs1 + 32
            ys1 = Monsters(n,MONS_Y)
            ys2 = ys1 + 32
            
            ' Discard when not colliding -------------
            ' X axis -----------------------------
            ' Monster ends before Ingrid
            IF xs2 < x1 THEN CONTINUE FOR
            ' Monster starts after Ingrid
            IF xs1 > x2 THEN CONTINUE FOR
            ' Y axis -----------------------------
            ' Monster ends before Ingrid
            IF ys2 < y1 THEN CONTINUE FOR
            ' Monster starts after Ingrid
            IF ys1 > y2 THEN CONTINUE FOR            
            ' If we reach here, it has collided ------
            
            ' Read the time left for the monster
            t = Monsters(n,MONS_TIME)
            ' Add that time to the points
            Score = Score + t
            ' Set the monster to state 2
            Monsters(n,MONS_STATE) = 2
            ' Increment the number of kills
            NumMonsters = NumMonsters + 1
            ' If we have killed more than 10...
            IF NumMonsters = 10 THEN
                ' Level up
                Level = Level + 1
                ' Reset the counter
                NumMonsters = 0
            END IF
        END IF
    NEXT n    
END SUB


' - Draw the shots -----------------------------------------
SUB DrawShots()
    DIM n, state AS UByte
    DIM x AS Integer

    ' Traverse the entire shots array
    FOR n = 0 TO DIS_MAX
        ' Read the shot's state
        state = Shots(n,DIS_STATE)
        ' If the state is not zero...
        IF state <> 0 THEN 
            ' Read the x coordinate
            x = Shots(n,DIS_X) + 32 
            ' If the state is greater than 10...
            IF state > 10 THEN
                ' Draw sprite 2 (large)
                UpdateSprite(x,Shots(n,DIS_Y),n+1,2,0,0)
                ' Decrease the state
                Shots(n,DIS_STATE) = state - 1
            ' If not, and if the state is greater than 1...
            ELSEIF state > 1 THEN
                ' Draw sprite 1 (small)
                UpdateSprite(x,Shots(n,DIS_Y),n+1,1,0,0)
                ' Decrease the state
                Shots(n,DIS_STATE) = state - 1
            ' If it's 1...
            ELSE
                ' Mark the shot as available
                Shots(n,DIS_STATE) = 0
                ' Remove the sprite
                RemoveSprite(n+1,0) 
            END IF
        END IF
    NEXT n    
END SUB


' - Create a monster, if it feels like it -----------------
SUB CreateMonsters()
    DIM n, t AS UByte
    
    ' If there are fewer monsters than the current level...
    IF MaxMonsters <= Level THEN
        ' Roll a die from 0 to 99.999
        t = RND * 100
        ' If the die roll is greater than 95...
        IF t > 95 THEN
            ' Find an available shot
            FOR n = 0 TO MONS_MAX
                ' If the state is 0, it's available
                IF Monsters(n,MONS_STATE) = 0 THEN
                    ' Monster coordinates
                    Monsters(n,MONS_X) = (RND * 224) + 32
                    Monsters(n,MONS_Y) = (RND * 128) + 32
                    ' Monster type (3 to 7)
                    Monsters(n,MONS_ID) = (RND * 4) + 3
                    ' Set as active
                    Monsters(n,MONS_STATE) = 1
                    ' Time until the monster kills us
                    Monsters(n,MONS_TIME)=200-(Level*10)
                    ' Exit to avoid creating more monsters
                    RETURN
                END IF
            NEXT n
        END IF
    END IF
END SUB


' - Draw monsters ------------------------------------------
FUNCTION DrawMonsters()
    DIM n, state AS UByte
    DIM r, z AS UByte
    DIM t AS UInteger
    
    ' Reset monster counter to zero
    MaxMonsters = 0
    ' Traverse the entire Monsters matrix
    FOR n = 0 TO MONS_MAX
        ' Monster state
        state = Monsters(n,MONS_STATE)
        ' If not dead...
        IF state <> 0 THEN
            ' Sprite attribute 4: double width and height
            z = %00001010
            ' If it's "alive"...
            IF state = 1 THEN
                ' Increment monster counter
                MaxMonsters = MaxMonsters + 1
                ' Sprite attribute 2: default
                r = 0
                ' Read the time left for the monster
                t = Monsters(n,MONS_TIME)
                ' If there's no time left...
                IF t = 0 THEN
                    ' Exit with 1 (killed us)
                    RETURN 1
                ' If there's still time left
                ELSE
                    ' Decrease monster time
                    Monsters(n,MONS_TIME) = t - 1
                END IF
            ' If the monster is no longer alive...
            ELSEIF state = 2 THEN
                ' Rotate it 90 degrees to the right
                r = %10
                ' Go to state 3
                Monsters(n,MONS_STATE) = 3
            ' If it's in state 3...
            ELSEIF state = 3 THEN
                ' Vertical flip (equivalent to rotating 180 degrees)
                r = %1000
                ' Go to state 4
                Monsters(n,MONS_STATE) = 4
            ' If it's in state 4...
            ELSEIF state = 4 THEN
                ' Vertical flip plus rotation = 270 degrees
                r = %1010
                ' Go to state 5
                Monsters(n,MONS_STATE) = 5
            ' If it's in state 5...
            ELSEIF state = 5 THEN
                ' Go to state 6
                Monsters(n,MONS_STATE) = 6
                ' Show normal sprite (small)
                UpdateSprite(Monsters(n,MONS_X)+16, _
                    Monsters(n,MONS_Y)+16, _
                    n+DIS_MAX, _
                    Monsters(n,MONS_ID), _
                    0, _
                    0)
                ' Exit without collision
                RETURN 0
            ' If state is 6...
            ELSEIF state = 6 THEN
                ' State = 0, dead zombie
                Monsters(n,MONS_STATE) = 0
                ' Remove the zombie sprite
                RemoveSprite(n+DIS_MAX,0)
                ' Exit without collision
                RETURN 0
            END IF
            ' Draw the monster sprite. We reach
            ' here with states 1, 2, 3, and 4
            UpdateSprite(Monsters(n,MONS_X), _
                Monsters(n,MONS_Y), _
                n+DIS_MAX, _
                Monsters(n,MONS_ID), _
                r, _
                z)
        END IF
    NEXT n
    ' Exit without collision
    RETURN 0
END FUNCTION
