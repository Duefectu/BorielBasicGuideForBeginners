' - Motor del juego ---------------------------------------

' - Bucle principal del juego -----------------------------
SUB Juego()   
    ' Contador de pausa
    DIM wr AS UInteger
    
    ' Iniciar partida
    pantalla = 0
    puntos = 0
    vidas = 3    
    
    ' Bucle de vidas
    WHILE vidas>0
        ' Iniciar pantalla
        x = 2
        y = 2
        frame = 0
        orientacion = 1
        caminando = 0
        
        ' Dibuja la pantalla
        DibujarPantalla(pantalla)
        
        ' Bucle del juego
        DO
            ' Pausa para ralentizar
            FOR wr = 0 TO 3
                waitretrace 
            NEXT wr
            
            ' Miramos si está parado o se mueve
            IF caminando = 0 THEN
                ' Imprimimos el sprite parado
                ImprimirSpriteEstatico()                
            ELSE
                ' Imprimimos el sprite en movimiento
                ImprimirSpriteMovimiento()                
            END IF
            
            ' Gestionamos los controles (teclado)
            GestionarControles()
        LOOP
    WEND        
END SUB


' - Imprimimos el sprite cuando no camina -----------------
SUB ImprimirSpriteEstatico()
    ' Esta parado, imprimimos según la orientación
    IF orientacion = 0 THEN
        ' Está mirando hacia arriba
        putChars(x,y,2,2,@Ingrid_Stand_up(frame,0))
    ELSEIF orientacion = 1 THEN
        ' Está mirando a la derecha
        putChars(x,y,2,2,@Ingrid_Stand_right(frame,0))
    ELSEIF orientacion = 2 THEN
        ' Está mirando hacia abajo
        putChars(x,y,2,2,@Ingrid_Stand_down(frame,0))
    ELSE
        ' Mira a la izquierda por descarte
        putChars(x,y,2,2,@Ingrid_Stand_left(frame,0))
    END IF
    
    ' Incrementamos el subFrame
    subFrame = subFrame + 1
    IF subFrame > 4 THEN
        ' Si subFrame es 5, incrementamos frame
        frame = frame + 1
        IF frame = 2 THEN
            ' Si nos pasamos de frame, volvemos al 0
            frame = 0
        END IF
        subFrame = 0
    END IF   
END SUB   


' - Imprime el sprite cuando se está moviendo -------------
SUB ImprimirSpriteMovimiento()
    ' Tile para la detección de colisiones
    DIM tileTest AS UByte

    ' Está caminando, imprimimos según la orientación
    IF orientacion = 0 THEN
        ' Esta caminando hacia arriba
        ' Obtenemos el tile de arriba
        tileTest=ObtenerTile(pantalla,x,y-1)
        ' Si el tile es igual a 0, nos podemos mover
        IF tileTest = 0 THEN
            ' Borramos la fila de abajo
            putChars(x,y+1,2,1,@Ingrid_Blanco_horizontal(0))
            y = y - 1            
        END IF       
        ' Imprimimos el sprite
        putChars(x,y,2,2,@Ingrid_Walk_up(frame,0))
    ELSEIF orientacion = 1 THEN
        ' Está caminando hacia la derecha
        ' Obtenemos el tile de la derecha
        tileTest=ObtenerTile(pantalla,x+2,y)
        ' Si el tile es igual a 0, nos podemos mover
        IF tileTest = 0 THEN
            ' Borramos la columna de la izquierda
            putChars(x,y,1,2,@Ingrid_Blanco_vertical(0))
            x = x + 1             
        END IF
        ' Imprimimos el sprite
        putChars(x,y,2,2,@Ingrid_Walk_right(frame,0))
    ELSEIF orientacion = 2 THEN
        ' Esta caminando hacia abajo
        ' Obtenemos el tile de abajo
        tileTest=ObtenerTile(pantalla,x,y+2)
        ' Si el tile es igual a 0, nos podemos mover
        IF tileTest = 0 THEN
            ' Borramos la fila de arriba
            putChars(x,y,2,1,@Ingrid_Blanco_horizontal(0))
            y = y + 1           
        END IF
        ' Imprimimos el sprite
        putChars(x,y,2,2,@Ingrid_Walk_down(frame,0))
    ELSE
        ' Está caminando hacia la izquierda por descarte
        ' Borramos la columna de la izquierda
        putChars(x+1,y,1,2,@Ingrid_Blanco_vertical(0))
        ' Obtenemos el tile de la derecha
        tileTest=ObtenerTile(pantalla,x-1,y)
        ' Si el tile es igual a 0, nos podemos mover
        IF tileTest = 0 THEN
            x = x - 1
        END IF
        ' Imprimimos el sprite
        putChars(x,y,2,2,@Ingrid_Walk_left(frame,0))
    END IF
    
    ' Incrementamos el frame, aquí no hay subFrame
    frame = frame + 1
    IF frame = 4 THEN
        frame = 0
        caminando = 0
    END IF
END SUB  


' - Gestiona los controles (teclado) ----------------------
SUB GestionarControles()
    ' Almacenará la tecla pulsada
    DIM k AS String
    
    ' Leemos el teclado
    k = INKEY$
    ' Si se ha pulsado la tecla o
    IF k = "o" THEN
        ' Nos orientamos hacia la izquierda
        orientacion = 3
        ' Caminamos
        caminando = 1
    ELSEIF k = "p" THEN
        ' Nos orientamos hacia la derecha
        orientacion = 1
        ' Caminamos
        caminando = 1
    ELSEIF k = "q" THEN
        ' Nos orientamos hacia arriba
        orientacion = 0
        ' Caminamos
        caminando = 1
    ELSEIF k = "a" THEN
        ' Nos orientamos hacia abajo
        orientacion = 2
        ' Caminamos
        caminando = 1
    END IF
END SUB
