' - TestShip ----------------------------------------------
' https://tinyurl.com/yj2eauaa

' Include the file with the sprite definitions
#INCLUDE "Ship.gdu.bas"
#INCLUDE "Font.fnt.bas"
#INCLUDE "Font1.fnt.bas"
#INCLUDE "Font2.fnt.bas"

' Clear the screen and set it to black
BORDER 0
PAPER 0
INK 7
BRIGHT 0
CLS

' Adjust the address of the GDUs
POKE UInteger 23675, @ShipGDUs
' Print the ship
PRINT AT 10,12;"\A\B\C";

' Print the normal font
PRINT AT 0,0;"THIS IS THE NORMAL FONT"
' Adjust the address of the new font
POKE UInteger 23606,@Font-256
PRINT AT 2,0;"THIS IS THE NEW FONT"

' Adjust the address of the new font1
POKE UInteger 23606,@Font1-256
PRINT AT 4,0;INK 2;"THIS FONT IS MULTICOLOR 8X16"
' Adjust the address of the new font2
POKE UInteger 23606,@Font2-256
PRINT AT 5,0;INK 3;"THIS FONT IS MULTICOLOR 8X16"
