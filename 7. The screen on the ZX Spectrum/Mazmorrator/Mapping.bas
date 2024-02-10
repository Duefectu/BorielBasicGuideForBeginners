' - Map Management --------------------------------------

' - Draw a screen ----------------------------------------
' Inputs:
'   screen (UByte): Screen number to draw
SUB DrawScreen(screen AS UByte)
    ' Local variables
    ' For the drawing loop
    DIM x, y AS UByte
    ' Position of the tile on the screen
    DIM tx, ty AS UByte
    ' Direction of the next tile in the map
    DIM dir AS UByte
    ' Number of tile to draw
    DIM tile AS UByte
    
    ' Start from the first byte of the map
    dir = 0
    ' Initial Y position on the screen: 0
    ty = 0
    ' Iterate through rows from 0 to 11
    FOR y = 0 TO 11
        ' Initial X position on the screen: 0
        tx = 0
        ' Iterate through columns from 0 to 15
        FOR x = 0 TO 15
            ' Get the number of tile to draw
            tile = Screens(screen, dir)   
            ' Print the sprite/tile
            PutChars(tx, ty, 2, 2, @Tiles_Castle(tile, 0))
            ' Color the tile with the attributes
            PaintData(tx, ty, 2, 2, @Tiles_Castle_Attr(tile, 0))
            ' Next direction in the map
            dir = dir + 1
            ' Next column (X position) on the screen
            tx = tx + 2
        NEXT x
        ' Next row (Y position) on the screen
        ty = ty + 2
    NEXT y
END SUB


' - Get the tile from a screen ----------------------------
' Parameters:
'   screen (UByte): Screen to get the tile from
'   x (UByte): Coordinate x (column)
'   y (UByte): Coordinate y (row)
' Returns:
'   (UByte): Tile located at the specified position
FUNCTION GetTile(screen AS UByte, x AS UByte, y AS UByte) AS UByte
    DIM dir AS UByte
    ' Tile direction (y*16)+x, except tiles are 
    ' 16x16, so we need to divide x and y by two.
    dir = ((y/2) * 16) + (x/2)
    RETURN Screens(screen, dir)
END FUNCTION
