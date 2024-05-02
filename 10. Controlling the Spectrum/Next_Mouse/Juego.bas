' - Mouse demo --------------------------------------------
' - Bucle del juego ---------------------------------------

' Declaramos la función DibujarMonstruos
DECLARE FUNCTION DibujarMonstruos() AS UByte


' - Bucle principal del juego -----------------------------
SUB Juego()
    ' Variable locales
    DIM pulsado AS UByte

    ' Inicializamos la partida
    InicializarPartida()

    DO
        ' Sincronizamos con el barrido de pantalla
        waitretrace
        ' Imprimimos el marcador de puntos
        PRINT AT 0,0;INK 4;"Puntos: ";Puntos;" ";
        ' Imprimimos el marcador de nivel
        PRINT AT 23,0;INK 5;"Nivel: ";Nivel;"."; _
            NumMonstruos;
        
        ' Leemos el estado del ratón
        LeerMouse()
        ' Actualizamos la posición del punto de mira
        UpdateSprite(MouseX+32,256-MouseY+32,0,0,0,0)

        ' Si no estaba pulsado en la iteración anterior...
        IF pulsado = 0 THEN
            ' Si se ha pulsado el botón izquierdo...
            IF MouseBotonI <> 0 THEN
                ' Ponemos el anti-rebote a 1
                pulsado = 1
                ' Creamos un disparo nuevo
                CrearDisparo()
            END IF
        ' Si el botón estaba pulsado antes (pulsado)...
        ELSE
            ' Si no se está pulsando el botón izquierdo...
            IF MouseBotonI = 0 THEN
                ' Reseteamos el anti-rebote
                pulsado = 0
            END IF
        END IF

        ' Dibujamos los disparos
        DibujarDisparos()
        
        ' Creamos monstruos, si procede
        CrearMonstruos()
        ' Dibujamos los monstruos y comprobamos si nos
        ' han matado...
        IF DibujarMonstruos() = 1 THEN
            ' Si nos han matado salimos del bucle
            EXIT DO
        END IF
    LOOP
    
    ' Borramos todos los sprites
    FOR n = 0 TO 127
        RemoveSprite(n,0)
    NEXT n
    
    ' Imprimirmos el texto "MUERTO!!!"
    ImprimirCentrado16(2,"MUERTO!!!")
    ' Imprimimos "PUNTOS: 0" centrado
    ImprimirCentrado16(4,"PUNTOS: " + STR(Puntos))
    ' Si hemos superado el record...
    IF Puntos > Record THEN
        ' Nuevo record y texto
        Record = Puntos
        ImprimirCentrado16(6,"NUEVO RECORD!")
    ELSE
        ' Imprimimos el record actual
        ImprimirCentrado16(6,"RECORD: " + STR(Record))
    END IF
    ' Esperamos un clic del ratón
    ImprimirCentrado16(8,"CLICK MOUSE!")       
    PausaClic()
END SUB


' - Inicializa una partida --------------------------------
SUB InicializarPartida()
    DIM n AS UByte
    
    ' Borramos la pantalla de la ULA
    CLS
    ' Borramos la pantalla de la Layer 2
    CLS256(0)
    
    ' Reseteamos contadores
    Puntos = 0
    Nivel = 0
    NumMonstruos = 0
    ' Reseteamos el array de disparos
    FOR n = 0 TO DIS_MAX
        Disparos(n,DIS_ESTADO) = 0
    NEXT n
    ' Reseteamos el array de monstruos
    FOR n = 0 TO MONS_MAX
        Monstruos(n,MONS_ESTADO) = 0
    NEXT n
    ' Imprimimos el marcador de record
    PRINT AT 0,20;INK 2;"Record: ";Record;
END SUB


' - Creamos un disparo nuevo, si se puede -----------------
SUB CrearDisparo()
    DIM n, x, y AS UByte

    ' Recorremos todo el array de disparos
    FOR n = 0 TO DIS_MAX
        ' Si el disparo no está en uso...
        IF Disparos(n,DIS_ESTADO) = 0 THEN
            ' Coordenas del disparo
            x = MouseX
            y = 256 - MouseY
            ' Actualizamos la matriz de disparos
            Disparos(n,DIS_X) = x
            Disparos(n,DIS_Y) = y + 32
            ' Estado inicial 20
            Disparos(n,DIS_ESTADO) = 20
            ' Comprobamos si le hemos dado a algo
            ChequearDisparo(x,y)
            ' Cada disparo nos quita 50 puntos
            IF Puntos > 50 THEN
                Puntos = Puntos - 50
            ELSE
                Puntos = 0
            END IF
            ' Salimos para crear un solo disparo
            RETURN
        END IF
    NEXT n
END SUB


' - Chequea si le hemos dado a algo -----------------------
SUB ChequearDisparo(x AS UInteger, y AS UInteger)
    DIM x1, x2, y1, y2 AS UInteger
    DIM xs1, xs2, ys1, ys2 AS UInteger
    DIM n, t AS UInteger
    
    ' Caja de colisión del disparo
    x1 = x + 32
    y1 = y + 32
    x2 = x1 + 16
    y2 = y1 + 16
    
    ' Recorremos todo el array de monstruos
    FOR n = 0 TO MONS_MAX
        ' Si el monstruo está activo...
        IF Monstruos(n,MONS_ESTADO) = 1 THEN
            ' Creamos la caja de colisión del monstruo
            xs1 = Monstruos(n,MONS_X)
            xs2 = xs1 + 32
            ys1 = Monstruos(n,MONS_Y)
            ys2 = ys1 + 32
            
            ' Descartamos cuando no colisiona -------------
            ' Eje X -----------------------------
            ' Fin del monstruo antes que Ingrid
            IF xs2 < x1 THEN CONTINUE FOR
            ' Inicio del monstruo después de Ingrid
            IF xs1 > x2 THEN CONTINUE FOR
            ' Eje Y -----------------------------
            ' Fin del monstruo antes que Ingrid
            IF ys2 < y1 THEN CONTINUE FOR
            ' Inicio del monstruo después de Ingrid
            IF ys1 > y2 THEN CONTINUE FOR            
            ' Si llegamos aquí es que ha colisionado ------
            
            ' Leemos el tiempo que le quedaba al
            ' monstruo
            t = Monstruos(n,MONS_TIEMPO)
            ' Sumamos ese tiempo a los puntos
            Puntos = Puntos + t
            ' Ponemos el monstruo en estado 2
            Monstruos(n,MONS_ESTADO) = 2
            ' Incrementamos el número de muertes
            NumMonstruos = NumMonstruos + 1
            ' Si hemos matado más de 10...
            IF NumMonstruos = 10 THEN
                ' Subimos de nivel
                Nivel = Nivel + 1
                ' Reseteamos el contador
                NumMonstruos = 0
            END IF
        END IF
    NEXT n    
END SUB


' - Dibuja los disparos -----------------------------------
SUB DibujarDisparos()
    DIM n, estado AS UByte
    DIM x AS Integer

    ' Recorremos toda la matriz de disparos
    FOR n = 0 TO DIS_MAX
        ' Leemos el estado del disparo
        estado = Disparos(n,DIS_ESTADO)
        ' Si el estado no es cero...
        IF estado <> 0 THEN 
            ' Leemos la coordenada x
            x = Disparos(n,DIS_X) + 32 
            ' Si el estado es mayor de 10...
            IF estado > 10 THEN
                ' Dibujamos el sprite 2 (grande)
                UpdateSprite(x,Disparos(n,DIS_Y),n+1,2,0,0)
                ' Decrementamos el estado
                Disparos(n,DIS_ESTADO) = estado - 1
            ' Si no, y si el estado es mayor de 1...
            ELSEIF estado > 1 THEN
                ' Dibujamos el sprite 1 (pequeño)
                UpdateSprite(x,Disparos(n,DIS_Y),n+1,1,0,0)
                ' Decrementamos el estado
                Disparos(n,DIS_ESTADO) = estado - 1
            ' Si es 1...
            ELSE
                ' Marcamos el disparo como disponible
                Disparos(n,DIS_ESTADO) = 0
                ' Borramos el sprite
                RemoveSprite(n+1,0) 
            END IF
        END IF
    NEXT n    
END SUB


' - Crea un monstruo, si le da la gana --------------------
SUB CrearMonstruos()
    DIM n, t AS UByte
    
    ' Si hay menos monstruos que el nivel actual...
    IF MaxMonstruos <= Nivel THEN
        ' Tira un dado de 0 a 99.999
        t = RND * 100
        ' Si el dado es mayor de 95...
        IF t > 95 THEN
            ' Buscamos un disparo dispobible
            FOR n = 0 TO MONS_MAX
                ' Si el estado es 0, está disponible
                IF Monstruos(n,MONS_ESTADO) = 0 THEN
                    ' Coordenadas del monstruo
                    Monstruos(n,MONS_X) = (RND * 224) + 32
                    Monstruos(n,MONS_Y) = (RND * 128) + 32
                    ' Tipo de monstruos (3 a  7)
                    Monstruos(n,MONS_ID) = (RND * 4) + 3
                    ' Lo marcamos como activo
                    Monstruos(n,MONS_ESTADO) = 1
                    ' Tiempo hasta que el monstruo nos mate
                    Monstruos(n,MONS_TIEMPO)=200-(Nivel*10)
                    ' Salimos para no crear más monstruos
                    RETURN
                END IF
            NEXT n
        END IF
    END IF
END SUB


' - Dibujar monstruos -------------------------------------
FUNCTION DibujarMonstruos()
    DIM n, estado AS UByte
    DIM r, z AS UByte
    DIM t AS UInteger
    
    ' Contador de monstruos a cero
    MaxMonstruos = 0
    ' Recorremos toda la matriz Monstruos
    FOR n = 0 TO MONS_MAX
        ' Estado del monstruo
        estado = Monstruos(n,MONS_ESTADO)
        ' Si no está muerto...
        IF estado <> 0 THEN
            ' Atributo 4 del sprite: doble ancho y alto
            z = %00001010
            ' Si está "vivo"...
            IF estado = 1 THEN
                ' Incrementamos el contador de monstrus
                MaxMonstruos = MaxMonstruos + 1
                ' Atributo 2 del sprite: por defecto
                r = 0
                ' Leemos el tiempo que le queda al monstruo
                t = Monstruos(n,MONS_TIEMPO)
                ' Si No le queda tiempo...
                IF t = 0 THEN
                    ' Salimos con un 1 (nos ha matado)
                    RETURN 1
                ' Si aún nos queda tiempo
                ELSE
                    ' Decrementamos el tiempo del monstruo
                    Monstruos(n,MONS_TIEMPO) = t - 1
                END IF
            ' Si el monstruo ya no está vivo...
            ELSEIF estado = 2 THEN
                ' Lo rotamos 90 grados a la dereca
                r = %10
                ' Pasamos a estado 3
                Monstruos(n,MONS_ESTADO) = 3
            ' Si estamos en estado 3...
            ELSEIF estado = 3 THEN
                ' Espero vertical (equivale a rotar
                ' 180 grados)
                r = %1000
                ' Pasamos a estado 4
                Monstruos(n,MONS_ESTADO) = 4
            ' Si estamos en estado 4...
            ELSEIF estado = 4 THEN
                ' Espejo vertical más rotación = 270 grados
                r = %1010
                ' Pasamos a estado 5
                Monstruos(n,MONS_ESTADO) = 5
            ' Si estamos en estado 5...
            ELSEIF estado = 5 THEN
                ' Pasamos a estado 6
                Monstruos(n,MONS_ESTADO) = 6
                ' Mostramos el sprite normal (pequeño)
                UpdateSprite(Monstruos(n,MONS_X)+16, _
                    Monstruos(n,MONS_Y)+16, _
                    n+DIS_MAX, _
                    Monstruos(n,MONS_ID), _
                    0, _
                    0)
                ' Salimos sin colisión
                RETURN 0
            ' Si estado es 6...
            ELSEIF estado = 6 THEN
                ' Estado = 0, zoombie muerto
                Monstruos(n,MONS_ESTADO) = 0
                ' Borramos el sprite del zoombie
                RemoveSprite(n+DIS_MAX,0)
                ' Salimos sin colisión
                RETURN 0
            END IF
            ' Dibujamos el sprite del monstruo. Llegamos
            ' aquí con estados 1, 2, 3 y 4
            UpdateSprite(Monstruos(n,MONS_X), _
                Monstruos(n,MONS_Y), _
                n+DIS_MAX, _
                Monstruos(n,MONS_ID), _
                r, _
                z)
        END IF
    NEXT n
    ' Salimos sin colisión
    RETURN 0
END FUNCTION
