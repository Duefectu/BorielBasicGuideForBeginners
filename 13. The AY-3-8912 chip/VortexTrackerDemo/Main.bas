' - VortexTrackerDemo -------------------------------------
' https://tinyurl.com/mrye2ua8

' Run the main subroutine
Main()
Stop


' - Includes ----------------------------------------------
#INCLUDE <Retrace.bas>
#INCLUDE "VortexTracker.bas"
#INCLUDE "IM2.bas"


' - Variables ---------------------------------------------
' Coordinate cache for the explosion
DIM cacheX(96) AS UByte
DIM cacheY(96) AS UByte
' Number of cached coordinates
DIM max AS UByte


' - Main Subroutine ----------------------------------------
SUB Main()
    ' Initialize the system
    Initialize()
       
    DO
        ' Launch fireworks as if there were no tomorrow
        FireWork()
    LOOP
END SUB


' - Initialize the system ---------------------------------
SUB Initialize()   
    ' Load the player
    LOAD "" CODE
    ' Load the song
    LOAD "" CODE
    
    BORDER 0
    PAPER 0
    INK 6
    BRIGHT 1
    
    ' Initialize the music
    VortexTracker_Initialize(1)

    CLS

    ' Cache explosion
    PRINT AT 0,0;"Counting stars...";    
    ' Calculate the points that will draw the explosion.
    ' All explosions are the same, so it's enough
    ' to calculate it once, thus speeding up.
    ' Counter
    DIM c AS UByte = 0
    ' Modules and angles of the explosion    
    DIM a, m AS Fixed
    ' Screen coordinates
    DIM x, y AS Fixed
    ' Module from 0 to 3.14 radians
    FOR a = 0 TO 3.14 STEP .2
        ' Angle from .4 to 6.14 radians
        FOR m = .4 TO 6.14 STEP 1.2
            ' Calculate the X and Y coordinate of the point
            x = 128 + (COS(m)*a*10)
            y = 96 + (SIN(m)*a*10) + (SIN(a) * 10)
            ' Save the point in the cache
            cacheX(c)=x
            cacheY(c)=y
            c=c+1
            PRINT ".";
        NEXT m
    NEXT a
    max = c - 1
END SUB


' - Launch a firework --------------------------------------
SUB FireWork()
    ' X coordinate from where it launches
    DIM xi AS Integer
    ' Working coordinates
    DIM x, y, lx, ly AS Integer
    ' Fire colour
    Dim i AS UByte
    ' Explosion counter
    DIM c AS UByte
    ' Angle and module 
    DIM a, m AS Fixed    
    
    ' Create the firework
    ' Initial X coordinate
    xi = (RND * 128) + 50
    ' Module (height) of the firework
    m = (RND * 100) + 64
    ' Fire colour
    i = (RND * 7)+1
    ' Reset the rest
    a = 0
    lx = 0
    ly = 0
    
    ' Launch the rocket
    CLS
    INK i
    ' Draw an ascending arc erasing the trail
    FOR a = 0 TO 1.57 STEP .05
        x = xi+(a*20)
        y = SIN(a) * m
        PLOT INK 0;lx,ly
        PLOT INK i;x,y     
        lx = x
        ly = y
    NEXT a
    
    ' Explode using cached data
    FOR c=0 TO max
        ' Draw the points
        PLOT lx-128+cacheX(c),ly-96+cacheY(c)
        ' Pause for 20ms
        waitretrace
    NEXT c
    CLS
END SUB
