' - Mapping Module -----------------------------------------

' - Initialize Mapping --------------------------------------
SUB Mapping_Initialize()
    ' For counter
    DIM n AS Integer
    
    ' We will print 16 tiles
    FOR n=0 TO 15
        ' Move left two tiles (16 pixels)
        WinScrollLeft(8,0,32,10)
        WinScrollLeft(8,0,32,10)
        ' Draw the tiles on the right
        Mapping_DrawRight(n-15)
    NEXT n

    ' Print clouds
    putChars(5,1,3,2,@Tiles_Cloud1(0))
    putChars(10,5,3,2,@Tiles_Cloud1(0))
    putChars(22,6,3,2,@Tiles_Cloud1(0))
    putChars(15,2,2,1,@Tiles_Cloud2(0))
    putChars(25,5,2,1,@Tiles_Cloud2(0))
    
    ' Print the sun   
    putChars(20,1,3,3,@Tiles_Sun(0,0))
    
    ' Adjust initial map position
    PosMap = 0
    SubPosMap = 0
END SUB


' - Draw tiles on the right ---------------------------------
' Inputs:
'   pos (Integer): Map position relative to the
'                   left corner of the screen
SUB Mapping_DrawRight(pos AS Integer)
    ' Local variables for loop, tile position, and
    ' tile number to draw
    DIM n, y, t AS UByte
    
    ' Start at row 8
    y=8
    ' Draw 4 tiles
    FOR n=0 TO 3
        ' Tile position to print (add 15 because
        ' "pos" points to the right tile)
        t=Map(pos+15,n)
        ' Print the tile
        putChars(30,y,2,2,@Tiles_Town(t,0))
        ' Increment y position by 2 (16 pixels)
        y = y + 2
    NEXT n
END SUB


' - Draw tiles on the left ----------------------------------
' Inputs:
'   pos (Integer): Map position relative to the
'                   left corner of the screen
SUB Mapping_DrawLeft(pos AS Integer)
    ' Local variables for loop, tile position, and
    ' tile number to draw
    DIM n, y, t AS UByte
    
    ' Start at row 8
    y=8
    ' Draw 4 tiles
    FOR n=0 TO 3
        ' Tile position to print
        t=Map(pos,n)
        ' Print the tile
        putChars(0,y,2,2,@Tiles_Town(t,0))
        ' Increment y position by 2 (16 pixels)
        y = y + 2
    NEXT n
END SUB


' - Restore background --------------------------------------
' Inputs:
'   pos (UByte): Map position relative to the
'                   left corner of the screen
'   subPos (UByte): Map subposition
'   y (Ubyte): Y coordinate where to print the map
SUB RestoreBackground(pos AS UByte, subPos AS UByte, y AS UByte)
    ' Local variables for "x" position, tile number,
    ' maximum and minimum values for map scrolling,
    ' x and y position of the tile on the map,
    ' and its direction in the map definition array
    DIM x, t, maxX, minX, xx, yy, dir AS UByte
    
    ' Tile y position
    yy = (y-8)/2 

    ' If we're not in an intermediate step...
    IF subPos=0 THEN
        ' Start printing at 0
        xx = 0
        ' Set minimum position
        minX = pos
    ' If we're in an intermediate step...
    ELSE
        ' Start printing at 1
        xx = 1
        ' If facing left...
        IF Orientation = 0 THEN
            ' Set minimum position
            minX = pos 
        ' If facing right
        ELSE
            ' Minimum position shifts 1 to the right
            minX = pos + 1
        END IF
    END IF
    
    ' Maximum is minimum plus 14
    maxX = minX + 14
    ' Loop from minimum to maximum position
    FOR x = minX TO maxX
        ' Get upper tile number
        t=Map(x,yy-1)
        ' Print upper tile
        putChars(xx,y-2,2,2,@Tiles_Town(t,0)) 
        ' Get lower tile number
        t=Map(x,yy) 
        ' Print lower tile
        putChars(xx,y,2,2,@Tiles_Town(t,0)) 
        ' Increment xx by 2 (16 pixels)
        xx = xx + 2
    NEXT x
END SUB


' - Draw foreground trees -----------------------------------
' Inputs:
'   pos (UByte): Map position relative to the
'                   left corner of the screen
'   subPos (UByte): Map subposition
'   y (Ubyte): Y coordinate where to print the map
SUB DrawForegroundTrees(pos AS UByte, subPos AS UByte, y AS UByte)
    ' Local variables: n counter, xa for tree position
    ' in the map, x to calculate screen position,
    ' maxX and minX define maximum and minimum values
    ' of the part of the map visible on screen, and
    ' xx is used to calculate displacement when
    ' subPos is 1
    DIM n, xa, x, maxX, minX, xx AS UByte
    
    ' If subPos is 0...
    IF subPos=0 THEN
        ' Use normal values
        xx = 0
        minX = pos
    ' If subPos is 1...
    ELSE
        ' Start printing at 1
        xx = 1
        ' If orientation is left
        IF Orientation = 0 THEN
            ' Minimum position does not change
            minX = pos 
        ' If orientation is right
        ELSE
            ' Minimum position is + 1
            minX = pos + 1
        END IF
    END IF
        
    ' Maximum map position is 14 plus the minimum
    maxX = minX + 14
    
    ' There are only 4 foreground trees
    FOR n = 0 TO 4
        ' Tree x position relative to the map
        xa=Map_Foreground(n)
        ' Check if tree is visible
        IF xa>=minX THEN
            ' By nesting two IFs we save an AND
            IF xa<=maxX THEN
                ' If it's visible, calculate x
                x = (xa - minX) * 2 + xx
                ' Draw tree mask with AND
                putCharsOverMode(x,y,4,4,2,@Tiles_Tree(1,0))
                ' Draw tree with OR
                putCharsOverMode(x,y,4,4,3,@Tiles_Tree(0,0))
            END IF
        END IF
    NEXT n   
END SUB


' - Move screen depending on orientation --------------------
' Inputs:
'   orient (UByte): Orientation of scrolling, 
'                       1=Right, 2=Left
SUB MoveScreen(orient AS UByte)
    ' If moving left...
    IF orient = 0 THEN
        ' Scroll to the character of the second third
        WinScrollRight(8,0,32,8)
        ' Erase sun (frame 1 of sun)
        putChars(20,1,3,3,@Tiles_Sun(1,0))
        ' Scroll to the pixel of the first third
        ScrollRight(0,127,255,191)
        ' Draw sun (frame 0 of sun)
        putChars(20,1,3,3,@Tiles_Sun(0,0))
    ' If moving right...
    ELSE
        ' Scroll to the character of the second third
        WinScrollLeft(8,0,32,8)
        ' Erase sun (frame 1 of sun)
        putChars(20,1,3,3,@Tiles_Sun(1,0))
        ' Scroll to the pixel of the first third
        ScrollLeft(0,127,255,191)
        ' Draw sun (frame 0 of sun)
        putChars(20,1,3,3,@Tiles_Sun(0,0))
    END IF
END SUB
