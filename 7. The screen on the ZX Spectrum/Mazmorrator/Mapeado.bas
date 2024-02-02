' - Gestión de mapas --------------------------------------

' - Dibuja una pantalla -----------------------------------
' Entradas:
'   pantalla (UByte): Número de pantalla a dibujar
SUB DibujarPantalla(pantalla AS UByte)
    ' Variables locales
    ' Para el bucle de dibujado
    DIM x, y AS UByte
    ' Posición del tile en pantalla
    DIM tx, ty AS UByte
    ' Dirección del próximo tile en el mapa
    DIM dir AS UByte
    ' Número de tile a dibujar
    DIM tile AS UByte
    
    ' Empezamos desde el primer byte del mapa
    dir = 0
    ' Posición inicial Y en pantalla: 0
    ty = 0
    ' Recorremos las filas de 0 a 11
    FOR y = 0 TO 11
        ' Posición inicial X en pantalla: 0
        tx = 0
        ' Recorremos las columnas de 0 a 15
        FOR x = 0 TO 15
            ' Obtenemos el número de tile a dibujar
            tile = Pantallas(pantalla,dir)   
            ' Imprimimos el sprite/tile
            PutChars(tx,ty,2,2,@Tiles_Castillo(tile,0))
            ' Coloreamos el tile con los atributos
            PaintData(tx,ty,2,2,@Tiles_Castillo_Attr(tile,0))
            ' Siguiente dirección del mapa
            dir = dir + 1
            ' Siguiente columna (posición X) en pantalla
            tx = tx + 2
        NEXT x
        ' Siguiente fila (posición Y) en pantalla
        ty = ty + 2
    NEXT y
END SUB


' - Obtiene el tile de una pantalla -----------------------
' Parámetros:
'   pantalla (UByte): Pantalla sobre la que obtener el tile
'   x (UByte): Coordenada x (columna)
'   y (UByte): Coordenada y (fila)
' Devuelve:
'   (UByte): Tile que se encuentra en la posición indicada
FUNCTION ObtenerTile(pantalla as UByte, x AS UByte, y as UByte) AS UByte
    DIM dir AS UByte
    ' Dirección del tile (y*16)+x, solo que los tiles son 
    ' de 16x16, así que hay que dividir x e y por dos.
    dir=((y/2)*16)+(x/2)
    RETURN Pantallas(pantalla,dir)
END FUNCTION
