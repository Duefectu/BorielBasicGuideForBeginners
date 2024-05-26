' - Beepola In-Game DEMO ----------------------------------
' https://tinyurl.com/mrknudc3

' Saltamos a la rutina principal
Main()
STOP


' - Includes ----------------------------------------------
' Librerías de Boriel
#INCLUDE <keys.bas>
#INCLUDE <retrace.bas>
#INCLUDE <putchars.bas>

' Módulos del programa
#INCLUDE "Musica.bas"
#INCLUDE "StreetsOfRain.bas"
#INCLUDE "Navecilla.spr.bas"


' - Definiciones ------------------------------------------
#DEFINE ESTRELLAS_MAX 6
#DEFINE ESTRELLA_X 0
#DEFINE ESTRELLA_Y 1
#DEFINE ESTRELLA_TIPO 2


' - Subrutina principal -----------------------------------
SUB Main()    
    ' Inicializamos todo
    Inicializar()
    ' Saltamos directamente a la demo
    Demo()
END SUB


' - Inicializa el programa --------------------------------
SUB Inicializar()
    DIM n AS UByte
    
    ' Todo negro con tinta blanca y brilli brilli
    BORDER 0
    PAPER 0
    INK 7
    BRIGHT 1
    CLS
    
    ' Inicializamos la música
    Music_Init()
    ' Empezamos a reproducir la música
    Music_Play()
    
    ' Inicializamos los números aleatorios
    RANDOMIZE 0
END SUB


' - Subrutina principal de la demostración ----------------
SUB Demo()
    ' Coordenadas x, y, e imagen de la nave
    DIM x, y, f AS UByte
    ' Copia de las coordenadas de la nave
    DIM x2, y2, n AS UByte
    ' Definimos un array de estrellas
    DIM Estrellas(ESTRELLAS_MAX,2) AS UByte
    ' Variables de trabajo para Estrellas
    DIM xe, ye, te AS UByte

    ' Colocamos la nave en el centro y un poco a la izquierda
    x = 5
    y = 10
    f = 0
    
    ' Creamos las estrellas
    FOR n = 0 TO ESTRELLAS_MAX-2
        Estrellas(n,ESTRELLA_X) = RND * 31
        Estrellas(n,ESTRELLA_Y) = RND * 23
        Estrellas(n,ESTRELLA_TIPO) = (RND * 3)+1
    NEXT n
    
    ' Imprimimos la nave por primera vez
    putChars(x,y,2,2,@Navecilla_Nave(f,0))
    PRINT AT 23,0;"Pulsa M para silenciar/sonar";
    
    ' Bucle infinito
    DO        
        ' Sacamos una copia de x e y en x2 e y2
        x2 = x
        y2 = y        
        
        ' Control del teclado
        IF MultiKeys(KEYQ) THEN     ' Tecla arriba
            IF y2 > 0 THEN
                ' Si no está arriba, la movemos
                y2 = y2 - 1
                ' Imagen de ladeo hacia arriba
                f = 1
            END IF
        ELSEIF MultiKeys(KEYA) THEN ' Tecla abajo
            IF y2 < 22 THEN
                ' Si no está abajo, la movemos
                y2 = y2 + 1
                ' Imagen de ladeo hacia abajo
                f = 2
            END IF
        ELSE IF f <> 0  ' Si nos estamos moviendo
            ' Imagen de la nave estabilizada
            f = 0
        END IF

        IF MultiKeys(KEYO) THEN     ' Izquierda
            IF x2 > 0 THEN
                ' Si no hemos llegado al borde nos movemos
                x2 = x2 - 1
            END IF
        ELSEIF MultiKeys(KEYP) THEN ' Derecha
            IF x2 < 29 THEN
                ' Si no hemos llegado al borde nos movemos
                x2 = x2 + 1
            END IF
        END IF

        IF Multikeys(KEYM) THEN     ' Tecla M        
            IF Music_Playing = 1 THEN
                ' Si está sonando lo paramos
                Music_Stop()
                ' Esperar a que soltemos la tecla M
                WHILE INKEY$<>"":WEND
            ELSE
                ' Si está parado lo arranzamos
                Music_Play()
                ' Esperar a que soltemos la tecla M
                WHILE INKEY$<>"":WEND
            END IF
        END IF       

        ' Hacemos una pausa para evitar el parpadeo
        waitretrace
        
        ' Movemos las estrellas
        FOR n = 0 TO ESTRELLAS_MAX
            ' Pasamos los valores de la estrella a local
            xe=Estrellas(n,ESTRELLA_X)
            ye=Estrellas(n,ESTRELLA_Y)
            te=Estrellas(n,ESTRELLA_TIPO)
            ' Borramos la estrella
            putChars(xe,ye,1,1,@Navecilla_Estrella(1,0))
            ' Se va a salir la estrella por la izquierda...
            IF xe > te THEN
                ' Si no se sale, restamos el tipo a x
                xe = xe - te
                Estrellas(n,ESTRELLA_X) = xe
                ' Imprimimos la estrella
                putChars(xe,ye,1,1,@Navecilla_Estrella(0,0))
            ' Si se va a salir
            ELSE
                ' Colocamos la estrella a la derecha
                Estrellas(n,ESTRELLA_X) = 31
                ' Resto de datos aleatorios
                Estrellas(n,ESTRELLA_Y) = RND * 23
                Estrellas(n,ESTRELLA_TIPO) = (RND * 3)+1
            END IF
        NEXT n
        
        ' Borramos la nave
        putChars(x,y,2,2,@Navecilla_Nave(3,0))
        ' La imprimimos en la nueva posición
        putChars(x2,y2,2,2,@Navecilla_Nave(f,0))
        ' Volcamos x2 e y2 en x e y
        x = x2
        y = y2
    LOOP
END SUB
