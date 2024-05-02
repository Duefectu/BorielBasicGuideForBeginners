' - Next Mouse demo ---------------------------------------
' https://tinyurl.com/yc4sn96w

Main()
DO
LOOP


' - Defines -----------------------------------------------
' Ayudas para la matriz Monstruos
#DEFINE MONS_MAX 11
#DEFINE MONS_X 0
#DEFINE MONS_Y 1
#DEFINE MONS_ID 2
#DEFINE MONS_ESTADO 3
#DEFINE MONS_TIEMPO 4
' Ayudas para la matriz Disparos
#DEFINE DIS_MAX 6
#DEFINE DIS_X 0
#DEFINE DIS_Y 1
#DEFINE DIS_ESTADO 2


' - Variables globales ------------------------------------
' Record y puntos
DIM Record, Puntos AS ULong
' Almacena los monstruos
DIM Monstruos(MONS_MAX,5) AS UByte
' Nivel del juego y máximo de monstruos
DIM Nivel, MaxMonstruos AS UByte
' Número de monstruos eliminados en el nivel actual
DIM NumMonstruos AS UByte
' Almacena los disparos
DIM Disparos(DIS_MAX,3) AS UByte


' - Includes ----------------------------------------------
' Librerías de Boriel
#INCLUDE <retrace.bas>
' Otras librerías
#INCLUDE "nextlib6.1.bas"
#INCLUDE "KMouse.bas"
#INCLUDE "Texto16.bas"
' Recursos
#INCLUDE "Glow.fnt.bas"
' Módulos
#INCLUDE "Menu.bas"
#INCLUDE "Juego.bas"


' - Subrutina principal -----------------------------------
SUB Main()
    Inicializar()
    DO   
        Menu()
        Juego()
    LOOP
END SUB


' - Inicializa el sistema ---------------------------------
SUB Inicializar()
    ' Borde amarillo, papel transparente y tinta amarilla
    BORDER 0
    PAPER 3
    BRIGHT 1
    INK 6
    CLS
    
    ' Ponemos el reloj a 28Mhz
    NextReg($07,3)
    ' Establecemos prioridades: Sprites -> ULA ->  Layer2
    NextReg($15,%01001001)
    ' Color transparente para la ula (magenta con brillo)
    NextReg($14,231)
            
    ' Mostramos y borramos la Layer 2
    ShowLayer2(1)
    CLS256(0)
    
    ' Cargamos los sprites
    LoadSD("Monsters.nspr",$c000,$4000,0)
    ' Definimos los sprites
    InitSprites(16,$c000)
    
    ' Cargamos la fuente para Next
    LoadSD("Glow.ntil",$c000,$4000,0)
    
    ' Definimos la fuente por defecto para la ULA
    POKE(UInteger 23606,@Glow-256)

    ' Parcheamos IY para que funcionen bien los emuladores
    PathIY()
END SUB