' - Gestión del doble buffer ------------------------------

' Solo se compila si hemos definido DOUBLE_BUFFER
#IFDEF DOUBLE_BUFFER

' - Espacio reservado para el doble buffer ----------------
' Doble buffer de los pixels
DobleBuffer_Pixels:   
    ASM
        defs 6144   ; 6144 bytes para pixels
    END ASM

' Doble buffer de los atributos    
DoubleBuffer_Atributos:
    ASM
        defs 768    ; 768 bytes para atributos
    END ASM


' - Desvia la impresión al buffer -------------------------
SUB ActivarBuffer()
    ' Fija la dirección del buffer de pixels
    SetScreenBufferAddr(@DobleBuffer_Pixels)
    ' Fija la dirección del buffer de atributos
    SetAttrBufferAddr(@DoubleBuffer_Atributos)
END SUB


' - Restaura la impresión hacia la pantalla principal -----
SUB DesactivarBuffer()
    ' Fija la dirección de los pixels a su pos. original
    SetScreenBufferAddr($4000)
    ' Fila la dirección de los atributos a su pos. original
    SetAttrBufferAddr($5800)
END SUB


' - Copia el buffer sobre la pantalla principal -----------
SUB BufferAPantalla()
    ' Esperamos la introducción para sincronizar el barrido
    waitretrace
    ' Copiamos desde double buffer los dos primeros tercios
    ' de la pantalla (el marcador no se toca)
    MemCopy(@DobleBuffer_Pixels,$4000,4096)
END SUB

#ENDIF