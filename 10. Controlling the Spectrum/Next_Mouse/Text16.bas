' - Next_Mouse --------------------------------------------
' - 16 x 16 pixels text -------------------------------

' - Prints text with multicolor 16x16 fonts --
' Uses tiles located at address $c000
' Parameters:
'   x (UByte): Cell x in 16-pixel resolution (0 to 15)
'   y (UByte): Cell y in 16-pixel resolution (0 to 11)
'   txt (String): Text to print (uppercase only)
SUB PrintText16(x AS UByte, y AS UByte, txt AS String)
    DIM n, c AS UByte
    DIM dir AS UInteger
    
    ' Iterate through the entire text string
    FOR n = 0 TO LEN(txt)-1
        ' ASCII code of the current letter
        c = CODE txt(n)
        ' If the code is between "A" and "Z"...
        IF c > 64 AND c < 91 THEN
            ' Subtract 61 from the code
            c = c - 61
        ' If the code is between "0" and "9"...
        ELSEIF c > 47 AND c < 58 THEN
            ' Subtract 16 from the code
            c = c - 16
        ' If it's ":" the code is 30            
        ELSEIF c = 58 THEN
            c = 30
        ' If it's "." the code is 31
        ELSEIF c = 46 THEN
            c = 31
        ' If it's "!" the code is 1            
        ELSEIF c = 33 THEN  ' !
            c = 1
        ' If it's " the code is 2
        ELSEIF c = 34 THEN
            c = 2
        ' If none of the above, do not print
        ELSE      
            c = 0
        END IF
        ' Print the 16x16 Tile        
        DoTile(x,y,c)
        ' Increment x
        x = x + 1
    NEXT n
END SUB


' - Prints centered text with multicolor 16x16 font -
'   y (UByte): Cell y in 16-pixel resolution (0 to 11)
'   txt (String): Text to print (uppercase only)
SUB PrintCentered16(y AS UByte, txt AS String)
    DIM x AS UByte
    ' Half of the screen (8) minus half of the text length
    x = 8 - (LEN(txt) / 2)
    ' Print the text
    PrintText16(x,y,txt) 
END SUB
