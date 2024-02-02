' - PutCharsDemo ------------------------------------------
' https://tinyurl.com/bp59xy5d

Main()
STOP


' - Includes ----------------------------------------------
#INCLUDE <putchars.bas>
#INCLUDE <retrace.bas>
#INCLUDE "Ingrid.spr.bas"


' - Variables ---------------------------------------------
' Orientación de Ingrid (hacia donde mira) 1=derecha, 0=Izq
DIM orientacion AS UByte = 1
' Frame de la animación
DIM frame AS UByte = 0
' subFrame nos ayuda a ralentizar la animación
DIM subFrame AS UByte = 0
' Posición del sprite
DIM x, y AS UByte
' Indicador de movimiento, 1=camina, 0=parado
DIM caminando AS UByte


' - Subrutina principal -----------------------------------
SUB Main() 
    ' Almacenaremos la tecla pulsada en "k"
    DIM k AS String 
    
    ' Inicializamos las variables que controlan el sprite
    x = 14
    y = 10
    orientacion = 1
    caminando = 0
    frame = 0
    subFrame = 0
    
    ' Bucle infinito
    DO
        ' Esperamos el rayo
        waitretrace
        
        ' Miramos si está parado o se mueve
        IF caminando = 0 THEN
            ' Esta parado, imprimimos según la orientación
            IF orientacion = 1 THEN
                ' Está mirando a la derecha
                putChars(x,y,2,2,@Ingrid_Stand_right(frame,0))
            ELSE
                ' Mira a la izquierda
                putChars(x,y,2,2,@Ingrid_Stand_left(frame,0))
            END IF
            ' Incrementamos el subFrame
            subFrame = subFrame + 1
            IF subFrame >= 10 THEN
                ' Si subFrame es 10, incrementamos frame
                frame = frame + 1
                IF frame = 2 THEN
                    ' Si nos pasamos de frame, volvemos al 0
                    frame = 0
                END IF
                subFrame = 0
            END IF       
        ELSE            
            ' Está caminando, imprimimos según la orientación
            IF orientacion = 1 THEN
                ' Está caminando hacia la derecha
                ' Borramos la columna de la izquierda
                putChars(x,y,1,2,@Ingrid_Blanco(0))
                ' Si no ha llegado al borde, incrementamos x
                IF x < 30 THEN
                    x = x + 1
                END IF
                ' Imprimimos el sprite
                putChars(x,y,2,2,@Ingrid_Walk_right(frame,0))                
            ELSE
                ' Está caminando hacia la izquierda
                ' Borramos la columna de la izquierda
                putChars(x+1,y,1,2,@Ingrid_Blanco(0))
                ' Si no ha llegado al borde, decrementamos x
                IF x > 0 THEN
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
        END IF
        
        ' Leemos el teclado
        k = INKEY$
        ' Si se ha pulsado la tecla o
        IF k = "o" THEN
            ' Nos orientamos hacia la izquierda
            orientacion = 0
            ' Caminamos
            caminando = 1
        ELSEIF k = "p" THEN
            ' Nos orientamos hacia la derecha
            orientacion = 1
            ' Caminamos
            caminando = 1
        END IF
    LOOP
END SUB
