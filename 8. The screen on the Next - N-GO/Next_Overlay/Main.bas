' - Next Overlay Demo -------------------------------------
' http://tinyurl.com/bdzxfwmb

Main()
DO
LOOP


' - Definitions ------------------------------------------
' We'll use these to identify the subindices of the sprite matrix
#DEFINE SPRITE_X 0
#DEFINE SPRITE_Y 1
#DEFINE SPRITE_ID 2
#DEFINE SPRITE_WIDTH 3
#DEFINE SPRITE_HEIGHT 4
#DEFINE SPRITE_VEL 5


' - Includes ----------------------------------------------
#INCLUDE <retrace.bas>
#INCLUDE "nextlib8.bas"


' - Main subroutine -----------------------------------
SUB Main()
    ' Initialize the system
    Initialize()
    ' Launch the demo
    Demo()
END SUB


' - Initialize the system ---------------------------------
SUB Initialize()
    ' Yellow border, transparent paper, and yellow ink
    BORDER 0
    PAPER 0
    INK 7
    CLS
    
    ' Set the clock to 28MHz
    NextReg($07,3)
    ' Set priorities: Sprites -> Layer2 -> ULA
    NextReg($15,%00000001)
    
    ' Load the ULA screen
    LoadSD("Dawn.scr",$4000,$1b00,0)
    
    ' Load the Layer 2 screen
    LoadBMPOld("Mountains.bmp")

    ' Show Layer 2
    ' It's important to activate Layer 2 after loading the screen
    ' to see the bitmap correctly
    ShowLayer2(1)
       
    ' Load sprites
    LoadSD("Sprites.nspr",$c000,$4000,0)
    ' Define sprites
    InitSprites(36,$c000)
END SUB


' - Demo --------------------------------------------------
SUB Demo()
    ' Layer 2 scroll pointer
    DIM xLayer2 AS UInteger = 0
    ' We'll define 20 sprites
    DIM sprites(19,5) AS UInteger
    ' ID of each of the sprite patterns
    DIM dirSprite(7) AS UByte => { 0,4,6,8,12,18,24,30 }
    ' Define the size of the 8 sprites we'll use
    DIM sizes(7,1) AS UBYTE => { _
        { 4, 1 }, { 2, 1 }, {2, 1}, {4, 1}, _
        { 2, 3 }, { 2, 3 }, {2, 3}, {2, 3} _
    }
    ' Temporary variables for logic
    DIM n, id, width, height, nWidth, nHeight, y, spr AS UByte
    DIM x, v AS UInteger

    ' Initialize the RND seed
    RANDOMIZE 0
    
    ' Create 5 Clouds
    FOR n = 0 TO 5
        sprites(n,SPRITE_X) = RND * 320
        sprites(n,SPRITE_Y) = (RND * 60) + 32
        id = RND * 4        
        sprites(n,SPRITE_ID) = dirSprite(id)
        sprites(n,SPRITE_WIDTH) = sizes(id,0)
        sprites(n,SPRITE_HEIGHT) = sizes(id,1)
        sprites(n,SPRITE_VEL) = RND * 2
     NEXT n
     ' Create 10 slow trees
     FOR n = 5 TO 15
        sprites(n,SPRITE_X) = RND * 320
        sprites(n,SPRITE_Y) = 135
        id = (RND * 4) + 4       
        sprites(n,SPRITE_ID) = dirSprite(id)
        sprites(n,SPRITE_WIDTH) = sizes(id,0)
        sprites(n,SPRITE_HEIGHT) = sizes(id,1)
        sprites(n,SPRITE_VEL) = 3
     NEXT n 
     ' Create 3 faster trees
     FOR n = 15 TO 18
        sprites(n,SPRITE_X) = RND * 320
        sprites(n,SPRITE_Y) = 145
        id = (RND * 4) + 4       
        sprites(n,SPRITE_ID) = dirSprite(id)
        sprites(n,SPRITE_WIDTH) = sizes(id,0)
        sprites(n,SPRITE_HEIGHT) = sizes(id,1)
        sprites(n,SPRITE_VEL) = 4
     NEXT n 
     ' Create 2 even faster trees
     FOR n = 18 TO 20
        sprites(n,SPRITE_X) = RND * 320
        sprites(n,SPRITE_Y) = 150
        id = (RND * 4) + 4       
        sprites(n,SPRITE_ID) = dirSprite(id)
        sprites(n,SPRITE_WIDTH) = sizes(id,0)
        sprites(n,SPRITE_HEIGHT) = sizes(id,1)
        sprites(n,SPRITE_VEL) = 5
     NEXT n
    
    ' Infinite loop
    DO
        ' Synchronize with screen scan
        waitretrace
        ' Layer 2 scroll
        ScrollLayer(xLayer2,0)
        xLayer2 = xLayer2 + 2
        
        ' Begin updating the 20 sprites
        spr = 0
        FOR n = 0 TO 20
            ' Copy sprite data to local variables
            ' to speed up processing
            y = sprites(n,SPRITE_Y)
            id = sprites(n,SPRITE_ID)
            width = sprites(n,SPRITE_WIDTH)-1
            height = sprites(n,SPRITE_HEIGHT)-1
            ' Sprite height loop
            FOR nHeight = 0 TO height
                ' Initialize the x coordinate
                x = sprites(n,SPRITE_X)
                ' Sprite width loop
                FOR nWidth = 0 TO width
                    ' Update sprite position
                    UpdateSprite(x,y,spr,id,0,0)
                    ' Increment the frame
                    id = id + 1
                    ' Increment the sprite id
                    spr = spr + 1
                    ' Increment x by 16
                    x = x + 16
                NEXT nWidth
                ' Increment y by 16
                y = y + 16
            NEXT nHeight 
            
            ' Detect if the sprite is lost to the left of the screen
            v = sprites(n,SPRITE_VEL)
            x = sprites(n,SPRITE_X)        
            IF v > x THEN
                ' If it's lost, place it to the right
                sprites(n,SPRITE_X) = 320
            ELSE
                ' If not lost, move it to the left
                sprites(n,SPRITE_X) = x - v
            END IF
        NEXT n
    LOOP
END SUB
