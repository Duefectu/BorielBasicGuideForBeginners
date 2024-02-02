' - Módulo de mapeado -------------------------------------


' - Inicializa el mapeado ---------------------------------
SUB Mapeado_Inicializar()
    ' Para el contador
    DIM n AS Integer
    
    ' Imprimiremos 16 tiles
    FOR n=0 TO 15
        ' Despazamos a la izquierda dos tiles (16 pixels)
        WinScrollLeft(8,0,32,10)
        WinScrollLeft(8,0,32,10)
        ' Dibujamos los tiles de la derecha
        Mapeado_DibujarDerecha(n-15)
    NEXT n

    ' Imprimimos las nubes
    putChars(5,1,3,2,@Tiles_Nube1(0))
    putChars(10,5,3,2,@Tiles_Nube1(0))
    putChars(22,6,3,2,@Tiles_Nube1(0))
    putChars(15,2,2,1,@Tiles_Nube2(0))
    putChars(25,5,2,1,@Tiles_Nube2(0))
    
    ' Imprimimos el sol   
    putChars(20,1,3,3,@Tiles_Sol(0,0))
    
    ' Ajustamos la posición inicial del mapa
    PosMapa = 0
    SubPosMapa = 0
END SUB


' - Dibujamos los tiles de la derecha ---------------------
' Entradas:
'   pos (Integer): Posición del mapa con respecto a la
'                   esquina izquierda de la pantalla
SUB Mapeado_DibujarDerecha(pos AS Integer)
    ' Variables locales para el bucle, posición y del
    ' tile y número de tile a dibujar
    DIM n, y, t AS UByte
    
    ' Empezamos en la fila 8
    y=8
    ' Dibujaremos 4 tiles
    FOR n=0 TO 3
        ' Posición del tile a imprimir (sumamos 15 porque
        ' "pos" apunta al tile de la derecha)
        t=Mapa(pos+15,n)
        ' Imprimimos el tile
        putChars(30,y,2,2,@Tiles_Pueblo(t,0))
        ' Incrementamos la posición y en 2 (16 pixels)
        y = y + 2
    NEXT n
END SUB


' - Dibujamos los tiles a la izquierda --------------------
' Entradas:
'   pos (Integer): Posición del mapa con respecto a la
'                   esquina izquierda de la pantalla
SUB Mapeado_DibujarIzquierda(pos AS Integer)
    ' Variables locales para el bucle, posición y del
    ' tile y número de tile a dibujar
    DIM n, y, t AS UByte
    
    ' Empezamos en la fila 8
    y=8
    ' Dibujaremos 4 tiles
    FOR n=0 TO 3
        ' Posición del tile a imprimir
        t=Mapa(pos,n)
        ' Imprimimos el tile
        putChars(0,y,2,2,@Tiles_Pueblo(t,0))
        ' Incrementamos la posición y en 2 (16 pixels)
        y = y + 2
    NEXT n
END SUB


' - Restauramos el fondo ----------------------------------
' Entradas:
'   pos (UByte): Posición del mapa con respecto a la
'                   esquina izquierda de la pantalla
'   subPos (UByte): Subposición del mapa
'   y (Ubyte): Coordenada Y donde imprimir el mapa
SUB RestaurarFondo(pos AS UByte, subPos AS UByte, y AS UByte)
    ' Variables locales para la posición "x", el número de
    ' tile, el valor máximo y mínimo del desplazamiento en
    ' el mapa, la posición "x" e "y" del tile en el mapa, y
    ' la dirección de éste en el array de definición del
    ' mapa
    DIM x, t, maxX, minX, xx, yy, dir AS UByte
    
    ' Posición y del tile
    yy = (y-8)/2 

    ' Si no estamos en un paso intermedio...
    IF subPos=0 THEN
        ' Empezamos a imprimir en 0
        xx = 0
        ' Ajustamos la posición mínima
        minX = pos
    ' Si estamos en un paso intermedio...
    ELSE
        ' Empezamos a imprimir en 1
        xx = 1
        ' Si estamos mirando a la izquierda...
        IF Orientacion = 0 THEN
            ' Ajustamos la posición mínima
            minX = pos 
        ' Si estamos mirando a la derecha
        ELSE
            ' La posición mínima se desplaza 1 a la derecha
            minX = pos + 1
        END IF
    END IF
    
    ' El máximo es el mínimo más 14
    maxX = minX + 14
    ' Bucle desde la posición mínima a la máxima
    FOR x = minX TO maxX
        ' Obtenemos el número del tile superior
        t=Mapa(x,yy-1)
        ' Imprimimos el tile superior
        putChars(xx,y-2,2,2,@Tiles_Pueblo(t,0)) 
        ' Obtenemos el número del tile inferior
        t=Mapa(x,yy) 
        ' Imprimimos el tile ingerior
        putChars(xx,y,2,2,@Tiles_Pueblo(t,0)) 
        ' Incrementamos xx en 2 (16 pixels)
        xx = xx + 2
    NEXT x
END SUB


' - Dibuja los árboles del primer plano -------------------
' Entradas:
'   pos (UByte): Posición del mapa con respecto a la
'                   esquina izquierda de la pantalla
'   subPos (UByte): Subposición del mapa
'   y (Ubyte): Coordenada Y donde imprimir el mapa
SUB DibujarPrimerPlano(pos AS UByte, subPos AS UByte, y AS UByte)
    ' Variables locales: n contador, xa para la posición de
    ' los árboles en el mapa, x para calcular la posición
    ' en pantalla, maxX y minX definen los máximos y
    ' mínimos de la parte del mapa que se ve en pantalla y
    ' xx se usa para calcular es desplazamiento cuando
    ' subPos es 1
    DIM n, xa, x, maxX, minX, xx AS UByte
    
    ' Si subPos es 0...
    IF subPos=0 THEN
        ' Usamos los valores normales
        xx = 0
        minX = pos
    ' Si subPos es 1...
    ELSE
        ' Se empieza a imprimir en 1
        xx = 1
        ' Si la orientación es a la izquierda
        IF Orientacion = 0 THEN
            ' La posición mínima no cambia
            minX = pos 
        ' Si la orientación es la derecha
        ELSE
            ' La posición mínima es + 1
            minX = pos + 1
        END IF
    END IF
        
    ' La posición máxima del mapa es 14 más la mínima
    maxX = minX + 14
    
    ' Solo hay 4 árboles en primer plano
    FOR n = 0 TO 4
        ' Posición x del árbol con respecto al mapa
        xa=Mapa_PrimerPlano(n)
        ' Miramos si el árbol es visible
        IF xa>=minX THEN
            ' Anidando dos IF nos ahorramos un AND
            IF xa<=maxX THEN
                ' Si es visible calculamos x
                x = (xa - minX) * 2 + xx
                ' Dibujamos la máscara del árbol con un AND
                putCharsOverMode(x,y,4,4,2,@Tiles_Arbol(1,0))
                ' Dibujamos el árbol con un OR
                putCharsOverMode(x,y,4,4,3,@Tiles_Arbol(0,0))
            END IF
        END IF
    NEXT n   
END SUB


' - Desplaza la pantalla dependiendo de la orientación ----
' Entradas:
'   orient (UByte): Orientación del desplazamiento, 
'                       1=Derecha, 2=Izquierda
SUB MoverPantalla(orient AS UByte)
    ' Si vamos a la izquierda...
    IF orient = 0 THEN
        ' Scroll al carácter del segundo tercio
        WinScrollRight(8,0,32,8)
        ' Borramos el sol (frame 1 del sol)
        putChars(20,1,3,3,@Tiles_Sol(1,0))
        ' Scroll al pixel del primer tercio
        ScrollRight(0,127,255,191)
        ' Dibujamos el sol (frame 0 del sol)
        putChars(20,1,3,3,@Tiles_Sol(0,0))
    ' Si vamos a la derecha...
    ELSE
        ' Scroll al carácter del segundo tercio
        WinScrollLeft(8,0,32,8)
        ' Borramos el sol (frame 1 del sol)
        putChars(20,1,3,3,@Tiles_Sol(1,0))
        ' Scroll al pixel del primer tercio
        ScrollLeft(0,127,255,191)
        ' Dibujamos el sol (frame 0 del sol)
        putChars(20,1,3,3,@Tiles_Sol(0,0))
    END IF
END SUB
