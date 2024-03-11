' - Double Size -------------------------------------------
' - Library for character and sprite enlargement


' - Prints a character or graphic at double size ---------
' Parameters:
'   x (UByte): X coordinate in pixels
'   y (UByte): Y coordinate in pixels
'   dir (UInteger): Address of the character memory
SUB DoubleSize8x8(x AS UBYTE, y AS UByte, dir2 AS UInteger)
    ' Local variables
    DIM xx, yy, nx, ny, b, a AS UByte
DIM dir AS UInteger = dir2    
    ' In pixels, 0,0 is at the bottom left, so we
    ' invert the value of y
    yy = y + 14
    ' 8 rows (8 bytes)
    FOR ny = 0 TO 7
        ' Invert x
        xx = x + 14
        ' Read the byte value
        b = PEEK(dir)
        ' Process the character (1 byte)
        FOR nx = 0 TO 7
            ' Get bit 0
            a = b bAND %1
            ' Shift the byte to the right
            b = b >> 1

            ' If bit 0 is 0
            IF a = 0 THEN
                ' Inverse mode = 1
                INVERSE 1
            ELSE
                ' Inverse mode = 0
                INVERSE 0
            END IF
            ' Draw 4 points (2x2)
            PLOT xx,yy
            PLOT xx+1,yy
            PLOT xx,yy+1
            PLOT xx+1,yy+1
            ' Shift "x" 2 pixels
            xx = xx - 2
        NEXT nx
        ' Next byte
        dir = dir + 1
        ' Shift "y" 2 pixels
        yy = yy - 2
    NEXT ny
    ' Reset the inverse
    INVERSE 0
END SUB


' - Prints text at double size ---------------------------
' Parameters:
'   x (UByte): x coordinate in pixels
'   y (UByte): y coordinate in pixels
'   text (String): text to print
SUB DoubleSizeText(x AS UByte, y AS UByte, text AS String)
    DIM dir AS UInteger
    DIM n, c, xx AS UByte
    
    ' Make a copy of x
    xx = x
    ' Loop through the string letter by letter
    FOR n = 0 TO LEN(text)-1
        ' Character address
        dir = PEEK(UInteger, 23606)
        ' ASCII code of the character
        c = CODE text(n)  
        ' Calculate the character's memory address
        dir = dir + (CAST(UInteger,c) * 8)
        ' Print the character at double size
        DoubleSize8x8(xx,y,dir)
        ' Increment xx by 16 pixels
        xx = xx + 16
    NEXT n
END SUB
