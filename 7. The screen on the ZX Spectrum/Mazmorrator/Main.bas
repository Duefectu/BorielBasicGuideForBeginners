' - Mazmorrator -------------------------------------------
' https://tinyurl.com/thr5wkte

Main()
STOP


' - Defines -----------------------------------------------
#DEFINE PANTALLAS_MAX 1


'- Variables globales -------------------------------------
' Pantalla actual
DIM pantalla AS UByte
' Tiempo restante y vidas que nos quedan
DIM tiempo, vidas AS UByte
' Puntos de la partida
DIM puntos AS ULong
' Coordenadas del sprite
DIM x, y AS UByte
' Frame del sprite y contador alternativo
DIM frame, subFrame AS UByte
' Orientación: 0=arriba, 1=derecha, 2=abajo, 3=izquierda
DIM orientacion AS UByte
' 1 si está caminando o 0 si está parado
DIM caminando AS UByte


' - Includes ----------------------------------------------
#INCLUDE <putchars.bas>
#INCLUDE <retrace.bas>
#INCLUDE "Ingrid.spr.bas"
#INCLUDE "Tiles.spr.bas"
#INCLUDE "Mapas.bas"
#INCLUDE "Mapeado.bas"
#INCLUDE "Juego.bas"


' - Main --------------------------------------------------
SUB Main()
    ' Inicializa el sistema
    Inicializar()

    ' TODO: Menú del juego
    
    ' Pone en marcha el juego    
    Juego()
END SUB


' - Inicializa el sistema ---------------------------------
SUB Inicializar()
    BORDER 0
    PAPER 0
    INK 7
    BRIGHT 0
    CLS
END SUB

