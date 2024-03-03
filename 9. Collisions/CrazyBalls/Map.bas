' - Bolas Locas -------------------------------------------
' - Mapa del juego ----------------------------------------


' Almacena el mapa actual
DIM Mapa(31,23) AS UByte


' - Crea el mapa ------------------------------------------
SUB CrearMapa()
    DIM n, x, y AS UByte
    
    ' Borramos el mapa
    FOR y = 0 TO 23
        FOR x = 0 TO 31
            Mapa(x,y) = 0
        NEXT x
    NEXT y
    
    ' Esquinas
    Mapa(0,0) = $92
    Mapa(31,0) = $94
    Mapa(0,23) = $97
    Mapa(31,23) = $99
    
    ' Bordes horizontales
    FOR n = 1 TO 30
        Mapa(n,0) = $93
        Mapa(n,23) = $98
    NEXT n
    ' Bordes verticales
    FOR n = 1 TO 22
        Mapa(0,n) = $95
        Mapa(31,n) = $96
    NEXT n
    
    ' Algunas islas
    FOR n = 0 TO 4
        CrearMapa_Isla((RND * 24) + 5, (RND * 17) + 5)
    NEXT n
END SUB


' - Crea una isla en el mapa ------------------------------
SUB CrearMapa_Isla(x AS UByte, y AS UByte)
    Mapa(x,y) = $92
    Mapa(x+1,y) = $93
    Mapa(x+2,y) = $94
    Mapa(x,y+1) = $97
    Mapa(x+1,y+1) = $98
    Mapa(x+2,y+1) = $99
END SUB


' - Dibujar mapa ------------------------------------------
SUB DibujarMapa()
    DIM x, y AS UByte
    
    FOR y = 0 TO 23
        FOR x = 0 TO 31
            PRINT AT y,x;chr(Mapa(x,y));
        NEXT x
    NEXT y
END SUB
