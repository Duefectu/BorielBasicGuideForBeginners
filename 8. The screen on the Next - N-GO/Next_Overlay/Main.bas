' - Next Overlay Demo -------------------------------------
' https://tinyurl.com/4fw926yr

Main()
DO
LOOP


' - Definiciones ------------------------------------------
' Los usaremos para identificar los subindices de la matriz
' sprites
#DEFINE SPRITE_X 0
#DEFINE SPRITE_Y 1
#DEFINE SPRITE_ID 2
#DEFINE SPRITE_ANCHO 3
#DEFINE SPRITE_ALTO 4
#DEFINE SPRITE_VEL 5


' - Includes ----------------------------------------------
#INCLUDE <retrace.bas>
#INCLUDE "nextlib8.bas"


' - Subrutina principal -----------------------------------
SUB Main()
    ' Inicializa el sistema
    Inicializar()
    ' Lanza la demo
    Demo()
END SUB


' - Inicializa el sistema ---------------------------------
SUB Inicializar()
    ' Borde amarillo, papel transparente y tinta amarilla
    BORDER 0
    PAPER 0
    INK 7
    CLS
    
    ' Ponemos el reloj a 28Mhz
    NextReg($07,3)
    ' Establecemos prioridades: Sprites -> Layer2 ->  ULA
    NextReg($15,%00000001)
    
    ' Cargamos la pantalla de la ULA
    LoadSD("Amanecer.scr",$4000,$1b00,0)
    
    ' Cargamos la pantalla de la Layer 2
    LoadBMPOld("Montanas.bmp")

    ' Mostramos la Layer 2
    ' Es importante activar la Layer2 después de cargar la
    ' pantalla para que se vea correctamente el bitmap
    ShowLayer2(1)
       
    ' Cargamos los sprites
    LoadSD("Sprites.nspr",$c000,$4000,0)
    ' Definimos los sprites
    InitSprites(36,$c000)
END SUB


' - Demo --------------------------------------------------
SUB Demo()
    ' Puntero de scroll de la Layer 2
    DIM xLayer2 AS UInteger = 0
    ' Vamos a definir 20 sprites
    DIM sprites(19,5) AS UInteger
    ' Id de cada uno de los patterns de los sprites
    DIM dirSprite(7) AS UByte => { 0,4,6,8,12,18,24,30 }
    ' Define el tamaño de los 8 sprites que usaremos
    DIM tamanos(7,1) AS UBYTE => { _
        { 4, 1 }, { 2, 1 }, {2, 1}, {4, 1}, _
        { 2, 3 }, { 2, 3 }, {2, 3}, {2, 3} _
    }
    ' Variables temnporales para la lógica 
    DIM n, id, ancho, alto, nAncho, nAlto, y, spr AS UByte
    DIM x, v AS UInteger

    ' Inicializamos la semilla del RND
    RANDOMIZE 0
    
    ' Creamos 5 Nubes
    FOR n = 0 TO 5
        sprites(n,SPRITE_X) = RND * 320
        sprites(n,SPRITE_Y) = (RND * 60) + 32
        id = RND * 4        
        sprites(n,SPRITE_ID) = dirSprite(id)
        sprites(n,SPRITE_ANCHO) = tamanos(id,0)
        sprites(n,SPRITE_ALTO) = tamanos(id,1)
        sprites(n,SPRITE_VEL) = RND * 2
     NEXT n
     ' Creamos 10 árboles lentos
     FOR n = 5 TO 15
        sprites(n,SPRITE_X) = RND * 320
        sprites(n,SPRITE_Y) = 135
        id = (RND * 4) + 4       
        sprites(n,SPRITE_ID) = dirSprite(id)
        sprites(n,SPRITE_ANCHO) = tamanos(id,0)
        sprites(n,SPRITE_ALTO) = tamanos(id,1)
        sprites(n,SPRITE_VEL) = 3
     NEXT n 
     ' Creamos 3 árboles más rápidos
     FOR n = 15 TO 18
        sprites(n,SPRITE_X) = RND * 320
        sprites(n,SPRITE_Y) = 145
        id = (RND * 4) + 4       
        sprites(n,SPRITE_ID) = dirSprite(id)
        sprites(n,SPRITE_ANCHO) = tamanos(id,0)
        sprites(n,SPRITE_ALTO) = tamanos(id,1)
        sprites(n,SPRITE_VEL) = 4
     NEXT n 
     ' Creamos 2 árboles aún más rápidos
     FOR n = 18 TO 20
        sprites(n,SPRITE_X) = RND * 320
        sprites(n,SPRITE_Y) = 150
        id = (RND * 4) + 4       
        sprites(n,SPRITE_ID) = dirSprite(id)
        sprites(n,SPRITE_ANCHO) = tamanos(id,0)
        sprites(n,SPRITE_ALTO) = tamanos(id,1)
        sprites(n,SPRITE_VEL) = 5
     NEXT n
    
    ' Bucle infinito
    DO
        ' Sincronizamos con el barrido de pantalla
        waitretrace
        ' Scroll de la Layer 2
        ScrollLayer(xLayer2,0)
        xLayer2 = xLayer2 + 2
        
        ' Empezamos a actualizar los 20 sprites
        spr = 0
        FOR n = 0 TO 20
            ' Copiamos los datos del sprite a variables
            ' locales para acelerar el procesado
            y = sprites(n,SPRITE_Y)
            id = sprites(n,SPRITE_ID)
            ancho = sprites(n,SPRITE_ANCHO)-1
            alto = sprites(n,SPRITE_ALTO)-1
            ' Bucle de alto del sprite
            FOR nAlto = 0 TO alto
                ' Inicializamos la coordenada x
                x = sprites(n,SPRITE_X)
                ' Bucle del ancho del sprite
                FOR nAncho = 0 TO ancho
                    ' Actualizamos la posición del sprite
                    UpdateSprite(x,y,spr,id,0,0)
                    ' Incrementamos el frame del frame
                    id = id + 1
                    ' Incrementamos el id de del sprite
                    spr = spr + 1
                    ' Incrementamos x en 16
                    x = x + 16
                NEXT nAncho
                ' Incrementamos y en 16
                y = y + 16
            NEXT nAlto 
            
            ' Detectamos si el sprite se pierde por la
            ' izquierda de la pantallá
            v = sprites(n,SPRITE_VEL)
            x = sprites(n,SPRITE_X)        
            IF v > x THEN
                ' Si se sale, lo colocamos a la derecha
                sprites(n,SPRITE_X) = 320
            ELSE
                ' Si no se sale, lo movemos a la izquierda
                sprites(n,SPRITE_X) = x - v
            END IF
        NEXT n
    LOOP
END SUB
