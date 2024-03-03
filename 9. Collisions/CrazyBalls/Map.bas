' - Crazy Balls -------------------------------------------
' - Game Map ----------------------------------------------


' Stores the current map
DIM Map(31,23) AS UByte


' - Create the map ----------------------------------------
SUB CreateMap()
    DIM n, x, y AS UByte
    
    ' Clear the map
    FOR y = 0 TO 23
        FOR x = 0 TO 31
            Map(x,y) = 0
        NEXT x
    NEXT y
    
    ' Corners
    Map(0,0) = $92
    Map(31,0) = $94
    Map(0,23) = $97
    Map(31,23) = $99
    
    ' Horizontal edges
    FOR n = 1 TO 30
        Map(n,0) = $93
        Map(n,23) = $98
    NEXT n
    ' Vertical edges
    FOR n = 1 TO 22
        Map(0,n) = $95
        Map(31,n) = $96
    NEXT n
    
    ' Some islands
    FOR n = 0 TO 4
        CreateMap_Island((RND * 24) + 5, (RND * 17) + 5)
    NEXT n
END SUB


' - Creates an island on the map --------------------------
SUB CreateMap_Island(x AS UByte, y AS UByte)
    Map(x,y) = $92
    Map(x+1,y) = $93
    Map(x+2,y) = $94
    Map(x,y+1) = $97
    Map(x+1,y+1) = $98
    Map(x+2,y+1) = $99
END SUB


' - Draw map -----------------------------------------------
SUB DrawMap()
    DIM x, y AS UByte
    
    FOR y = 0 TO 23
        FOR x = 0 TO 31
            PRINT AT y,x;chr(Map(x,y));
        NEXT x
    NEXT y
END SUB
