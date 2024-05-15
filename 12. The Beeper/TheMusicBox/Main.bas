' - TheMusicBox -------------------------------------------
' https://tinyurl.com/2t4f2cz5

' Invocamos la subrutina principal
Main()
STOP


' - Includes ----------------------------------------------
#INCLUDE "TheMusicBox.bas"
#INCLUDE "Canciones.bas"


' - Definiciones ------------------------------------------
#DEFINE MAX_CANCIONES 2


' - Variables ---------------------------------------------
' Nombres de las canciones
DIM Canciones_Nombres(MAX_CANCIONES) AS String
' Direcciones de las canciones
DIM Canciones_Direcciones(MAX_CANCIONES) AS UInteger => { _
    @Cancion_Amelie, _
    @Cancion_Arp_chaos, _
    @Cancion_InTheHallOfTheMountainKing }


' - Subrutina principal
SUB Main()
    ' Canción actual, empezamos por la 0
    DIM cancion AS UByte = 0
    ' Para la tecla que se ha pulsado
    DIM k AS String
    ' Para convertir la tecla a número
    DIM c AS UByte
    ' Coordenada X e incremento de la pelotita 
    DIM x, i AS Byte
    
    ' Inicializa el sistema
    Inicializar()

    ' La pelota empieza en la columna 5
    x = 5
    ' Y va hacia la derecha
    i = 1
    
    ' Bucle infinito
    DO
        ' Borramos la pantalla
        CLS
        ' Imprimimos la canción actual
        PRINT AT 5,0; INK 6;"Sonando:";
        PRINT AT 6,0; INK 7;Canciones_Nombres(cancion);
        ' Hacemos sonar la canción actual
        Beepola_Play(Canciones_Direcciones(cancion))

        ' Mostramos el listado de canciones
        PRINT AT 9,0;INK 5;"Seleccione la cancion";
        FOR n = 0 TO MAX_CANCIONES
            PRINT AT 10+n,0; INK n+2;n;"-";Canciones_Nombres(n);
        NEXT n
        
        ' Bucle de selección
        DO
            ' Imprimimos la pelotita
            PRINT AT 20,x;" O ";
            ' Comprobamos si se va a salir
            IF x > 0 AND x < 29 THEN
                ' Si no se sale, movemos
                x = x + i
            ELSE
                ' Si se sale, cambiamos la dirección
                i = i * -1
                x = x + i
            END IF

            ' Leemos el teclado
            k = INKEY$
            IF k <> "" THEN
                ' Convertimos la tecla a número
                c = val(k)
                ' Si la tecla está entre 0 y el máximo
                ' de canciones
                IF c >= 0 AND c <= MAX_CANCIONES THEN
                    ' Detenemos la reproducción actual
                    Beepola_Stop()
                    ' Ajustamos la nueva canción
                    cancion = c
                    ' Salimos del bucle de selección
                    EXIT DO
                END IF
            END IF
        LOOP
    LOOP
END SUB


SUB Inicializar()
    BORDER 0
    PAPER 0
    INK 6
    CLS
    
    ' Nombres de las canciones
    Canciones_Nombres(0) = "Amelie"
    Canciones_Nombres(1) = "Arp chaos"
    Canciones_Nombres(2) = "In the Hall of the Mountain King"
    
    ' Inicializa el motor The Music Box con interrupciones
    Beepola_Init(0,1)
END SUB    
