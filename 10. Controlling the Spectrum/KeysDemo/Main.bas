' - KeysDemo ----------------------------------------------
' https://tinyurl.com/2s3npcpf

#INCLUDE <Keys.bas>

' Declaramos dos funciones
DECLARE FUNCTION Menu AS UByte
DECLARE FUNCTION LeerTecla AS UInteger


' Guardaremos los códigos de las teclas en un array
DIM Teclas(4) AS UInteger => _
    { KEYO, KEYP, KEYQ, KEYA, KEYSPACE }
' Y el nombre del comando para cada tecla en otro
DIM TeclasS(4) AS String
' Tipo de control, 1=Teclado, 2=KEMPSTON,
'   3=SINCLAIR 1, 4=SINCLAIR 2, 5=CURSOR 
DIM TipoControl AS UByte = 1

' Estos defines nos ayudan a no liarnos con los índices
#DEFINE IZQUIERDA 0
#DEFINE DERECHA 1
#DEFINE ARRIBA 2
#DEFINE ABAJO 3
#DEFINE DISPARO 4


' Llamamos a la subrutina Main para empezar
Main()


' - Subrutina principal del programa ----------------------
SUB Main()
    DIM opcion AS UByte
    
    ' Inicializamos el sistema
    Inicializar()

    ' Bucle infinito
    DO    
        CLS
        ' Imprimimos el menú y recogemos la opción seleccionada
        opcion = Menu()
        
        IF opcion = 1 THEN
            ' La opción 1 es para probar
            Probar()
        ELSE IF opcion = 2 THEN
            ' La opción 2 es para redefinir
            RedefinirTeclas()  
            ' Si redefinimos pasamos a teclado
            TipoControl = 1
        ELSE IF opcion = 3 THEN
            ' La opción 2 es teclado
            TipoControl = 1
        ELSE IF opcion = 4 THEN
            ' La opción 4 es para KEMPSTON
            TipoControl = 2
        ELSE IF opcion = 5 THEN
            ' La opción 5 es para SINCLAIR 1
            TeclasSINCLAIR1()
            TipoControl = 3
        ELSE IF opcion = 6 THEN
            ' La opción 6 es para SINCLAIR 2
            TeclasSINCLAIR2()
            TipoControl = 4
        ELSE IF opcion = 7 THEN
            ' La opción 7 es para CURSOR
            TeclasCURSOR()
            TipoControl = 5
        END IF
    LOOP
END SUB


' - Inicializa el sistema ---------------------------------
SUB Inicializar()
    ' Establecemos los colores por defecto
    BORDER 0
    PAPER 0
    INK 6
    CLS

    ' Definimos los textos de las teclas
    TeclasS(IZQUIERDA) = "Izquierda"
    TeclasS(DERECHA)   = " Derecha "
    TeclasS(ARRIBA)    = " Arriba  "
    TeclasS(ABAJO)     = "  Abajo  "
    TeclasS(DISPARO)   = " Disparo "
END SUB


' - Muestra el menú principal y devuelve la opción seleccionada
' Devuelve:
'   UByte: Opción seleccionada: 1=Redefinir, 2=Probar
FUNCTION Menu() AS UByte    
    DIM a AS UByte
    
    CLS
    ' Imprimimos las etiquetas
    INK 5
    PRINT AT  2,5;"    Menu principal"
    PRINT AT 18,5;"Selecciona una opcion"

    ' Imprimimos las opciones fijas
    INK 6
    PRINT AT 4,5;" 1. Probar"
    PRINT AT 6,5;" 2. Redefinir teclas"
    ' Si usamos teclado, marcamos la opción en verde
    IF TipoControl = 1 THEN
        INK 4
    END IF
    PRINT AT 8,5;" 3. Teclado"
    INK 6
    ' Si usamos KEMPSTON, marcamos la opción en verde
    IF TipoControl = 2 THEN
        INK 4
    END IF
    PRINT AT 10,5;" 4. Joystick KEMPSTON"
    INK 6
    ' Si usamos SINCLAIR 1, marcamos la opción en verde
    IF TipoControl = 3 THEN
        INK 4
    END IF
    PRINT AT 12,5;" 5. Joystick SINCLAIR 1"
    INK 6
    ' Si usamos SINCLAIR 2, marcamos la opción en verde
    IF TipoControl = 4 THEN
        INK 4
    END IF
    PRINT AT 14,5;" 6. Joystick SINCLAIR 2"
    INK 6
    ' Si usamos CURSOR, marcamos la opción en verde
    IF TipoControl = 5 THEN
        INK 4
    END IF
    PRINT AT 16,5;" 7. Joystick CURSOR"
    INK 6
    
    ' Damos vueltas hasta que se selecciona algo correcto
    DO
        IF INKEY$ <> "" THEN
            ' Convertimos la tecla en un número
            a = VAL(INKEY$)
            IF a <> 0 THEN
                ' Si es un número, lo devolvemos
                RETURN a
            END IF
        END IF
    LOOP
END FUNCTION


' - Opción "Redefinir teclas" -----------------------------
SUB RedefinirTeclas()
    DIM n AS UByte
    DIM k AS UInteger
    
    CLS
    ' Imprimimos la cabecera
    INK 5
    PRINT AT 10,5;"Pulsa una tecla para:";
    INK 6
    
    ' Para cada una de las 5 teclas
    FOR n=0 TO 4
        ' Imprimimos el nombre de la tecla
        PRINT AT 14,10;TeclasS(n);
        ' Leemos y guardamos el código de la tecla
        Teclas(n) = LeerTecla()
    NEXT n
END SUB


' - Devuelve el código de la tecla pulsada -----------------
' Devuelve:
'   UInteger: Código de la tecla pulsada
FUNCTION LeerTecla() AS UInteger
    ' Declaramos k con el valor 0 por defecto
    DIM k AS UInteger = 0
    
    ' Esperamos hasta que no se pulse nada
    WHILE GetKeyScanCode() <> 0
    WEND
    
    ' Repetimos mientras no se haya pulsado una tecla
    WHILE k = 0
        ' Leemos la tecla pulsada
        k = GetKeyScanCode()        
    WEND
    
    ' Devolvemos el código de la tecla pulsada
    RETURN k
END FUNCTION


' - Define las teclas para Joystick SINCLAIR 1 ------------
SUB TeclasSINCLAIR1()
    Teclas(IZQUIERDA)=KEY1
    Teclas(DERECHA)=KEY2
    Teclas(ABAJO)=KEY3
    Teclas(ARRIBA)=KEY4
    Teclas(DISPARO)=KEY5
END SUB


' - Define las teclas para Joystick SINCLAIR 2 ------------
SUB TeclasSINCLAIR2()
    Teclas(IZQUIERDA)=KEY6
    Teclas(DERECHA)=KEY7
    Teclas(ABAJO)=KEY8
    Teclas(ARRIBA)=KEY9
    Teclas(DISPARO)=KEY0
END SUB


' - Define las teclas para Joystick CURSOR ----------------
SUB TeclasCURSOR()
    Teclas(IZQUIERDA)=KEY5
    Teclas(DERECHA)=KEY8
    Teclas(ABAJO)=KEY6
    Teclas(ARRIBA)=KEY7
    Teclas(DISPARO)=KEY0
END SUB


' - Opción probar teclas ----------------------------------
SUB Probar()
    DIM n AS UByte
    
    ' Imprimimos el título
    CLS
    INK 5
    PRINT AT 5,5;"Probar: ENTER para salir..."
    
    ' Bucle infinito...
    DO
        ' Si el tipo no es KEMPSTON
        IF TipoControl <> 2 THEN
            ' Escaneamos todas las teclas
            FOR n = 0 TO 4
                ' Comprobamos su la tecla del índice se ha pulsado
                IF Multikeys(Teclas(n)) THEN
                    ' Si se ha pulsado, imprimimos su nombre
                    PRINT AT 7+n,13;INK n+2;TeclasS(n);
                ELSE
                    ' Si no se ha pulsado la tecla, borramos el texto
                    PRINT AT 7+n,13;"          ";
                END IF
            NEXT n 
        ' Si el tipo es KEMPSTON
        ELSE
            ' Leemos el valor del puerto del Joystick KEMPSTON
            n = IN(31)            
            IF n bAND %10 THEN  ' Izquierda
                PRINT AT 7,13;INK 2;TeclasS(IZQUIERDA);
            ELSE
                PRINT AT 7,13;"          ";
            END IF
            IF n bAND %1 THEN   ' Derecha
                PRINT AT 8,13;INK 3;TeclasS(DERECHA);
            ELSE
                PRINT AT 8,13;"          ";
            END IF
            IF n bAND %1000 THEN    ' Arriba
                PRINT AT 9,13;INK 4;TeclasS(ARRIBA);
            ELSE
                PRINT AT 9,13;"          ";
            END IF
            IF n bAND %100 THEN    ' Abajo
                PRINT AT 10,13;INK 5;TeclasS(ABAJO);
            ELSE
                PRINT AT 10,13;"          ";
            END IF
            IF n bAND %10000 THEN    ' Disparo
                PRINT AT 11,13;INK 6;TeclasS(DISPARO);
            ELSE
                PRINT AT 11,13;"          ";
            END IF
        END IF
                
        ' Si la tecla pulsada es la de salir, salimos
        IF MultiKeys(KEYENTER) THEN
            RETURN
        END IF
    LOOP
END SUB
