' - MascarasDemo ------------------------------------------
' https://tinyurl.com/yb38jhsv

Main()
STOP

' - Includes ----------------------------------------------
#INCLUDE <putchars.bas>
#INCLUDE "Rosquilla.spr.bas"


' - Subrutina principal -----------------------------------
SUB Main()
    ' Las usaremos para dibujar el fondo
    DIM x, y AS UByte

    ' Filas de 0 a 22 saltando de 2 en 2
    FOR y = 0 TO 22 STEP 2
        ' Columnas de 0 a 30 saltando de 2 en 2 
        FOR x = 0 TO 30 STEP 2
            ' Dibuja el tile del fondo
            PutChars(x,y,2,2,@Rosquilla_Fondo(0))
        NEXT x
    NEXT y

    ' Dibujamos la rosquilla en la zona izquierda
    PutChars(10,10,2,2,@Rosquilla_Sprite(0))

    ' Dibujamos el sprite con la máscara a la derecha
    ' Imprimimos la máscara con un AND (2)
    putCharsOverMode(20,10,2,2,2,@Rosquilla_Sprite_Mask(0))
    ' Imprimimos el sprite con un OR (3)
    putCharsOverMode(20,10,2,2,3,@Rosquilla_Sprite(0))
END SUB