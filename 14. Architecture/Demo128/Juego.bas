' - Demo128 -----------------------------------------------
' https://tinyurl.com/55jh39x5
' - Módulo de juego ---------------------------------------
' Parametro1: 0 = Nueva partida, 1 = Continuar, 2 = Muerto
' Parametro2: No usado

Juego()
STOP

' - Includes ----------------------------------------------
#INCLUDE "Vars.bas"


' - Bucle principal del juego -----------------------------
SUB Juego()
    ' Si el Parametro1 es 0 (Nueva partida)... 
    IF Parametro1 = 0 THEN
        ' Inicializamos el juego
        InicializarJuego()
    ' Si el Parametro1 es 2 (Muerto)...
    ELSEIF Parametro1 = 2 THEN
        ' Restamos una vida
        Vidas = Vidas - 1
    END IF
    
    ' Borramos la pantalla
    BORDER 1
    PAPER 0
    INK 6
    CLS
    
   ' Esperamos a que no se pulse ninguna tecla
    WHILE INKEY$ <> ""
    WEND

    ' Dibujamos el texto fijo
    PRINT AT 0,1;"Modulo de juego";
    IF TipoControl = CONTROL_TECLADO
        PRINT AT 1,1;"Control: Teclado";
    ELSEIF TipoControl = CONTROL_KEMPSTON
        PRINT AT 1,1;"Control: Kempston";
    ELSEIF TipoControl = CONTROL_SINCLAIR
        PRINT AT 1,1;"Control: Sinclair";
    ELSEIF TipoControl = CONTROL_CURSOR
        PRINT AT 1,1;"Control: Cursor";
    END IF
    
    ' Mientras nos queden vidas
    WHILE Vidas > 0
        ' Imprimimos los marcadores
        PRINT AT 2,1;"Vidas: ";Vidas;
        PRINT AT 3,1;"Puntos: ";Puntos;
        PRINT AT 4,1;"Energia: ";Energia;
    
        ' Imprimimos las opciones
        PRINT AT 6,5;"P. Sumar puntos";
        PRINT AT 7,5;"M. Minijuego";
        PRINT AT 8,5;"V. Quitar una vida";
        
        ' Esperamos a que se pulse una tecla
        WHILE INKEY$ = ""
        WEND
                
        IF INKEY$ = "p" THEN
            ' P para incrementar puntos
            Puntos = Puntos + 1
        ELSEIF INKEY$ = "m" THEN
            ' M para cargar un minijuego
            ModuloAEjecutar = MODULO_MINIJUEGOS
            ' Minijuego al azar
            Parametro1 = RND * 10
            Parametro2 = 0
            RETURN
        ELSEIF INKEY$ = "v" THEN
            ' V para perder una vida
            Vidas = Vidas - 1
            ' Esperamos a que se suelte la tecla
            WHILE INKEY$ <> ""
            WEND
        END IF
    WEND
    
    ' No nos quedan vidas, cargamos GameOver
    ModuloAEjecutar = MODULO_GAMEOVER
    Parametro1 = 0
    Parametro2 = 0
END SUB


' - Inicializa el juego -----------------------------------
SUB InicializarJuego()
    DIM n AS UByte
    
    ' Valores por defecto al iniciar la partida
    Vidas = 3
    Puntos = 0
    Nivel = 0
    Energia = 10
    
    ' Ningún objeto en la mochila
    FOR n = 0 TO 8
        ObjetosMochila(n) = 0
    NEXT n
    
    ' Generador de números aleatorios
    RANDOMIZE 0
END SUB
