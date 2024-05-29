' - VortexTrackerDemo -------------------------------------
' https://tinyurl.com/mrx4whj9

' Ejecutamos la subrutina principal
Main()
Stop


' - Includes ----------------------------------------------
#INCLUDE <Retrace.bas>
#INCLUDE "VortexTracker.bas"
#INCLUDE "IM2.bas"


' - Variables ---------------------------------------------
' Caché de coordenadas para la explosión
DIM cacheX(96) AS UByte
DIM cacheY(96) AS UByte
' Número de coordenadas que se han cacheado
DIM max AS UByte


' - Subrutina principal -----------------------------------
SUB Main()
    ' Inicializar el sistema
    Inicializar()
       
    DO
        ' Lanzar fuegos artificiales como si no hubiese
        ' un mañana
        FireWork()
    LOOP
END SUB


' - Inicializa el sistema ---------------------------------
SUB Inicializar()   
    ' Carga el player
    LOAD "" CODE
    ' carga la canción
    LOAD "" CODE
    
    BORDER 0
    PAPER 0
    INK 6
    BRIGHT 1
    
    ' Inicializamos la música
    VortexTracker_Inicializar(1)

    CLS

    ' Cachear explosión
    PRINT AT 0,0;"Contando estrellas..";    
    ' Se calculan los puntos que dibujarán la explosión.
    ' Todas las explosiones son iguales, así que basta
    ' calcularlo una vez, y así aceleramos.
    ' Contador
    DIM c AS UByte = 0
    ' Módulos y ángulos de la explosión    
    DIM a, m AS Fixed
    ' Coordenadas en pantalla
    DIM x, y AS Fixed
    ' Módulo de 0 a 3.14 radianes
    FOR a = 0 TO 3.14 STEP .2
        ' Ángulo de .4 a 6.14 radianes
        FOR m = .4 TO 6.14 STEP 1.2
            ' Calculamos la coordenada X e Y del punto
            x = 128 + (COS(m)*a*10)
            y = 96 + (SIN(m)*a*10) + (SIN(a) * 10)
            ' Guardamos el punto en el caché
            cacheX(c)=x
            cacheY(c)=y
            c=c+1
            PRINT ".";
        NEXT m
    NEXT a
    max = c - 1
END SUB


' - Lanza un fuego artificial -----------------------------
SUB FireWork()
    ' Coordenada X desde donde se lanza
    DIM xi AS Integer
    ' Coordenadas de trabajo
    DIM x, y, lx, ly AS Integer
    ' Color del fuego
    DIM i AS UByte
    ' Contador para la explosión
    DIM c AS UByte
    ' Ángulo y módulo 
    DIM a, m AS Fixed    
    
    ' Crea el fuego artificial
    ' Coordenada X inicial
    xi = (RND * 128) + 50
    ' Módulo (altura) del fuego
    m = (RND * 100) + 64
    ' Color del fuego
    i = (RND * 7)+1
    ' Reseteamos el resto
    a = 0
    lx = 0
    ly = 0
    
    ' Lanzamos el cohete
    CLS
    INK i
    ' Dibuja un arco ascendente borrando la estela
    FOR a = 0 TO 1.57 STEP .05
        x = xi+(a*20)
        y = SIN(a) * m
        PLOT INK 0;lx,ly
        PLOT INK i;x,y     
        lx = x
        ly = y
    NEXT a
    
    ' Explota utilizando los datos cacheados
    FOR c=0 TO max
        ' Dibuja los puntos
        PLOT lx-128+cacheX(c),ly-96+cacheY(c)
        ' Pausa de 20ms
        waitretrace
    NEXT c
    CLS
END SUB
