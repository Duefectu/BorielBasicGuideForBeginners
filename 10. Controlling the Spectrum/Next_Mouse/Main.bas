' - Next Mouse demo ---------------------------------------
' https://tinyurl.com/4h3jhs25

Main()
DO
LOOP


' - Defines -----------------------------------------------
' Helpers for the Monsters array
#DEFINE MONS_MAX 11
#DEFINE MONS_X 0
#DEFINE MONS_Y 1
#DEFINE MONS_ID 2
#DEFINE MONS_STATE 3
#DEFINE MONS_TIME 4
' Helpers for the Shots array
#DEFINE DIS_MAX 6
#DEFINE DIS_X 0
#DEFINE DIS_Y 1
#DEFINE DIS_STATE 2


' - Global variables ---------------------------------------
' Record and points
DIM Record, Score AS ULong
' Stores the monsters
DIM Monsters(MONS_MAX,5) AS UByte
' Game level and maximum monsters
DIM Level, MaxMonsters AS UByte
' Number of monsters eliminated in the current level
DIM NumMonsters AS UByte
' Stores the shots
DIM Shots(DIS_MAX,3) AS UByte


' - Includes ----------------------------------------------
' Boriel's libraries
#INCLUDE <retrace.bas>
' Other libraries
#INCLUDE "nextlib6.1.bas"
#INCLUDE "KMouse.bas"
#INCLUDE "Text16.bas"
' Resources
#INCLUDE "Glow.fnt.bas"
' Modules
#INCLUDE "Menu.bas"
#INCLUDE "Game.bas"


' - Main subroutine ---------------------------------------
SUB Main()
    Initialize()
    DO   
        Menu()
        Game()
    LOOP
END SUB


' - Initialize the system ---------------------------------
SUB Initialize()
    ' Yellow border, transparent paper, and yellow ink
    BORDER 0
    PAPER 3
    BRIGHT 1
    INK 6
    CLS
    
    ' Set clock to 28Mhz
    NextReg($07,3)
    ' Set priorities: Sprites -> ULA ->  Layer2
    NextReg($15,%01001001)
    ' Transparent colour for ULA (bright magenta)
    NextReg($14,231)
            
    ' Show and clear Layer 2
    ShowLayer2(1)
    CLS256(0)
    
    ' Load sprites
    LoadSD("Monsters.nspr",$c000,$4000,0)
    ' Define sprites
    InitSprites(16,$c000)
    
    ' Load the font for Next
    LoadSD("Glow.ntil",$c000,$4000,0)
    
    ' Define the default font for ULA
    POKE(UInteger 23606,@Glow-256)

    ' Patch IY for emulator compatibility
    PatchIY()
END SUB
