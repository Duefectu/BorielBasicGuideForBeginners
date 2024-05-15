' - BeepFXDemo --------------------------------------------
' https://tinyurl.com/383drd2v

' Llamamos a la subrutina principal
Main()
STOP


' - Includes ----------------------------------------------
#INCLUDE <Input.bas>    ' Para el comando INPUT
#INCLUDE "BeepFX.bas"   ' Nuestra librería de sonidos


' - Subrutina principal -----------------------------------
SUB Main()
    DIM sonido AS UByte ' Sonido a reproducir
    DIM txt AS String   ' Texto del INPUT
    
    ' Preparamos la pantalla
    BORDER 0
    PAPER 0
    INK 6

    ' Repetimos hasta que no haya un mañana
    DO
        ' Borramos
        CLS
        ' Imprimimos un texto
        PRINT AT 5,0;"Teclea el codigo, (0-58): "; 
        ' Leermos la entrada desde el teclado
        txt = input(2)
        ' sonido = al valor numérico introducido
        sonido = val(txt)
        ' Si el valor está entre 0 y 58...
        IF sonido >= 0 AND sonido <= 58 THEN
            ' Reproducimos el sonido
            BeepFX_Play(sonido)
        END IF
    LOOP    
END SUB
