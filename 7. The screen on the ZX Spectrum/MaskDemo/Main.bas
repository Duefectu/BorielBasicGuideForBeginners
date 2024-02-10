' - MascarasDemo ------------------------------------------
' http://tinyurl.com/yruv6pw9

Main()
STOP

' - Includes ----------------------------------------------
#INCLUDE <putchars.bas>
#INCLUDE "Donut.spr.bas"


' - Subrutina principal -----------------------------------
SUB Main()
    ' We will use these to draw the background
    DIM x, y AS UByte

    ' Rows from 0 to 22 skipping by 2
    FOR y = 0 TO 22 STEP 2
        ' Columns from 0 to 30 skipping by 2
        FOR x = 0 TO 30 STEP 2
            ' Draw the background tile
            PutChars(x,y,2,2,@Donut_Background(0))
        NEXT x
    NEXT y

    ' Draw the Donut on the left side
    PutChars(10,10,2,2,@Donut_Sprite(0))

    ' Draw the sprite with the mask on the right side
    ' Print the mask with an AND (2)
    putCharsOverMode(20,10,2,2,2,@Donut_Sprite_Mask(0))
    ' Print the sprite with an OR (3)
    putCharsOverMode(20,10,2,2,3,@Donut_Sprite(0))
END SUB
