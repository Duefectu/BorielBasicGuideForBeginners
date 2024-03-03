' - Double Buffer Adventure -------------------------------
' http://tinyurl.com/bdemmmmr
' - Main Module --------------------------------------------


' Run main
Main()
STOP

warr
' - Double Buffer ------------------------------------------
' If we comment out this define, we deactivate the double 
' buffer
#DEFINE DOUBLE_BUFFER

#IFDEF DOUBLE_BUFFER
    ' If using double buffer, include libraries
    #INCLUDE <scrbuffer.bas>
    #INCLUDE <memcopy.bas>    
    ' Include double buffer management
    #INCLUDE "DoubleBuffer.bas"
#ENDIF


' - Global Variables ---------------------------------------
' Map position relative to the start of the screen
DIM PosMap AS Integer
' Map subposition, tiles are 16x16, thus
' controlling when we are in an intermediate step
DIM SubPosMap AS UByte
' x and y position of the heronine sprite
DIM PX, PY AS UByte
' Heroine sprite frame
DIM Frame AS UByte
' Heroine sprite subframe
DIM SubFrame AS UByte
' Heroine orientation: 1=Right, 0=Left
DIM Orientation AS UByte
' 1 if walking or 0 if standing
DIM Walking AS UByte


' - Includes ------------------------------------------------
' Boriel's native libraries
#INCLUDE <putchars.bas>
#INCLUDE <scroll.bas>
#INCLUDE <winscroll.bas>
#INCLUDE <retrace.bas>
' Graphics
#INCLUDE "Ingrid.spr.bas"
#INCLUDE "Tiles.spr.bas"
#INCLUDE "Classic.fnt.bas"
#INCLUDE "Papyrus.udg.bas"
' Modules of our program
#INCLUDE "Map.bas"
#INCLUDE "Mapping.bas"
#INCLUDE "Game.bas"


' - Main Subroutine ----------------------------------------
SUB Main()
    ' Initialize the system
    Initialize()
    ' Jump straight into the game (no menu)
    Game()
END SUB


' - Initialize System --------------------------------------
SUB Initialize()
    ' Set default colors
    BORDER 7
    PAPER 7
    INK 0
    BRIGHT 0
    ' Clear the screen
    CLS
    
    ' Adjust the UDGs' direction
    POKE (UInteger 23675,@Papyrus(0,0))
    ' Adjust the font (typeface) direction
    POKE (UInteger 23606,@Classic(0,0)-256)
END SUB
