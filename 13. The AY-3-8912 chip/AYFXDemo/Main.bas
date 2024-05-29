' - AYFXDemo ----------------------------------------------
' https://tinyurl.com/2hm63pdt

Main()
STOP


' - Includes ----------------------------------------------
#INCLUDE <input.bas>
#INCLUDE <retrace.bas>
#INCLUDE "AYFXPlayer.bas"


' - Banco de efectos --------------------------------------
BancoEfectos:
ASM
    incbin "test.afb"
END ASM


' - Subrutina principal -----------------------------------
SUB Main()
    DIM numeroS AS String
    DIM n AS UByte

    ' Inicializa el motor de efectos de sonido
    AYFX_Init(@BancoEfectos)

    ' Bucle infinito
    DO
        ' Borramos la pantalla
        CLS
        ' Imprimimos la pantalla
        PRINT AT 0,14;"AYFX Demo";
        PRINT AT 2,0;"Numero de efecto: ";
        ' Pedimos al usuario el código del efecto
        numeroS = input(3)
        ' Iniciamos la reproducción del efecto
        AYFX_Play(VAL(numeroS))

        ' Para reproducir el efecto hay que llamar a
        ' AYFX_PlayFrame cada 20ms o en cada interrupción
        PRINT AT 4,0;"Reproduciendo efecto: ";numeroS;
        ' Reproduciremos los 128 primeros pasos del sonido
        FOR n = 0 TO 127
            ' Imprimimos el contador
            PRINT AT 4,25;n;
            ' Esperamos una interrupción
            waitretrace
            ' Ejecutamos el paso actual
            AYFX_PlayFrame()
        NEXT n
    LOOP
END SUB