' - PIANO ---------------------------------------------
' - Módulo para el control del teclado ----------------


' - Control del teclado -------------------------------
SUB ControlTeclado()
    ' Control de la octava ----------------------------
    ' Si se ha pulsado 9...
    IF Multikeys(KEY9) THEN
        ' Si el flag anti-rebote no está activo...
        IF rOctava = 0 THEN
            ' Si la octava es mayor de 0...
            IF octava > 0 THEN
                ' Restamos uno a la octava actual
                octava = octava - 1
                ' Marcamos el flag anti-rebote
                rOctava = 1
            END IF
        END IF
    ' Si se ha pulsado 0...
    ELSEIF Multikeys(KEY0) THEN
        ' Si el flag anti-rebote no está activo...
        IF rOctava = 0 THEN
            ' Si la octava es menor de 3...
            IF octava < 3 THEN
                ' Añadimos uno a la octava
                octava = octava + 1
                ' Marcamos el flag anti-rebote
                rOctava = 1
            END IF
        END IF
    ' Si no se ha pulsado ni 9 ni 0...
    ELSE
        ' Reseteamos el flag anti-rebote
        rOctava = 0
    END IF     
 ' Control de volumen ------------------------------
    ' Si no hay forma de onda... 
    IF onda = 0 THEN
        ' Si se ha pulsado O...
        IF Multikeys(KEYO) THEN
            ' Si el flag anti-rebote no está activo...
            IF rVolumen = 0 THEN
                ' Si el volumen no es 0...
                IF volumen > 0 THEN
                    ' Decrementamos el volumen
                    volumen = volumen - 1
                    ' Activamos el falg anti-rebote
                    rVolumen = 1
                    ' Flag de volumen modificado
                    mVolumen = 1
                END IF
            END IF
        ' Si se ha pulsado P...
        ELSEIF Multikeys(KEYP) THEN
            ' Si el flag anti-rebote no está activo...
            IF rVolumen = 0 THEN
                ' Si el volumen es menor de 15
                IF volumen < 15 THEN
                    ' Incrementamos el volumen
                    volumen = volumen + 1
                    ' Activamos el falg anti-rebote
                    rVolumen = 1
                    ' Flag de volumen modificado
                    mVolumen = 1
                END IF
            END IF
        ' Si no se ha pulsado ni O ni P...
        ELSE
            ' Reseteamos el flag anti-rebote
            rVolumen = 0
        END IF
    END IF
    ' Control de la forma de onda ---------------------
    ' Si se ha pulsado la tecla K...
    IF Multikeys(KEYK) THEN
        ' Si el flag anti-rebote no está activo...
        IF rOnda = 0 THEN
            ' Si el tipo de onda no es cero
            IF onda > 0 THEN
                ' Decrementamos el tipo de onda
                onda = onda - 1
                ' Activamos el falg anti-rebote 
                rOnda = 1
            END IF
            ' Si la forma de onda es 0...
            IF onda = 0 THEN
                ' Restauramos el volumen original
                volumen = volumen2
            END IF
        END IF
    ' Si se ha pulsado la tecla L...
    ELSEIF Multikeys(KEYL) THEN 
        ' Si el flag anti-rebote no está activo...
        IF rOnda = 0 THEN
            ' Si la forma de onda es menor de 8
            IF onda < 8 THEN
                ' Incrementamos la forma de onda
                onda = onda + 1
                ' Activamos el falg anti-rebote
                rOnda = 1
            END IF
        END IF
    ' Si no se ha pulsado ni K ni L...
    ELSE 
        ' Reseteamos el flag anti-rebote
        rOnda = 0
    END IF
    ' Control de la frecuencia ------------------------
    ' Solo se controla si hay un tipo de onda definido
    IF onda <> 0 THEN
        ' Si estamos pulsando CAPS SHIFT...
        IF Multikeys(KEYCAPS) THEN
            ' Si se pulsa O + CAPS SHIFT...
            IF Multikeys(KEYO) THEN
                ' Si el flag anti-rebote no está activo.. 
                IF rFrecuencia = 0 THEN
                    ' Si la frecuencia es mayor de 0
                    IF frecuencia > 0 THEN
                        ' Decrementamos la frecuencia
                        frecuencia = frecuencia - 1
                        ' Activamos el falg anti-rebote
                        rFrecuencia = 1
                    END IF
                END IF
            ' Si se pulsa P + CAPS SHIFT... 
            ELSEIF Multikeys(KEYP) THEN
                ' Si el flag anti-rebote no está activo..
                IF rFrecuencia = 0 THEN
                    ' Si la frecuencia es menor de 65534
                    IF frecuencia < 65564 THEN
                        ' Incrementamos la frecuencia
                        frecuencia = frecuencia + 1
                        ' Activamos el falg anti-rebote
                        rFrecuencia = 1
                    END IF
                END IF
            ' Si no se ha pulsado CAPS SHIFT + O no P...
            ELSE
                ' Reseteamos el flag anti-rebote
                rFrecuencia = 0
            END IF 
        ' Si no se está pulsando CAPS SHIFT...
        ELSE
            ' Si se ha pulsado O...
            IF Multikeys(KEYO) THEN
                ' Ignoramos el flag anti-rebote
                ' Si la frecuencia es mayor de 0...
                IF frecuencia > 0 THEN
                    ' Decrementamos la frecuencia
                    frecuencia = frecuencia - 1
                END IF
            ' Si se ha pulsado P...
            ELSEIF Multikeys(KEYP) THEN
                ' Ignoramos el flag anti-rebote
                ' Si la frecuencia es menor de 65564...
                IF frecuencia < 65564 THEN
                    ' Incrementamos la frecuencia
                    frecuencia = frecuencia + 1
                END IF
            ELSE
                ' Reseteamos el flag anti-rebote
                rFrecuencia = 0
            END IF 
        END IF
    END IF
    
    ' Control de tipo de instrumento ------------------
    ' Si se ha pulsado 1...
    IF Multikeys(KEY1) THEN
        ' Si el flag anti-rebote no está activo..
        IF rTipo = 0 THEN            
            ' Si el tipo es 2...
            IF tipo = 2 THEN
                ' El tipo será 0
                tipo = 0
            ' Si el tipo no es 2
            ELSE
                ' Incrementamos el tipo
                tipo = tipo + 1
            END IF
            ' Marcamos el volumen como modificado
            mVolumen = 1
            ' Activamos el falg anti-rebote
            rTipo = 1
        END IF
    ELSE
        ' Reseteamos el flag anti-rebote
        rTipo = 0
    END IF    
END SUB