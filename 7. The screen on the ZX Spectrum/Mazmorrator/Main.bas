' - Mazmorrator -------------------------------------------
' http://tinyurl.com/mwnyuur

Main()
STOP


' - Defines -----------------------------------------------
#DEFINE SCREENS_MAX 1


'- Global Variables ----------------------------------------
' Current screen
DIM screen AS UByte
' Remaining time and remaining lives
DIM time, lives AS UByte
' Game points
DIM score AS ULong
' Sprite coordinates
DIM x, y AS UByte
' Sprite frame and alternate counter
DIM frame, subFrame AS UByte
' Orientation: 0=up, 1=right, 2=down, 3=left
DIM orientation AS UByte
' 1 if walking, 0 if standing
DIM walking AS UByte


' - Includes ----------------------------------------------
#INCLUDE <putchars.bas>
#INCLUDE <retrace.bas>
#INCLUDE "Ingrid.spr.bas"
#INCLUDE "Tiles.spr.bas"
#INCLUDE "Maps.bas"
#INCLUDE "Mapping.bas"
#INCLUDE "Game.bas"


' - Main --------------------------------------------------
SUB Main()
    ' Initialize the system
    Initialize()

    ' TODO: Game menu
    
    ' Start the game    
    Game()
END SUB


' - Initialize the system ---------------------------------
SUB Initialize()
    BORDER 0
    PAPER 0
    INK 7
    BRIGHT 0
    CLS
END SUB
