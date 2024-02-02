' - TestNave ----------------------------------------------
' https://tinyurl.com/yj2eauaa


' Incluimos el fichero con la definión de los sprites
#INCLUDE "Nave.gdu.bas"
#INCLUDE "Fuente.fnt.bas"
#INCLUDE "Fuente1.fnt.bas"
#INCLUDE "Fuente2.fnt.bas"

' Borramos la pantalla y la dejamos en negro
BORDER 0
PAPER 0
INK 7
BRIGHT 0
CLS

' Ajustamos la dirección de los GDUs
POKE UInteger 23675, @GDUsNave
' Imprimimos la nave
PRINT AT 10,12;"\A\B\C";

' Imprimimos la fuente normal
PRINT AT 0,0;"ESTO ES LA FUENTE NORMAL"
' Ajustamos la dirección de la nueva fuente
POKE UInteger 23606,@Fuente-256
PRINT AT 2,0;"ESTO ES LA FUENTE NUEVA"

' Ajustamos la dirección de la nueva fuente1
POKE UInteger 23606,@Fuente1-256
PRINT AT 4,0;INK 2;"ESTA FUENTE ES MULTICOLOR 8X16"
' Ajustamos la dirección de la nueva fuente2
POKE UInteger 23606,@Fuente2-256
PRINT AT 5,0;INK 3;"ESTA FUENTE ES MULTICOLOR 8X16"

