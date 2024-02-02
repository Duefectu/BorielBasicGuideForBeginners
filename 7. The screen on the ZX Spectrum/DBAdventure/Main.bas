' - Double Buffer Adventure -------------------------------
' https://tinyurl.com/yc39zj32
' - Módulo principal --------------------------------------


' Ejecutamos main
Main()
STOP


' - Doble buffer ------------------------------------------
' Si comentamos este define desactivamos el doble buffer
#DEFINE DOUBLE_BUFFER

#IFDEF DOUBLE_BUFFER
    ' Si usamos doble buffer, incluimos las librerías
    #INCLUDE <scrbuffer.bas>
    #INCLUDE <memcopy.bas>    
    ' Incluimos la gestión del doble buffer
    #INCLUDE "DobleBuffer.bas"
#ENDIF


' - Variables Globales ------------------------------------
' Posición del mapa con respecto al inicio de la pantalla
DIM PosMapa AS Integer
' Subposición del mapa, los tiles son de 16x16, así
' controlamos cuando estamos en un paso intermedio
DIM SubPosMapa AS UByte
' Posición x e y del sprite de la guerrera
DIM PX, PY AS UByte
' Frame del sprite de la guerrera
DIM Frame AS UByte
' SubFrame del sprite de la guerrera
DIM SubFrame AS UByte
' Orientación de la guerrera: 1=Derecha, 0=Izquierda
DIM Orientacion AS UByte
' 1 si está caminando o 0 si está parada
DIM Caminando AS UByte


' - Includes ----------------------------------------------
' Librerías nativas de Boriel
#INCLUDE <putchars.bas>
#INCLUDE <scroll.bas>
#INCLUDE <winscroll.bas>
#INCLUDE <retrace.bas>
' Graficos
#INCLUDE "Ingrid.spr.bas"
#INCLUDE "Tiles.spr.bas"
#INCLUDE "Clasico.fnt.bas"
#INCLUDE "Papel.udg.bas"
' Módulos de nuestro programa
#INCLUDE "Mapa.bas"
#INCLUDE "Mapeado.bas"
#INCLUDE "Juego.bas"


' - Subrutina principal -----------------------------------
SUB Main()
    ' Inicializa el sistema
    Inicializar()
    ' Salta al juego directamente (no hay menú)
    Juego()
END SUB


' - Iniciliza el sistema ----------------------------------
SUB Inicializar()
    ' Establecemos los colores por defecto
    BORDER 7
    PAPER 7
    INK 0
    BRIGHT 0
    ' Borramos la pantalla
    CLS
    
    ' Ajustamos la dirección de los GDUs
    POKE (UInteger 23675,@Papel(0,0))
    ' Ajustamos la dirección de la fuente (tipo de letra)
    POKE (UInteger 23606,@Clasico(0,0)-256)
END SUB
