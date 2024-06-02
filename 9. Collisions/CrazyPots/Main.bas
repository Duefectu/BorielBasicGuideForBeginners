' - Crazy Pots -------------------------------------------
' https://tinyurl.com/ynj4dvf5

Main()
STOP


' - Definitions ------------------------------------------
#DEFINE THINGS_MAX 10
#DEFINE THING_X 0
#DEFINE THING_Y 1
#DEFINE THING_FRAME 2
#DEFINE THING_TYPE 3


' - Global variables --------------------------------------
' Coordinates x, y, orientation, step, and subFrame of Ingrid
DIM Ix, Iy, Io, Ip, Isf AS UByte
' Falling things
DIM Things(THINGS_MAX, 3) AS Byte
' Number of things falling
DIM FallingThings AS UByte
' Pot sequence
DIM FlowerpotsSequence(7, 1) AS UByte
' Sprites direction of the pots
DIM PotsDir(4) AS UInteger

' Scores
DIM Points, Record AS ULong
' Level and lives
DIM Level, Lives AS UByte


' - Includes ----------------------------------------------
#INCLUDE <putchars.bas>
#INCLUDE <retrace.bas>
#INCLUDE <winscroll.bas>
#INCLUDE "Ingrid.spr.bas"
#INCLUDE "Things.spr.bas"
#INCLUDE "Glow.fnt.bas"
#INCLUDE "Menu.bas"
#INCLUDE "Game.bas"
#INCLUDE "DoubleSize.bas"
#INCLUDE "Scoreboard.bas"


' - Main subroutine ---------------------------------------
SUB Main()
    ' Initialize the system
    Initialize()

    ' Infinite loop
    DO
        ' Display the menu
        Menu()
        ' Game loop
        Game()
    LOOP
END SUB


' - Initialize the system --------------------------------
SUB Initialize()
    ' Adjust colours and clear the screen
    BORDER 1
    PAPER 7
    INK 0
    CLS
    
    ' Change the system font
    POKE (UInteger 23606, @Glow-256)
    
    ' Define the direction of the pot sprites
    PotsDir(0) = @Things_Pot1
    PotsDir(1) = @Things_Pot2
    PotsDir(2) = @Things_Pot3
    PotsDir(3) = @Things_Gift
END SUB
