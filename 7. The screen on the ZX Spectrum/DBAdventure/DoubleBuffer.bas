' - Double Buffer Management ------------------------------

' Only compiles if DOUBLE_BUFFER is defined
#IFDEF DOUBLE_BUFFER

' - Space reserved for the double buffer -------------------
' Double buffer for pixels
DobleBuffer_Pixels:
    ASM
        defs 6144   ; 6144 bytes for pixels
    END ASM

' Double buffer for attributes    
DoubleBuffer_Attributes:
    ASM
        defs 768    ; 768 bytes for attributes
    END ASM


' - Redirects printing to the buffer -----------------------
SUB ActivateBuffer()
    ' Set the address of the pixel buffer
    SetScreenBufferAddr(@DobleBuffer_Pixels)
    ' Set the address of the attribute buffer
    SetAttrBufferAddr(@DoubleBuffer_Attributes)
END SUB


' - Restores printing to the main screen -------------------
SUB DeactivateBuffer()
    ' Set pixels address to original position
    SetScreenBufferAddr($4000)
    ' Set attributes address to original position
    SetAttrBufferAddr($5800)
END SUB


' - Copies the buffer onto the main screen -----------------
SUB BufferToScreen()
    ' Wait for retrace to synchronize scanning
    waitretrace
    ' Copy from double buffer the first two thirds
    ' of the screen (the border is not touched)
    MemCopy(@DobleBuffer_Pixels,$4000,4096)
END SUB

#ENDIF
