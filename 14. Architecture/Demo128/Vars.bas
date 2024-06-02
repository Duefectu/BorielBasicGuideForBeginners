' - Demo128 -----------------------------------------------
' https://tinyurl.com/55jh39x5
' - Módulo de variables comunes ---------------------------


' - Defines -----------------------------------------------
' Módulos de juego. El código del módulo debe coincidir con
' el banco de memoria en el que se encuentra
#DEFINE MODULO_MENU 1
#DEFINE MODULO_JUEGO 4
#DEFINE MODULO_MINIJUEGOS 3
#DEFINE MODULO_GAMEOVER 7

' Dirección de las variables comunes (VariablesComunes)
#DEFINE DIRVARS $6834

' Tipos de control
#DEFINE CONTROL_NODEFINIDO 0
#DEFINE CONTROL_TECLADO 1
#DEFINE CONTROL_KEMPSTON 2
#DEFINE CONTROL_SINCLAIR 3
#DEFINE CONTROL_CURSOR 4


' - Variables globales comunes ----------------------------
' Carga de módulos
DIM ModuloAEjecutar AS UByte AT DIRVARS
DIM Parametro1 AS UByte AT DIRVARS + 1
DIM Parametro2 AS UInteger AT DIRVARS + 2

' Configuración
DIM TipoControl AS UByte AT DIRVARS + 4
DIM TeclaIzquierda AS UInteger AT DIRVARS + 5
DIM TeclaDerecha AS UInteger AT DIRVARS + 7
DIM TeclaArriba AS UInteger AT DIRVARS + 9
DIM TeclaAbajo AS UInteger AT DIRVARS + 11
DIM TeclaDisparo AS UInteger AT DIRVARS + 13

' Partida
DIM Vidas AS UByte AT DIRVARS + 15
DIM Puntos AS ULong AT DIRVARS + 16
DIM Record AS ULong AT DIRVARS + 20
DIM Nivel AS UByte AT DIRVARS + 24
DIM ObjetosMochila(8) AS UByte AT DIRVARS + 25
DIM Energia AS UByte AT DIRVARS + 36 ' 25 + 9 + 2


' - Conmuta el banco indicado en el slot 3 ---------------
' Parámetros:
'   banco (UByte): Banco a colocar en el slot 3 (0-7)
SUB FASTCALL PaginarMemoria(banco AS UByte)
ASM
    ld d,a          ; Con FASTCALL banco se coloca en A
    ld a,($5b5c)    ; Leemos BANKM
    and %11111000   ; Reseteamos los 3 primeros bits
    or d            ; Ajustamos los 3 primeros bits con el                 
                    ; "banco"
    ld bc,$7ffd     ; Puerto donde haremos el OUT
    di              ; Deshabilitamos las interrupciones
    ld ($5b5c),a    ; Actualizamos BANKM
    out (c),a       ; Hacemos el OUT
    ei              ; Habilitamos las interrupciones
END ASM
END SUB
