' - Next Layer 2 Demo -------------------------------------
' http://tinyurl.com/29fsb3c9

Main()
DO
LOOP


' - Includes ----------------------------------------------
#INCLUDE <retrace.bas>
#INCLUDE "nextlib8.bas"


' - Main subroutine ----------------------------------------
SUB Main()
    ' Initialize the system
    Initialize()
    ' Layer 2 demo, 256x192
    Layer2_256x192()
    ' Sprite demo
    DemoSprite()
END SUB


' - Initialize the system -----------------------------------
SUB Initialize()
    ' Yellow border, transparent paper, and yellow ink
    BORDER 6
    PAPER 3
    BRIGHT 1
    INK 6
    CLS

    ' Set clock to 28Mhz
    NextReg($07, 3)
    ' Set priorities: Sprites -> ULA -> Layer2
    NextReg($15, %00001001)
    ' Transparent colour for the ula (magenta with brightness)
    NextReg($14, 231)

    ' Print in the ULA layer
    PRINT AT 0, 0; "This is the ULA layer";

    ' Load sprites
    LoadSD("Ingrid.nspr", $c000, $4000, 0)
    ' Define sprites
    InitSprites(4, $c000)

    ' Load tiles (16x16x20)
    LoadSD("Tiles.ntil", $c000, $1500, 0)
    ' Load map definition (16x12)
    LoadSD("Map.nmap", $d500, 192, 0)
END SUB


' - Layer 2 demo, 256x192 with 256 colours -------------
SUB Layer2_256x192()
    DIM x, y AS UInteger
    DIM t AS UByte

    ' Show Layer 2
    ShowLayer2(1)

    ' Print the layer name on the ULA
    PRINT AT 23, 0; "Layer 2: 256x192, 256 colours";

    ' Fill the screen with colour 2 (blue)
    CLS256(2)
    ' We will draw 16 tiles wide
    FOR x = 0 TO 15
        ' For 12 tiles high
        FOR y = 0 TO 11
            ' Read the tile value in the map
            t = PEEK($d500 + (y * 16) + x)
            ' Draw the tile "t" at "x", "y"
            DoTile(x, y, t)
        NEXT y
    NEXT x
END SUB


' - Sprite demo ---------------------------------------
SUB DemoSprite()
    DIM x AS UInteger
    DIM st, n AS UByte

    ' Infinite loop
    DO
        ' The sprite will move from 16 to 288 in steps of 2
        FOR x = 16 TO 288 STEP 2
            ' We do 5 pauses (it goes very fast)
            FOR n = 0 TO 4
                waitretrace
            NEXT n
            ' Update the position and frame of sprite 0
            UpdateSprite(x, 48, 0, st, 0, 0)

            ' Rotate 90 degrees
            UpdateSprite(48, 72, 1, st, %00000010, 0)
            PRINT AT 5, 5; "90-degree rotation";
            ' Vertical mirror
            UpdateSprite(48, 96, 2, st, %00000100, 0)
            PRINT AT 8, 5; "Vertical mirror";
            ' Horizontal mirror
            UpdateSprite(48, 120, 3, st, %00001000, 0)
            PRINT AT 11, 5; "Horizontal mirror";
            ' Without rotation
            UpdateSprite(48, 144, 4, st, %00000000, 0)
            ' 90 degrees
            UpdateSprite(72, 144, 5, st, %00000010, 0)
            ' 180 degrees
            UpdateSprite(96, 144, 6, st, %00000100, 0)
            ' 270 degrees
            UpdateSprite(120, 144, 7, st, %00001010, 0)
            PRINT AT 14, 14; "Complete rotation";

            ' Zoom 2x
            UpdateSprite(48, 168, 8, st, 0, %00001010)
            ' Zoom 3x
            UpdateSprite(80, 168, 9, st, 0, %00010100)
            ' Zoom 4x
            UpdateSprite(132, 100, 10, st, 0, %00011110)

            ' The frame (step) goes from 0 to 3
            IF st = 3 THEN
                st = 0
            ELSE
                st = st + 1
            END IF
        NEXT x
    LOOP
END SUB
