' - Demo128 -----------------------------------------------
' https://tinyurl.com/55jh39x5
' - Módulo GameOver ---------------------------------------
' Parametro1: No usado
' Parametro2: No usado


GameOver()
STOP


' - Includes ----------------------------------------------
#INCLUDE "Vars.bas"


' - Game Over ---------------------------------------------
SUB GameOver()
    ' Borramos la pantalla
    BORDER 3
    PAPER 0
    INK 2
    CLS
    
    ' Esperamos a que no se pulse ninguna tecla
    WHILE INKEY$ <> ""
    WEND
    
    ' Imprimimos el texto y la puntuación
    PRINT AT 5,10;"GAME OVER!"
    PRINT AT 10,5;"Puntuacion: ";Puntos;
    
    ' Si no se ha superado el record...
    IF Record > Puntos THEN
        ' Imprimimos el record
        PRINT AT 15,5;"Record: ";Record;
    ' Si se ha superado el record...
    ELSE
        ' Actualizamos el record
        Record = Puntos
        ' Informamos de la gesta al jugador
        PRINT AT 15,5;"Nuevo record!!!";
    END IF

    ' Esperamos a que se pulse una tecla
    WHILE INKEY$ = ""
    WEND
    
    ' Regresamos al menú del juego
    ModuloAEjecutar = MODULO_MENU
    Parametro1 = 0
    Parametro2 = 0
END SUB
