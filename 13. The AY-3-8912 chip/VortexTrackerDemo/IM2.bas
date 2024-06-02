' - Interrupt Management Library --------------------------

' - Initializes the interrupt engine ----------------------
' Parameters:
'   address (UInteger): Address to jump to at
'                       each interrupt.
SUB FASTCALL IM2_Initialize(address AS UInteger)
ASM
    push ix             ; Save ix
    ld (IM2_SubAddress),hl  ; Save jump address
    
    di                  ; Disable interrupts
    ld hl,IM2_Table-256 ; End of table address
    ld a,h              ; Adjust I value to end of table
    ld i,a
    
    ld hl,IM2_Tick      ; Set IM2_Tick address
    ld a,l              ; At end of table
    ld (IM2_Table-1),a
    ld a,h
    ld (IM2_Table),a    

    im 2                ; Set interrupt mode to 2
    ei                  ; Enable interrupts
    jp IM2_End          ; Jump to end to exit

IM2_Tick:
    ; Save all registers
    push af
    push hl
    push bc
    push de
    push ix
    push iy
    exx
    ex af, af'
    push af
    push hl
    push bc
    push de
    
    ld hl,IM2_Tick_End      ; Set return address
    push hl
    ld hl,(IM2_SubAddress)  ; Jump to our routine
    jp (hl)

IM2_Tick_End:
    ; Restore all saved registers
    pop de
    pop bc
    pop hl
    pop af
    ex af, af'
    exx
    pop iy
    pop ix
    pop de
    pop bc
    pop hl
    pop af
        
    ei              ; Enable interrupts
    reti            ; Return from interrupt

    ; Space for interrupt vector table
    ; Must start at a multiple of 256
    
    db 0            ; First jump value is at $ff
    ALIGN 256       ; Align to 256
IM2_Table:
    db 0            ; Second jump value is at $00
IM2_SubAddress:
    defw 0          ; Address of subroutine to call
    
IM2_End:
    pop ix          ; Restore ix to exit
END ASM
END SUB


SUB IM2_Stop()
ASM
    di              ; Disable interrupts
    im 1            ; Set IM 1 interrupts
    ei              ; Enable interrupts
END ASM
END SUB
