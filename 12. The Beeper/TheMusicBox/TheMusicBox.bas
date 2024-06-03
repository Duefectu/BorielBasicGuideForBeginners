' ---------------------------------------------------------
' - The Music Box Engine for Boriel -----------------------
' - Modified from Chris Cowley's code, which in turn is ---
' - based on the original by Mark Alexander ---------------
' ---------------------------------------------------------


' Playback state, 0=Stopped, 1=Playing
' only if we use the integrated interrupts
DIM Beepola_Status AS UByte


' - Start playing a song ----------------------
' Parameters:
'   songAddr (UInteger): Song address
SUB Beepola_Play(songAddr AS UInteger)
ASM
    push ix             ; Save ix
    
    xor a               ; Set status to STOP (0)
    ld (._Beepola_Status),a
    
    call BEEPOLA_START  ; Initialize Beepola 
    
    ld a,1              ; Set status to PLAY (1)
    ld (._Beepola_Status),a
    
    pop ix              ; Restore ix
END ASM
END SUB


' - Stops the playback of a song ----------------
' Only if we use integrated interrupts
SUB Beepola_Stop()
    ' Set status to STOP (0)
    Beepola_Status = 0
END SUB


' - Plays the next note ------------------------
' Only if we don't use integrated interrupts
SUB Beepola_NextNote()
ASM
    push ix
    call BEEPOLA_NEXTNOTE
    pop ix
END ASM
END Sub


' - Initializes the playback engine -----------
' Parameters:
'   borderColour (UByte): Border colour
'   useIM2 (UByte): 0=Do not use IM2
'                   1=Use internal IM2 (requires memory
'                      free from $fefe to $ff00)
Sub Beepola_Init(borderColour As UByte, useIM2 As UByte)
    ASM
    push ix

    ld a, (ix + 5)         ; Recover the borderColor parameter   
    ld(BORDER_COL),a   ; Set the border colour
    
    Xor a               ; Set status to STOP (0)
    ld(._Beepola_Status),a

    ld a, (ix + 7)         ; Recover the useIM2 parameter    
    And a               ; Activate flags    
    jp z, BEEPOLA_END    ; If A Is zero, we do Not initialize IM2

BEEPOLA_INITIM2:        ; Initialize IM2
BEEPOLA_IM2_JUMP    EQU     $fefe   ; IM2 Jump address

    di              ; Disable interrupts
    ; Build the vector table
    ld de, BEEPOLA_IM2_TABLE ; Table address
    ld hl, BEEPOLA_IM2_JUMP  ; Intermediate jump address
    ld a, d          ; Adjust the value of I
    ld i, a
    ld a, l          ; Fill the table with 257 bytes
BEEPOLA_NO_BUC:
    ld(de),a
    inc e
    jr nz, BEEPOLA_NO_BUC   
    inc d
    ld(de),a
    
    ; Set the intermediate jump address
    ld a,$c3        ; $C3 Is the code for JP in assembler
    ld(BEEPOLA_IM2_JUMP),a
    ld hl, BEEPOLA_IM2_TICK  ; Next 2 bytes for the address
    ld(BEEPOLA_IM2_JUMP + 1),hl
    
    im 2            ; Set interrupt mode to 2
    ei              ; Enable interrupts        
    jp BEEPOLA_END  ; Jump to the end to exit

    ; This will jump at each interrupt
BEEPOLA_IM2_TICK:
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

    ld a, (._Beepola_Status)       ; Recover the status
    And a                       ; If it's 0 (STOP), exit
    jr z, BEEPOLA_IM2_TICK_END

    Call Beepola_NextNote()       ; Play the Next note
   
BEEPOLA_IM2_TICK_END:
    ; Restore all registers
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
    reti            ; Exit interrupt

    ; Space for the interrupt vector table
    ; It must start at an address multiple of 256
    ALIGN 256       ; Align to 256
BEEPOLA_IM2_TABLE:
    defs 257, 0      ; Reserve 257 bytes with the value 0

; *****************************************************************************
; * The Music Box Player Engine
; *
; * Based on code written by Mark Alexander for the utility, The Music Box.
; * Modified by Chris Cowley
; *
; * Produced by Beepola v1.08.01
; ******************************************************************************
 
BEEPOLA_START:
                                                     ;     this to play a different song
                          LD   A, (HL)                         ; Get the loop start pointer
                          LD(PATTERN_LOOP_BEGIN),A
                          INC  HL
                          LD   A, (HL)                         ; Get the song end pointer
                          LD(PATTERN_LOOP_END),A
                          INC  HL
                          LD(PATTERNDATA1),HL
                          LD(PATTERNDATA2),HL
                          LD   A, 254
                          LD(PATTERN_PTR),A                ; Set the pattern pointer To zero
                          DI
    Call NEXT_PATTERN
    EI
    RET
BEEPOLA_NEXTNOTE:
    DI
    Call PLAYNOTE

    EI
    RET                                 ; Return from playing tune

PATTERN_PTR: DEFB 0
NOTE_PTR: DEFB 0

; ********************************************************************************************************
; * NEXT_PATTERN
; *
; * Select the next pattern in sequence (And handle looping if we've reached PATTERN_LOOP_END
; * Execution falls through to PLAYNOTE to play the first note from our next pattern
; ********************************************************************************************************
NEXT_PATTERN:
    LD   A, (PATTERN_PTR)
                          INC  A
                          INC  A
                          DEFB $FE                           ; CP n
PATTERN_LOOP_END: DEFB 0
                          JR   NZ, NO_PATTERN_LOOP
                          DEFB $3E                           ; LD A,n
PATTERN_LOOP_BEGIN: DEFB 0
                          POP  HL
                          EI
    RET
NO_PATTERN_LOOP: LD(PATTERN_PTR),A
			                    DEFB $21                            ; LD HL,nn
PATTERNDATA1: DEFW $0000
                          LD   E, A                            ; (this Is the first byte of the pattern)
                          LD   D, 0                            ; And store it at TEMPO
                          ADD  HL, DE
                          LD   E, (HL)
                          INC  HL
                          LD   D, (HL)
                          LD   A, (DE)                         ; Pattern Tempo -> A
                              LD(TEMPO),A                      ; Store it at TEMPO

                          LD   A, 1
                          LD(NOTE_PTR),A

PLAYNOTE:
    DEFB $21                            ; LD HL,nn
PATTERNDATA2: DEFW $0000
                          LD   A, (PATTERN_PTR)
                          LD   E, A
                          LD   D, 0
                          ADD  HL, DE
                          LD   E, (HL)
                          INC  HL
                          LD   D, (HL)                         ; Now DE = Start of Pattern data
                          LD   A, (NOTE_PTR)
                          LD   L, A
                          LD   H, 0
                          ADD  HL, DE                          ; Now HL = address of note data
                          LD   D, (HL)
                          LD   E, 1

; IF D = $0 then we are at the end of the pattern so increment PATTERN_PTR by 2 And set NOTE_PTR=0
                          LD   A, D
                          And  A                              ; Optimised CP 0
                          JR   Z, NEXT_PATTERN

                          PUSH DE
                          INC  HL
                          LD   D, (HL)
                          LD   E, 1

                          LD   A, (NOTE_PTR)
                          INC  A
                          INC  A
                          LD(NOTE_PTR),A                   ; Increment the note pointer by 2 (one note per chan)

                          POP  HL                             ; Now CH1 freq Is In HL, And CH2 freq Is in DE

                          LD   A, H
                          DEC  A
                          JR   NZ, OUTPUT_NOTE

                          LD   A, D                            ; executed only if Channel 2 contains a rest
                          DEC  A                              ; if DE (CH1 note) Is also a rest then..
                          JR   Z, PLAY_SILENCE                 ; Play silence

OUTPUT_NOTE: LD   A, (TEMPO)
                          LD   C, A
                          LD   B, 0
                          LD   A, (BORDER_COL)
                          EX   AF, AF'
    LD   A, (BORDER_COL)                   ; So now BC = TEMPO, A And A' = BORDER_COL
    LD   IXH, D
                          LD   D,$10
EAE5: NOP
    NOP
EAE7: EX   AF, AF'
    DEC  E
                          OUT($FE),A
                          JR   NZ, EB04

                          LD   E, IXH
                          Xor  D
                          EX   AF, AF'
    DEC  L
                          JP   NZ, EB0B

EAF5: OUT($FE),A
                          LD   L, H
                          Xor  D
                          DJNZ EAE5

                          INC  C
                          JP   NZ, EAE7

                          RET

EB04:
    JR   Z, EB04
                          EX   AF, AF'
    DEC  L
                          JP   Z, EAF5
EB0B:
    OUT($FE),A
                          NOP
    NOP
    DJNZ EAE5
                          INC  C
                          JP   NZ, EAE7
                          RET

PLAY_SILENCE:
    LD   A, (TEMPO)
                          CPL
    LD   C, A
SILENCE_LOOP2: PUSH BC
                          PUSH AF
                          LD   B, 0
SILENCE_LOOP: PUSH HL
                          LD   HL, 0
                          SRA(HL)
    SRA(HL)
    SRA(HL)
    NOP
    POP  HL
                          DJNZ SILENCE_LOOP
                          DEC  C
                          JP   NZ, SILENCE_LOOP
                          POP  AF
                          POP  BC
                          RET

; *** DATA ***
BORDER_COL: DEFB $0
TEMPO: DEFB 238

BEEPOLA_END:
    pop ix
End ASM

    Beepola_Status = Beepola_Status
End Sub
