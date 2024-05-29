' - Beepola In-Game DEMO ----------------------------------
' https://tinyurl.com/w8vwj4kv

' Jump to the main routine
Main()
STOP

' - Includes ----------------------------------------------
' Boriel libraries
#INCLUDE <keys.bas>
#INCLUDE <retrace.bas>
#INCLUDE <putchars.bas>

' Program modules
#INCLUDE "Music.bas"
#INCLUDE "StreetsOfRain.bas"
#INCLUDE "Ship.spr.bas"

' - Definitions ------------------------------------------
#DEFINE MAX_STARS 6
#DEFINE STAR_X 0
#DEFINE STAR_Y 1
#DEFINE STAR_TYPE 2

' - Main subroutine ----------------------------------------
SUB Main()    
    ' Initialize everything
    Initialize()
    ' Jump directly to the demo
    Demo()
END SUB

' - Initializes the program -------------------------------
SUB Initialize()
    DIM n AS UByte
    
    ' All black with white ink and bright
    BORDER 0
    PAPER 0
    INK 7
    BRIGHT 1
    CLS
    
    ' Initialize music
    Music_Init()
    ' Start playing music
    Music_Play()
    
    ' Initialize random numbers
    RANDOMIZE 0
END SUB

' - Main demo subroutine ----------------------------------
SUB Demo()
    ' Ship coordinates x, y, and frame
    DIM x, y, f AS UByte
    ' Copy of ship coordinates
    DIM x2, y2, n AS UByte
    ' Define an array of stars
    DIM Stars(MAX_STARS,2) AS UByte
    ' Working variables for Stars
    DIM xe, ye, te AS UByte

    ' Place the ship in the center and a bit to the left
    x = 5
    y = 10
    f = 0
    
    ' Create stars
    FOR n = 0 TO MAX_STARS-2
        Stars(n,STAR_X) = RND * 31
        Stars(n,STAR_Y) = RND * 23
        Stars(n,STAR_TYPE) = (RND * 3)+1
    NEXT n
    
    ' Print the ship for the first time
    putChars(x,y,2,2,@Navecilla_Ship(f,0))
    PRINT AT 23,0;"Press M to toggle music";
    
    ' Infinite loop
    DO        
        ' Make a copy of x and y in x2 and y2
        x2 = x
        y2 = y        
        
        ' Keyboard control
        IF MultiKeys(KEYQ) THEN     ' Up key
            IF y2 > 0 THEN
                ' If not at the top, move up
                y2 = y2 - 1
                ' Image tilts upwards
                f = 1
            END IF
        ELSEIF MultiKeys(KEYA) THEN ' Down key
            IF y2 < 22 THEN
                ' If not at the bottom, move down
                y2 = y2 + 1
                ' Image tilts downwards
                f = 2
            END IF
        ELSE IF f <> 0  ' If moving
            ' Ship image stabilized
            f = 0
        END IF

        IF MultiKeys(KEYO) THEN     ' Left key
            IF x2 > 0 THEN
                ' If not at the left edge, move left
                x2 = x2 - 1
            END IF
        ELSEIF MultiKeys(KEYP) THEN ' Right key
            IF x2 < 29 THEN
                ' If not at the right edge, move right
                x2 = x2 + 1
            END IF
        END IF

        IF Multikeys(KEYM) THEN     ' M key        
            IF Music_Playing = 1 THEN
                ' If music is playing, stop it
                Music_Stop()
                ' Wait until M key is released
                WHILE INKEY$<>"":WEND
            ELSE
                ' If music is stopped, start it
                Music_Play()
                ' Wait until M key is released
                WHILE INKEY$<>"":WEND
            END IF
        END IF       

        ' Pause to avoid flickering
        waitretrace
        
        ' Move stars
        FOR n = 0 TO MAX_STARS
            ' Assign star values to local variables
            xe=Stars(n,STAR_X)
            ye=Stars(n,STAR_Y)
            te=Stars(n,STAR_TYPE)
            ' Erase the star
            putChars(xe,ye,1,1,@Navecilla_Star(1,0))
            ' If the star is going to go out from the left...
            IF xe > te THEN
                ' If not out, subtract type from x
                xe = xe - te
                Stars(n,STAR_X) = xe
                ' Print the star
                putChars(xe,ye,1,1,@Navecilla_Star(0,0))
            ' If it's going out
            ELSE
                ' Place the star to the right
                Stars(n,STAR_X) = 31
                ' Rest of random data
                Stars(n,STAR_Y) = RND * 23
                Stars(n,STAR_TYPE) = (RND * 3)+1
            END IF
        NEXT n
        
        ' Erase the ship
        putChars(x,y,2,2,@Navecilla_Ship(3,0))
        ' Print it in the new position
        putChars(x2,y2,2,2,@Navecilla_Ship(f,0))
        ' Update x and y with x2 and y2
        x = x2
        y = y2
    LOOP
END SUB
