' - Tiles Demo --------------------------------------------
' http://tinyurl.com/yvb9mnr7

Main()
STOP

' - Defines -----------------------------------------------
#DEFINE SCREENS_MAX 1

' - Includes ----------------------------------------------
#INCLUDE <putchars.bas>
#INCLUDE "Maps.bas"
#INCLUDE "Tiles.spr.bas"


' - Main subroutine ----------------------------------------
SUB Main()
    DIM n AS UByte
    
    BORDER 1
    PAPER 0
    INK 7
    BRIGHT 0
    CLS
    
    FOR n = 0 TO SCREENS_MAX
        DrawScreen(n)
        PAUSE 0
    NEXT n
END SUB


' - Draws a screen -----------------------------------------
' Inputs:
'   screen (UByte): Screen number to draw
SUB DrawScreen(screen AS UByte)
    ' Local variables
    ' For drawing loop
    DIM x, y AS UByte
    ' Position of the tile on screen
    DIM tx, ty AS UByte
    ' Next tile direction in the map
    DIM dir AS UByte
    ' Tile number to draw
    DIM tile AS UByte
    
    ' Start from the first byte of the map
    dir = 0
    ' Initial Y position on screen: 0
    ty = 0
    ' Iterate over rows from 0 to 11
    FOR y = 0 TO 11
        ' Initial X position on screen: 0
        tx = 0
        ' Iterate over columns from 0 to 15
        FOR x = 0 TO 15
            ' Get the tile number to draw
            tile = Screens(screen, dir)   
            ' Draw the sprite/tile
            PutChars(tx, ty, 2, 2, @Tiles_Castle(tile, 0))
            ' Color the tile with attributes
            PaintData(tx, ty, 2, 2, @Tiles_Castle_Attr(tile, 0))
            ' Next map direction
            dir = dir + 1
            ' Next column (X position) on screen
            tx = tx + 2
        NEXT x
        ' Next row (Y position) on screen
        ty = ty + 2
    NEXT y
END SUB