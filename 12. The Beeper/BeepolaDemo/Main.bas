' - BeepolaDemo -------------------------------------------
' https://tinyurl.com/y75rsevt

' Llamamos a la subrutina principal
Main()
STOP

' - Includes ----------------------------------------------
#INCLUDE <retrace.bas>      ' Librería para waitretrace
#INCLUDE <Keys.bas>         ' Librería para MultiKeys
#INCLUDE "Triptone.bas"     ' Motor Triptone
#INCLUDE "TheMusicBox.bas"  ' Motor The Music Box


' - Subrutina principal -----------------------------------
SUB Main()
    ' Llamamos al módulo de la Intro
    Intro()
    ' Después de la intro, va el menú del juego
    Menu()
    
    CLS
    DO
    LOOP
END SUB


' - Intro de la demo --------------------------------------
SUB Intro()
    ' Ajustamos los colores de la pantalla
    BORDER 0
    PAPER 0
    INK 6
    CLS ' Este borrado es opcional
    
    ' Imprimimos algo
    PRINT AT 5,2;"ESTA ES LA MUSICA DE LA INTRO";
    PRINT AT 15,2;"Pulsa una tecla para seguir...";
    
    ' Hacemos que suene la canción
    Triptone_Play()
END SUB


' - Menú de la demo ---------------------------------------
SUB Menu()
    DIM contador AS UByte
    
    ' Inicializamos el motor The Music Box
    TheMusicBox_Init()
    
    ' Imprimimos el menú
    CLS
    INK 6    
    PRINT AT 5,10;"MENU PRINCIPAL";
    PRINT AT 6,10;"--------------";
    INK 5
    PRINT AT 10,11;"1. TECLADO";
    PRINT AT 12,11;"2. JOYSTICK";
    PRINT AT 14,11;"0. JUGAR";
    
    ' Bucle infinito
    DO  
        ' Imprime un contador en la esquina superior izquierda
        print at 0,0;contador;"  ";
        ' Incrementa el contador
        contador = contador + 1

        ' Comprobamos el teclado
        IF MultiKeys(KEY0) THEN
            ' Opción Jugar
            RETURN
        ELSEIF MultiKeys(KEY1) THEN
            ' Teclado
            RETURN
        ELSEIF MultiKeys(KEY2) THEN
            ' Joystick
            RETURN
        END IF
            
        ' Espera hasta el próximo barrido de pantalla
        waitretrace
        ' Toca la siguiente nota
        TheMusicBox_PlayNote()
    LOOP
END SUB
