' - Next_Mouse --------------------------------------------
' - Texto de 16 x 16 pixels -------------------------------

' - Imprime un texto con las fuentes multicolor de 16x16 --
' Usa los tiles ubicados en la dirección $c000
' Parámetros:
'   x (UByte): Celda x en resolución de 16 pixels (0 a 15)
'   y (UByte): Celda y en resolución de 16 pixels (0 a 11)
'   txt (String): Texto a imprimir (solo mayúsculas)
SUB ImprimirTexto16(x AS UByte, y AS UByte, txt AS String)
    DIM n, c AS UByte
    DIM dir AS UInteger
    
    ' Recorremos toda la cadena de texto
    FOR n = 0 TO LEN(txt)-1
        ' Código ASCII de la letra actual
        c = CODE txt(n)
        ' Si el código está entre "A" y "Z"...
        IF c>64 AND c<91 THEN
            ' Restamos 61 al código
            c = c - 61
        ' Si el código está entre "0" y "9"...
        ELSEIF c >47 AND c < 58 THEN
            ' Restamos 16 al código
            c = c - 16
        ' Si es ":" el código es 30            
        ELSEIF c = 58 THEN
            c = 30
        ' Si es "." el código es 31
        ELSEIF c = 46 THEN
            c = 31
        ' Si es "!" el código es 1            
        ELSEIF c = 33 THEN  ' !
            c = 1
        ' Si es " el código es 2
        ELSEIF c = 34 THEN
            c = 2
        ' Si no es ninguno de los anteriores, no se imprime
        ELSE      
            c = 0
        END IF
        ' Imprime el Tile de 16x16        
        DoTile(x,y,c)
        ' Incrementa x
        x = x + 1
    NEXT n
END SUB


' - Imprime un texto centrado con fuente multicolor 16x16 -
'   y (UByte): Celda y en resolución de 16 pixels (0 a 11)
'   txt (String): Texto a imprimir (solo mayúsculas)
SUB ImprimirCentrado16(y AS UByte, txt AS String)
    DIM x AS UByte
    ' La mitad de la pantalla (8) menos la mitad de la
    ' longitud del texto
    x = 8 - (LEN(txt) / 2)
    ' Imprime el texto
    ImprimirTexto16(x,y,txt) 
END SUB
