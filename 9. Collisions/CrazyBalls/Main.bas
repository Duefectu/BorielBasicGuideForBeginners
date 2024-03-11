' - Crazy Balls --------------------------------------------
' https://tinyurl.com/4pffz3z6

Main()
STOP

' - Defines ------------------------------------------------
' Number of balls
#DEFINE MAX_BALLS 5
' X coordinate of the ball
#DEFINE BALL_X 0
' Y coordinate of the ball
#DEFINE BALL_Y 1
' X speed of the ball
#DEFINE BALL_VX 2
' Y speed of the ball
#DEFINE BALL_VY 3
' Number of mines
#DEFINE MAX_MINES 5
' Mine's X coordinate
#DEFINE MINE_X 0
' Mine's Y coordinate
#DEFINE MINE_Y 1


' - Global variables ---------------------------------------
' Ball data
DIM Balls(MAX_BALLS,3) AS Byte
' Mine data
DIM Mines(MAX_MINES,1) AS Byte


' - Includes ------------------------------------------------
#INCLUDE <retrace.bas>
#INCLUDE <attr.bas>
#INCLUDE "Graphics.udg.bas"
#INCLUDE "Map.bas"


' - Main program ---------------------------------------------
SUB Main()
    DIM x, y, vx, vy, n AS Byte

    ' Initialize the system
    Initialize()

Start:
    ' Create random balls
    CreateBalls()
    ' Create mines
    CreateMines()
    ' Create Map
    CreateMap()
    
    ' Draw all the balls the first time
    DrawBalls()
    ' Draw the mines
    DrawMines()
    ' Draw Map
    DrawMap()
    
    ' Wait until nothing is pressed
    WHILE INKEY$<>""
    WEND
    
    ' Loop until a key is pressed
    WHILE INKEY$=""       
        ' Loop through the ball matrix
        FOR n = 0 TO MAX_BALLS
            ' Copy the ball data locally
            x = Balls(n,BALL_X)
            y = Balls(n,BALL_Y)
            vx = Balls(n,BALL_VX)
            vy = Balls(n,BALL_VY)
            
            ' Move the balls
            x = x + vx
            y = y + vy

            ' Detect collisions by map
            DetectCollisionsMap(x,y,vx,vy)

            ' Detect attribute collisions
            DetectCollisionsAttribute(x,y,vx,vy)
            
            ' Synchronize with the screen
            waitretrace
            
            ' Erase the current ball
            DrawBall(n)           
            
            ' Reassign ball values
            Balls(n,BALL_X) = x
            Balls(n,BALL_Y) = y
            Balls(n,BALL_VX) = vx
            Balls(n,BALL_VY) = vy
            
            ' Draw the ball in the new position
            DrawBall(n)
        NEXT n        
    WEND
    
    ' Clear the screen
    CLS
    ' Start over
    GOTO Start
END SUB


' - Initialize the system ------------------------------------
SUB Initialize()
   ' Set colors and clear the screen
    BORDER 5
    PAPER 7
    INK 0
    CLS
    
    ' Initialize the UDGs
    POKE (uinteger 23675, @Graphics)
    
    ' Wait for a key press
    PRINT AT 5,10;"Crazy Balls";
    PRINT AT 10,1;"Press a key to start!";    
    PAUSE 0
    
    ' Clear the screen
    CLS
    
    ' Random number generator seed
    RANDOMIZE 0
END SUB


' - Create balls ---------------------------------------------
SUB CreateBalls()
    DIM n AS UByte
  
    ' Create the balls
    FOR n = 0 TO MAX_BALLS
        ' Repeat this loop if vx=0 and vy=0
        DO
            ' Load with random data
            Balls(n,BALL_X)=(RND * 29) + 1
            Balls(n,BALL_Y)=(RND * 21) + 1
            ' Speed goes from -1 to 1
            Balls(n,BALL_VX)=(RND * 2) - 1
            Balls(n,BALL_VY)=(RND * 2) - 1            
        LOOP WHILE Balls(n,BALL_VX) = 0 AND _
            Balls(n,BALL_VY) = 0
    NEXT n
END SUB


' - Draw all the balls ----------------------------------------
SUB DrawBalls()
    DIM n AS UByte
    ' Draw all the balls
    FOR n = 0 TO MAX_BALLS
        DrawBall(n)
    NEXT n
END SUB


' - Draw a ball ----------------------------------------------
SUB DrawBall(n AS UByte)
    ' Draw a ball with OVER 1 (XOR)
    PRINT AT Balls(n,BALL_Y), Balls(n,BALL_X);OVER 1; _
        INK n;"\A";
END SUB


' - Detect when the ball leaves the screen --------------------
' The parameters are modified within the function
' Parameters:
'   x (Byte by reference): Coordinate X
'   y (Byte by reference): Coordinate Y
'   vx (Byte by reference): Speed X
'   vy (Byte by reference): Speed Y
SUB DetectCollisionArea(BYREF x AS Byte, _
    BYREF y AS Byte, _
    BYREF vx AS Byte, _
    BYREF vy AS Byte)
    ' If it goes off the left side...
    IF x < 0 THEN
        ' X speed is positive
        vx = 1
        ' Fix x to minimum
        x = 0
    ' If it goes off the right side...
    ELSEIF x > 31
        ' X speed is negative
        vx = -1
        ' Fix x to maximum
        x = 31
    END IF

    ' If it goes off the top...
    IF y < 0 THEN
        ' Y speed is positive
        vy = 1
        ' Fix y to minimum
        y = 0
        ' If it goes off the bottom...
    ELSEIF y > 23
        ' Y speed is negative
        vy = -1
        ' Fix y to maximum
        y = 23
    END IF
END SUB


' - Create mines ------------------------------------------------
SUB CreateMines()
    DIM n AS UByte
    
    FOR n = 0 TO MAX_MINES
        Mines(n,MINE_X) = (RND * 29) + 1
        Mines(n,MINE_Y) = (RND * 21) + 1
    NEXT n    
END SUB


' - Draw the mines ----------------------------------------------
SUB DrawMines()
    DIM n AS UByte
    
    FOR n = 0 TO MAX_MINES
        PRINT AT Mines(n,MINE_Y),Mines(n,MINE_X); _
            INK 6;"\B";
    NEXT n    
END SUB


' - Detect collisions by mine attribute -------------------------
' The parameters are modified within the function
' Parameters:
'   x (Byte by reference): Coordinate X
'   y (Byte by reference): Coordinate Y
'   vx (Byte by reference): Speed X
'   vy (Byte by reference): Speed Y
SUB DetectCollisionsAttribute(BYREF x AS Byte, _
    BYREF y AS Byte, _
    BYREF vx AS Byte, _
    BYREF vy AS Byte)
    ' Temporary variable
    DIM a AS UByte
    
    ' Read the attribute at y, x
    a = attr(y,x)
    ' If it's PAPER 7, INK 6...
    IF a = %00111110 THEN
        ' Stop the ball
        vx = 0
        vy = 0
    END IF    
END SUB


' - Detect collisions by map ------------------------------------
' The parameters are modified within the function
' Parameters:
'   x (Byte by reference): Coordinate X
'   y (Byte by reference): Coordinate Y
'   vx (Byte by reference): Speed X
'   vy (Byte by reference): Speed Y
SUB DetectCollisionsMap(BYREF x AS Byte, _
    BYREF y AS Byte, _
    BYREF vx AS Byte, _
    BYREF vy AS Byte)
    ' Temporary variable
    DIM rebound AS UByte
    
    ' If the current map position is empty
    IF Map(x,y) = 0 THEN
        ' There is no collision, we exit
        RETURN
    END IF
    
    ' If there is a collision, we look for how to rebound
    ' If it moves to the right...
    IF vx = 1 THEN
        ' If it moves down to the right
        IF vy = 1 THEN
            ' Wall down...
            IF Map(x-1,y) <> 0 THEN
                vy = - 1
                y = y + vy
                rebound = 1
            END IF
            ' Wall to the right...
            IF Map(x,y-1) <> 0 THEN
                vx = -1
                x = x + vx
                rebound = 1
            END IF
            ' If there is no rebound it is a corner
            IF rebound = 0 THEN
                vx = -1
                x = x + vx
                vy = -1
                y = y + vy
            END IF
        ' If it moves up to the right
        ELSEIF vy = -1 THEN
            ' Wall up...
            IF Map(x-1,y) <> 0 THEN
                vy = 1
                y = y + vy
                rebound = 1
            END IF
            ' Wall to the right...
            IF Map(x,y+1) <> 0 THEN
                vx = -1
                x = x + vx
                rebound = 1
            END IF
            ' If there is no rebound it is a corner
            IF rebound = 0 THEN
                vx = -1
                x = x + vx
                vy = 1
                y = y + vy
            END IF
        ' If it moves horizontally only
        ELSE
            vx = -1
            x = x + vx
        END IF
    ' If it moves to the left...
    ELSEIF vx = -1 THEN
        ' If it moves down to the left
        IF vy = 1 THEN
            ' Wall down...
            IF Map(x+1,y) <> 0 THEN
                vy = - 1
                y = y + vy
                rebound = 1
            END IF
            ' Wall to the left
            IF Map(x,y-1) <> 0 THEN
                vx = 1
                x = x + vx
                rebound = 1
            END IF
            ' If there is no rebound it is a corner
            IF rebound = 0 THEN
                vx = 1
                x = x + vx
                vy = -1
                y = y + vy
            END IF
        ' If it moves up to the left
        ELSEIF vy = -1 THEN
            ' Wall up...
            IF Map(x+1,y) <> 0 THEN
                vy = 1
                y = y + vy
                rebound = 1
            END IF
            ' Wall to the left...
            IF Map(x,y+1) <> 0 THEN
                vx = 1
                x = x + vx
                rebound = 1
            END IF
            ' If there is no rebound it is a corner
            IF rebound = 0 THEN
                vx = 1
                x = x + vx
                vy = 1
                y = y + vy
            END IF
        ' If it moves horizontally only
        ELSE
            vx = 1
            x = x + vx
        END IF
    ' If it moves vertically
    ELSE
        vy = vy * -1
        y = y + vy
    END IF
END SUB
