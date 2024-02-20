' - Next Scroll -------------------------------------
' https://tinyurl.com/mtw867rx

Main()
DO
LOOP


' - Includes ----------------------------------------------
#INCLUDE <retrace.bas>
#INCLUDE "nextlib8.bas"


' - Subrutina principal -----------------------------------
SUB Main()
    ' Inicializa el sistema
    Inicializar()    
    ' Demo de la Layer 2, 256x192
    Layer2_256x192()
    ' Demo de Sprites
    DemoSprite()
END SUB


' - Inicializa el sistema ---------------------------------
SUB Inicializar()
    ' Borde amarillo, papel transparente y tinta amarilla
    BORDER 6
    PAPER 3
    BRIGHT 1
    INK 6
    CLS
    
    ' Ponemos el reloj a 28Mhz
    NextReg($07,3)
    ' Establecemos prioridades: Sprites -> ULA ->  Layer2
    NextReg($15,%00001001)
    ' Color transparente para la ula (magenta con brillo)
    NextReg($14,231)
    
    ' Imprimimos en la capa de la ULA
    PRINT AT 0,0;"Esta es la capa ULA";
    
    ' Cargamos los sprites
    LoadSD("Ingrid.nspr",$c000,$4000,0)
    ' Definimos los sprites
    InitSprites(4,$c000)
        
    ' Cargamos los tiles (16x16x20)
    LoadSD("Tiles.ntil",$c000,$1500,0) 
    ' Cargamos la definición del mapa (16x12)
    LoadSD("Mapa.nmap",$d500,192,0)
END SUB


' - Demo de la Layer 2, 256x192 a 256 colores -------------
SUB Layer2_256x192()
    DIM x, y as UInteger
    DIM t AS UByte
    
    ' Mostramos la Layer 2
    ShowLayer2(1)
    
    ' Imprimimos el nombre de la capa en la ULA
    PRINT AT 23,0;"Layer 2: 256x192, 256 colores";

    ' Rellenamos la pantalla con el color 2 (azul)
    CLS256(2)
    ' Dibujaremos 16 tiles de ancho
    FOR x = 0 TO 15
        ' Por 12 tiles de alto
        FOR y = 0 TO 11
            ' Leemos el vañpr del tile en el mapa
            t = PEEK($d500+(y*16)+x)
            ' Dibujamos el tile "t" en "x","y"
            DoTile(x,y,t)
        NEXT y
    NEXT x
END SUB


' - Demo de Sprites ---------------------------------------
SUB DemoSprite()
    DIM scrX AS UByte
    DIM paso, n AS UByte
    
    ' Bucle infinito
    DO
        ' Hacemos 1 pausa para sincronizar con el barrido
        waitretrace
        ' Actualizamos la posición y frame del sprite 0
        UpdateSprite(120,120,0,paso,0,0)
        
        ' Hacemos un scroll sobre la coordenada X            
        ScrollLayer(scrX,0)
        ' Incrementamos la coordenada del scroll X en 2
        scrX = scrX + 2
            
        ' El frame (paso) va de 0 a 3
        IF paso = 3 THEN
            paso = 0
        ELSE
            paso = paso + 1
        END IF
    LOOP
END SUB
