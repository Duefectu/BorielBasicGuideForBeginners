' - Módulo principal del juego ----------------------------


' - Bucle del juego ---------------------------------------
SUB Juego() 
    ' Inicializamos la partida    
    InicializarPartida()
    ' Dibujamos el panel de puntuación
    DibujarPanelPuntos()
    ' Actualizamos el panel de puntuación
    ActualizarPanelPuntos()
    
    ' Si usamos doble buffer, lo activamos ahora
#IFDEF DOUBLE_BUFFER
    ActivarBuffer()
#ENDIF

    ' Inicializa el mapeado
    Mapeado_Inicializar()
    ' Bucle infinito
    DO
        ' Si usamos doble buffer...
#IFDEF DOUBLE_BUFFER
        ' Copiamos el buffer a la pantalla
        BufferAPantalla()
#ELSE
        ' Si no usamos doble buffer, esperamos al barrido
        waitretrace
        ' Ajustamos un atributo visible en el area de juego
        paint(0,8,31,8,%00111000)
#ENDIF
        
        ' Imprime el sprite de la guerrera
        IF Caminando = 0 THEN
            ' Imprime el sprite cuando está parada
            ImprimirSpriteParado()
        ELSE
            ' Imprime el sprite cuando se mueve
            ImprimirSpriteMovimiento()
        END IF
        
        ' Movimiento
        IF SubPosMapa = 0 THEN
            ' Si estamos en una posición par, gestionamos
            ' el movimiento desde el teclado
            ControlMovimiento()
        END IF
    LOOP    
END SUB


' - Inicializa la partida ---------------------------------
SUB InicializarPartida()
    ' Variable de uso interno para bucles
    DIM n AS UByte
    
    ' Posición y estado inicial de la guerrera
    PX = 4
    PY = 14
    Frame = 0
    SubFrame = 0
    Orientacion = 1
    Caminando = 0
    
    ' Cambiamos los atributos de las zonas de ocultación a
    ' papel blanco con tinta blanca
    paint(0,0,1,18,%00111111)
    paint(31,0,1,18,%00111111)


    ' Imprimimos el suelo directamente en la pantalla
    FOR n=0 TO 30 STEP 2
        putChars(n,16,2,2,@Tiles_Pueblo(1,0))
    NEXT n
END SUB


' - Imprimimos el sprite cuando está parado ---------------
SUB ImprimirSpriteParado()
    ' Restauramos el fondo del mapa
    RestaurarFondo(PosMapa,SubPosMapa,PY)
    
    ' Si miramos a la derecha...
    IF Orientacion = 1 THEN
        ' Imprimimos la máscara con un AND
        putCharsOverMode(PX,PY,2,2,2,@Ingrid_Stand_right_Mask(Frame,0))
        ' Imprimimos el sprite con un OR
        putCharsOverMode(PX,PY,2,2,3,@Ingrid_Stand_right(Frame,0))
    ' Si miramos a la izquierda...
    ELSE
        ' Imprimimos la máscara con un AND
        putCharsOverMode(PX,PY,2,2,2,@Ingrid_Stand_left_Mask(Frame,0))
        ' Imprimimos el sprite con un OR
        putCharsOverMode(PX,PY,2,2,3,@Ingrid_Stand_left(Frame,0))
    END IF
    
    ' Dibujamos los árboles del primer plano
    DibujarPrimerPlano(PosMapa, SubPosMapa, PY-2)
    
    ' Incrementamos el subframe
    SubFrame = SubFrame + 1
    ' Si subframe es 4...
    IF SubFrame = 4 THEN
        ' Reseteamos subFrame
        SubFrame = 0
        ' Sumamos 1 al frame actual
        Frame = Frame + 1
        ' Si el frame es 2, reseteamos el frame
        IF Frame = 2 THEN
            Frame = 0
        END IF
    END IF
END SUB


' - Imprime el sprite cuando se está moviendo -------------
SUB ImprimirSpriteMovimiento()
    ' Restauramos el fondo del mapa
    RestaurarFondo(PosMapa,SubPosMapa,PY)

    ' Si está mirando a la derecha...
    IF Orientacion = 1 THEN
        ' Si no hemos llegado al borde...
        IF PX < 26 THEN                
            ' Incrementamos la posición del sprite
            PX = PX + 1
        ELSE
            ' Si no hemos llegado al final del mapa...
            IF PosMapa < 14 THEN
                ' Desplazamos la pantalla
                MoverPantalla(Orientacion)
                ' Si estamos en una posición intermedia...
                IF SubPosMapa = 1 THEN
                    ' Reseteamos SubPosMapa
                    SubPosMapa = 0
                    ' Incrementamos la posición del mapa
                    PosMapa = PosMapa + 1
                    ' Dibujamos el tile de la derecha
                    Mapeado_DibujarDerecha(PosMapa)
                ' Si no estamos en una posición intermedia
                ELSE
                    ' Incrementamos SubPosMapa
                    SubPosMapa = 1
                END IF
            ' Si hemos llegado al final del mapa...
            ELSE
                ' No permitimos que se desplace más
                PosMapa = 14
                SubPosMapa = 0
            END IF
        END IF
        ' Imprimimos la máscara de la guerrera con AND
        putCharsOverMode(PX,PY,2,2,2,@Ingrid_Walk_right_Mask(Frame,0))
        ' Imprimimos el sprite de Ingrid con OR
        putCharsOverMode(PX,PY,2,2,3,@Ingrid_Walk_right(Frame,0))
    ' Si miramos a la izquierda...
    ELSE
        ' Si no hemos llegado al borde izquierdo...
        IF PX > 4 THEN
            ' Decrementamos la posición del sprite
            PX = PX - 1
        ' Si hemos llegado al borde izquierdo...
        ELSE
            ' Si no hemos llegado al inicio del mapa...
            IF PosMapa > 0 THEN
                ' Desplazamos la pantalla
                MoverPantalla(Orientacion)
                ' Si estamos en una posición intermedia...
                IF SubPosMapa = 1 THEN
                    ' Reseteamos SubPosMapa
                    SubPosMapa = 0
                    ' Decrementamos la posición del mapa
                    PosMapa = PosMapa - 1
                    ' Dibujamos el tile de la izquierda
                    Mapeado_DibujarIzquierda(PosMapa)
                ELSE
                    SubPosMapa = 1
                END IF
            ' Si hemos llegado al principio del mapa...
            ELSE
                ' No permitimos que se desplace más            
                PosMapa = 0
                SubPosMapa = 0
            END IF
        END IF
        ' Imprimimos la máscara de la guerrera con AND
        putCharsOverMode(PX,PY,2,2,2,@Ingrid_Walk_left_Mask(Frame,0))
        ' Imprimimos el sprite de Ingrid con OR
        putCharsOverMode(PX,PY,2,2,3,@Ingrid_Walk_left(Frame,0))
    END IF
    
    ' Dibujamos los árboles del primer plano
    DibujarPrimerPlano(PosMapa, SubPosMapa, PY-2)
    
    ' Si el frame del sprite es 3...
    IF Frame = 3 THEN
        ' Reseteamos el frame
        Frame = 0
        ' Dejamos de caminar
        Caminando = 0
    ' Si el frame del sprite no es tres
    ELSE
        ' Incrementamos el frame
        Frame = Frame + 1
    END IF
    
    ' Si estamos en un paso intermedio del mapa...
    IF SubPosMapa = 1 THEN
        ' Si estamos parados nos hace caminar
        IF Caminando = 0 THEN
            Caminando = 1
        END IF
    END IF
END SUB


' - Controla el movimiento de la guerrera -----------------
SUB ControlMovimiento()
    ' Para guardar la tecla pulsada
    DIM k AS String
    
    ' Leemos la tecla pulsada
    k = INKEY$
    ' Si la tecla es la O...
    IF k = "o" THEN
        ' Si NO estamos mirando a la izquierda ni estamos
        ' caminando...
        IF NOT(Orientacion = 0 AND Caminando = 1) THEN
            ' Reseteamos el frame
            Frame = 0
        END IF
        ' Ajustamos la orientación a la izquierda
        Orientacion = 0
        ' Empezamos a caminar
        Caminando = 1
    ' Si la tecla es la "P"...
    ELSEIF k = "p" THEN
        ' Si NO estamos mirando a la derecha ni estamos
        ' caminando...
        IF NOT(Orientacion = 1 AND Caminando = 1) THEN
            ' Reseteamos el frame
            Frame = 0
        END IF
        ' Ajustamos la orientación
        Orientacion = 1
        ' Empezamos a caminar
        Caminando = 1
    END IF
END SUB


' - Dibujamos el panel de puntuaciones --------------------
SUB DibujarPanelPuntos()
    ' Cambiamos los atributos del marcador a papel y tinta 
    ' amarillos
    paint(1,18,30,5,%00110000)

    ' Imprimimos el panel con GDUs y colorines!!!
    PAPER 7
    INK 0
    PRINT AT 18,1;"\A";
    PRINT AT 18,30;"\B";
    PRINT AT 22,1;"\D";
    PRINT AT 22,30;"\C";    
    PRINT AT 17,0;"    \F    \F\F    \F   \F     \F   \F ";
    PAPER 6
    PRINT AT 18,2;"\E\E \E\E\E\E  \E\E\E\E \E\E\E \E\E\E\E\E \E\E\E";
    PRINT AT 19,1;"\H";
    PRINT AT 19,30;"\G";
    PRINT AT 20,0;PAPER 7;"\G";
    PRINT AT 20,30;"\G";
    PRINT AT 21,1;"\H";
    PRINT AT 21,31;PAPER 7;"\H";
    PRINT AT 22,2;"\F\F \F\F\F   \F  \F\F \F   \F\F   \F  \F";
    PAPER 7
    PRINT AT 23,2;"  \E   \E\E\E \E\E  \E \E\E\E  \E\E\E \E\E";
END SUB


' - Actualiza el panel de puntuación (es broma) -----------
SUB ActualizarPanelPuntos()
    ' Simulamos los valores de los marcadores
    PAPER 6
    INK 1
    PRINT AT 19,5;"LA CASA DE LA PRADERA";
    PRINT AT 21,2;"VIDAS: ";INK 2;"\I \J \K";
    PRINT AT 21,19;INK 0;"\L \L";INK 1;" :LLAVES";
END SUB