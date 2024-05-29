' - Beepola DEMO ------------------------------------------
' - Music Module -------------------------------------------

DIM Music_Playing AS UByte

' - Initializes music playback ----------------------------
SUB FASTCALL Music_Init()
    ' Call MUSIC_START from the Music Box engine
ASM
    call MUSIC_START
END ASM
    ' Initialize our interrupt system
    SetUpIM2()
END SUB

' - Starts playing the music --------------------------------
SUB Music_Play()
    Music_Playing = 1
END SUB

' - Stops the music -----------------------------------------
SUB Music_Stop()
    Music_Playing = 0
END SUB

' - Initializes the interrupt system ------------------------
SUB SetUpIM2()
ASM
IM2_JUMP    EQU     $fefe   ; Intermediate jump address

    di              ; Disable interrupts
    ; Build the vector table
    ld de,IM2_Table ; Table address
    ld hl,IM2_JUMP  ; Intermediate jump address
    ld a,d          ; Adjust I value
    ld i,a
    ld a,l          ; Fill the table with 257 bytes
NO_LOOP:
    ld (de),a
    inc e
    jr nz,NO_LOOP    
    inc d
    ld (de),a
    
    ; Place JP IM2_JUMP at the intermediate jump address
    ld a,$c3        ; $C3 is JP opcode in assembler
    ld (IM2_JUMP),a
    ld hl,IM2_Tick  ; Next 2 bytes for the address
    ld (IM2_JUMP+1),hl
    
    im 2            ; Set interrupt mode to 2
    ei              ; Enable interrupts        
    jp IM2_END      ; Jump to end to exit

    ; This code will execute on each interrupt
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
    
    ; If Music_Playing variable is 0, music is not played
    ld a,[_Music_Playing]
    and a
    jr z,IM2_Mute
    
    ; Call NEXTNOTE from the Music Box engine to play the next note
    call NEXTNOTE

IM2_Mute:

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

    ; Space for the interrupt vector table
    ; It should start at an address multiple of 256
    ALIGN 256       ; Align to 256
IM2_Table:
    defs 257,0      ; Reserve 257 bytes with the value 0

IM2_END:            ; Exit SetUpIM2
    END ASM
END SUB
