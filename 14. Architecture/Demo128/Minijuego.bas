' - Demo128 -----------------------------------------------
' https://tinyurl.com/55jh39x5
' - Módulo de Minijuego -----------------------------------
' Parametro1: Código del minijuego seleccionado
' Parametro2: No usado

MiniJuegos()
STOP

' - Includes ----------------------------------------------
#INCLUDE "Vars.bas"


' - Bucle principal del juego -----------------------------
SUB MiniJuegos()   
    ' Borramos la pantalla
    BORDER 2
    PAPER 0
    INK 5
    CLS
    
    ' Esperamos a que no se pulse ninguna tecla
    WHILE INKEY$ <> ""
    WEND

    ' Dibujamos el texto fijo
    PRINT AT 0,1;"Modulo de Minijuegos"
    IF TipoControl = CONTROL_TECLADO
        PRINT AT 1,1;"Control: Teclado";
    ELSEIF TipoControl = CONTROL_KEMPSTON
        PRINT AT 1,1;"Control: Kempston";
    ELSEIF TipoControl = CONTROL_SINCLAIR
        PRINT AT 1,1;"Control: Sinclair";
    ELSEIF TipoControl = CONTROL_CURSOR
        PRINT AT 1,1;"Control: Cursor";
    END IF
    PRINT AT 2,1;"Minijuego: ";Parametro1;
    
    ' Bucle infinito
    DO
        ' Imprimimos los marcadores
        PRINT AT 3,1;"Vidas: ";Vidas;
        PRINT AT 4,1;"Puntos: ";Puntos;
        PRINT AT 5,1;"Energia: ";Energia;
    
        ' Imprimimos las opciones
        PRINT AT 6,5;"G. Minijuego ganado";
        PRINT AT 7,5;"P. Minijuego perdido";
        
        ' Esperamos a que se pulse una tecla
        WHILE INKEY$ = ""
        WEND
                
        IF INKEY$ = "g" THEN
            'G para ganar el minijuego
            Puntos = Puntos + 10
            ModuloAEjecutar = MODULO_JUEGO
            Parametro1 = 1
            Parametro2 = 0
            RETURN
        ELSEIF INKEY$ = "p" THEN
            ' P para perder el minijuego
            ModuloAEjecutar = MODULO_JUEGO
            Parametro1 = 2
            Parametro2 = 0
            RETURN        
        END IF
    LOOP
END SUB
