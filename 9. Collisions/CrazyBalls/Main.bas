' - Crazy Balls -------------------------------------------
' https://tinyurl.com/mtykssw3

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


' - Global variables ---------------------------------------
' Ball data
DIM Balls(MAX_BALLS,3) AS Byte


' - Includes ------------------------------------------------
#INCLUDE <retrace.bas>
#INCLUDE "Graphics.udg.bas"


' - Main subroutine ----------------------------------------
SUB Main()    
    ' Local copies of coordinates
    DIM x, y, vx, vy AS Byte
    ' Various
    DIM n AS UByte
    
    ' Initialize the system
    Initialize()
    ' Create random balls
    CreateBalls()
    
    ' Draw all the balls once
    DrawBalls()
    
    ' Infinite loop
    DO
        ' Traverse the ball matrix
        FOR n = 0 TO MAX_BALLS
            ' Copy the ball data locally
            x = Balls(n,BALL_X)
            y = Balls(n,BALL_Y)
            vx = Balls(n,BALL_VX)
            vy = Balls(n,BALL_VY)
            
            ' Move the balls
            x = x + vx
            y = y + vy
            
            ' Detect collisions by area
            DetectCollisionArea(x,y,vx,vy)            
            
            ' Synchronize with the raster
            waitretrace
            
            ' Erase the current ball
            DrawBall(n)           
            
            ' Reassign the value of the balls
            Balls(n,BALL_X) = x
            Balls(n,BALL_Y) = y
            Balls(n,BALL_VX) = vx
            Balls(n,BALL_VY) = vy
            
            ' Draw the ball in the new position
            DrawBall(n)
        NEXT n        
    LOOP
END SUB


' - Initialize the system ---------------------------------
SUB Initialize()
   ' Set colous and clear the screen
    BORDER 5
    PAPER 7
    INK 0
    CLS
    
    ' Initialize the UDGs
    POKE (uinteger 23675, @Graphics)
    
    ' Wait for a key press
    PRINT AT 5,10;"Crazy Balls";
    PRINT AT 10,1;"Press any key to start!";    
    PAUSE 0
    
    ' Clear the screen
    CLS
    
    ' Seed the random number generator
    RANDOMIZE 0
END SUB


' - Create the balls ----------------------------------------
SUB CreateBalls()
    DIM n AS UByte
  
    ' Create the balls
    FOR n = 0 TO MAX_BALLS
        ' Repeat this loop if vx=0 and vy=0
        DO
            ' Load with random data
            Balls(n,BALL_X)=(RND * 29) + 1
            Balls(n,BALL_Y)=(RND * 21) + 1
            ' The speed ranges from -1 to 1
            Balls(n,BALL_VX)=(RND * 2) - 1
            Balls(n,BALL_VY)=(RND * 2) - 1
        LOOP WHILE Balls(n,BALL_VX) = 0 AND _
            Balls(n,BALL_VY) = 0
    NEXT n
END SUB


' - Draw all the balls -------------------------------------
SUB DrawBalls()
    DIM n AS UByte
    ' Draw all the balls
    FOR n = 0 TO MAX_BALLS
        DrawBall(n)
    NEXT n
END SUB


' - Draw a ball --------------------------------------------
SUB DrawBall(n AS UByte)
    ' Draw a ball with OVER 1 (XOR)
    PRINT AT Balls(n,BALL_Y), Balls(n,BALL_X);OVER 1; _
        INK n;"\A";
END SUB


' - Detect when the ball leaves the screen -----------------
' The parameters are modified within the function
' Parameters:
'   x (Byte by reference): X coordinate
'   y (Byte by reference): Y coordinate
'   vx (Byte by reference): X velocity
'   vy (Byte by reference): Y velocity
SUB DetectCollisionArea(BYREF x AS Byte, _
    BYREF y AS Byte, _
    BYREF vx AS Byte, _
    BYREF vy AS Byte)
    ' If it goes out on the left...
    IF x < 0 THEN
        ' The x velocity is positive
        vx = 1
        ' Set x to the minimum
        x = 0
    ' If it goes out on the right...
    ELSEIF x > 31
        ' The x velocity is negative
        vx = -1
        ' Set x to the maximum
        x = 31
    END IF

    ' If it goes out on top...
    IF y < 0 THEN
        ' The y velocity is positive
        vy = 1
        ' Set y to the minimum
        y = 0
    ' If it goes out on the bottom...
    ELSEIF y > 23
        ' The y velocity is negative
        vy = -1
        ' Set y to the maximum
        y = 23
    END IF
END SUB
