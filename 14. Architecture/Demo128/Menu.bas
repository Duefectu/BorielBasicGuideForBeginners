' - Demo128 -----------------------------------------------
' https://tinyurl.com/55jh39x5
' - Módulo Menú -------------------------------------------
' Parametro1: No usado
' Parametro2: No usado


Menu()
STOP


' - Includes ----------------------------------------------
#INCLUDE <keys.bas>
#INCLUDE "Vars.bas"


' - Menú del juego ----------------------------------------
SUB Menu()
    ' Si no hay un tipo de control definido...
    IF TipoControl = CONTROL_NODEFINIDO THEN
        ' Inicializamos los controles
        Inicializar()
    END IF
    
    ' Borramos la pantalla
    BORDER 7
    PAPER 7
    INK 0
    CLS
    
    ' Esperamos a que no se pulse ninguna tecla
    WHILE INKEY$ <> ""
    WEND
    
    DO
        ' Mostramos el menú
        PRINT AT 5,11;"Demo 128"
        PRINT AT 7,8;"Menu del juego"
        
        ' Imprime las opciones de control
        ImprimirOpcion(10,10,"1. Teclado",CONTROL_TECLADO)
        ImprimirOpcion(11,10,"2. Kempston",CONTROL_KEMPSTON)
        ImprimirOpcion(12,10,"3. Sinclair",CONTROL_SINCLAIR)
        ImprimirOpcion(13,10,"4. Cursor",CONTROL_CURSOR)
        ' Imprime el resto de opciones
        PRINT AT 14,10;"5. Redefinir teclas"
        PRINT AT 16,10;"0. Empezar partida"
        ' Imprime la puntuacion máxima
        PRINT AT 20,5;"Puntuacion maxima: ";Record;
    
        ' Espera hasta que se pulse una tecla
        WHILE INKEY$ = ""
        WEND
        
        ' Reaccionar según la tecla pulsada
        IF INKEY$="1" THEN
            TipoControl = CONTROL_TECLADO
        ELSEIF INKEY$="2" THEN
            TipoControl = CONTROL_KEMPSTON
        ELSEIF INKEY$="3" THEN
            TipoControl = CONTROL_SINCLAIR
        ELSEIF INKEY$="4" THEN
            TipoControl = CONTROL_CURSOR
        ELSEIF INKEY$="5" THEN
            ' TODO: Redefinir teclas
        ELSEIF INKEY$="0" THEN
            ' Empezar partida
            ' Modulo a cargar: Juego
            ModuloAEjecutar = MODULO_JUEGO
            ' Parámetros a 0 para indicar nueva partida
            Parametro1 = 0
            Parametro2 = 0
            ' Salimos del módulo
            RETURN
        END IF
    LOOP
END SUB


' - Inicializa el sistema ---------------------------------
SUB Inicializar()
    ' Tipo de control por defecto
    TipoControl = CONTROL_TECLADO
    ' Teclas por defecto: OPQA ESPACIO
    TeclaIzquierda = KEYO
    TeclaDerecha = KEYP
    TeclaArriba = KEYQ
    TeclaAbajo = KEYA
    TeclaDisparo = KEYSPACE
    ' Otros valores
    Record = 10
END SUB


' - Imprime una opción resaltándola si está seleccionada --
SUB ImprimirOpcion(y AS UByte, x AS UByte, txt AS String, _
    tipo AS UByte)
    
    ' Si la opción es la actual, imprimimos en rojo
    IF TipoControl = tipo THEN
        INK 2
    ' Si no lo es se imprime en negro
    ELSE
        INK 0
    END IF
    ' Imprime la opción
    PRINT AT y,x;txt;
END SUB
