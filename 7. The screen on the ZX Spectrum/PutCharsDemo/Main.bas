' - PutCharsDemo ------------------------------------------
' http://tinyurl.com/2x45u65y

Main()
STOP


' - Includes ----------------------------------------------
#INCLUDE <putchars.bas>
#INCLUDE <retrace.bas>
#INCLUDE "Ingrid.spr.bas"


' - Variables ---------------------------------------------
' Ingrid's orientation (1=right, 0=left)
DIM orientation AS UByte = 1
' Animation frame
DIM frame AS UByte = 0
' Sub-frame to slow down the animation
DIM subFrame AS UByte = 0
' Sprite position
DIM x, y AS UByte
' Movement indicator, 1=walking, 0=standing
DIM walking AS UByte

' - Main subroutine ---------------------------------------
SUB Main() 
    ' Store the pressed key in "k"
    DIM k AS String 
    
    ' Initialize the variables controlling the sprite
    x = 14
    y = 10
    orientation = 1
    walking = 0
    frame = 0
    subFrame = 0
    
    ' Infinite loop
    DO
        ' Wait for the retrace
        waitretrace
        
        ' Check if it's standing still or moving
        IF walking = 0 THEN
           ' It's standing still, print according to orientation
           IF orientation = 1 THEN
             ' Facing right
             putChars(x,y,2,2,@Ingrid_Stand_right(frame,0))
           ELSE
             ' Facing left
             putChars(x,y,2,2,@Ingrid_Stand_left(frame,0))
           END IF
           ' Increment the sub-frame
           subFrame = subFrame + 1
           IF subFrame >= 10 THEN
              ' If sub-frame is 10, increment frame
              frame = frame + 1
              IF frame = 2 THEN
                  ' If we exceed the frame, reset to 0
                  frame = 0
              END IF
              subFrame = 0
           END IF       
        ELSE            
          ' It's walking, print according to orientation
          IF orientation = 1 THEN
              ' Walking to the right
              ' Clear the left column
              putChars(x,y,1,2,@Ingrid_Blank(0))
              ' If it hasn't reached the edge, increment x
              IF x < 30 THEN
                  x = x + 1
              END IF
              ' Print the sprite
              putChars(x,y,2,2,@Ingrid_Walk_right(frame,0))                
          ELSE
              ' Walking to the left
              ' Clear the left column
              putChars(x+1,y,1,2,@Ingrid_Blank(0))
              ' If it hasn't reached the edge, decrement x
              IF x > 0 THEN
                  x = x - 1
              END IF
              ' Print the sprite
              putChars(x,y,2,2,@Ingrid_Walk_left(frame,0))
          END IF
          ' Increment the frame, no sub-frame here
          frame = frame + 1
          IF frame = 4 THEN
              frame = 0
              walking = 0
          END IF
        END IF
        
        ' Read the keyboard
        k = INKEY$
        ' If the "o" key is pressed
        IF k = "o" THEN
            ' Turn left
            orientation = 0
            ' Walk
            walking = 1
        ELSEIF k = "p" THEN
            ' Turn right
            orientation = 1
            ' Walk
            walking = 1
        END IF
    LOOP
END SUB
