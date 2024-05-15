' ---------------------------------------------------------
' - Motor The Music Box para Boriel -----------------------
' - Modificado sobre el código de Chris Cowley, que a su
' - vez se basa en el original de Mark Alexander 
' ---------------------------------------------------------


' Estado de reproducción, 0=Parado, 1=Reproduciendo
' solo si utilizamos las interrupciones integradas
DIM Beepola_Status AS UByte


' - Empieza a reproducir una canción ----------------------
' Parámetros:
'   songAddre (UInteger): Dirección de la canción
SUB Beepola_Play(songAddr AS UInteger)
ASM
    push ix             ; Guardamos ix
    
    xor a               ; Ponemos el estado a STOP (0)
    ld (._Beepola_Status),a
    
    call BEEPOLA_START  ; Inicializamos Beepola 
    
    ld a,1              ; Ponemos el estado a PLAY (1)
    ld (._Beepola_Status),a
    
    pop ix              ; Recuperamos ix
END ASM
END SUB


' - Detiene la reproducción de una canción ----------------
' Solo si utilizamos las interrupciones integradas
SUB Beepola_Stop()
    ' Ponemos el estado a STOP (0)
    Beepola_Status = 0
END SUB


' - Reproduce la siguiente nota ---------------------------
' Solo si no utilizamos las interrupciones integradas
SUB Beepola_NextNote()
ASM
    push ix
    call BEEPOLA_NEXTNOTE
    pop ix
END ASM
END SUB


' - Inicializa el motor de reproducción -------------------
' Parámetros:
'   colorBorde (UByte): Color del borde
'   usarIM2 (UByte): 0=No usar IM2
'                    1=Usar IM2 interno (requiere memoria
'                      libre de $fefe a $ff00)
SUB Beepola_Init(colorBorde AS UByte, usarIM2 AS UByte)
ASM
    push ix
    
    ld a,(ix+5)         ; Recuperamos el parámetro colorBorde   
    ld (BORDER_COL),a   ; Ajustamos el color del borde
    
    xor a               ; Ponemos el estado a STOP (0)
    ld (._Beepola_Status),a

    ld a,(ix+7)         ; Recuperamos el parámetro usarIM2    
    and a               ; Activamos los flags    
    jp z,BEEPOLA_FIN    ; Si A es cero, no iniciamos IM2

BEEPOLA_INITIM2:        ; Inicializamos IM2
BEEPOLA_IM2_JUMP    EQU     $fefe   ; Dirección de salto IM2

    di              ; Deshabilitamos las interrupciones
    ; Construimos la tabla de vectores
    ld de,BEEPOLA_IM2_TABLE ; Dirección de la tabla
    ld hl,BEEPOLA_IM2_JUMP  ; Dirección de salto intermedio
    ld a,d          ; Ajustamos el valor de I
    ld i,a
    ld a,l          ; Rellenamos la tabla con 257 bytes
BEEPOLA_NO_BUC:
    ld (de),a
    inc e
    jr nz,BEEPOLA_NO_BUC   
    inc d
    ld (de),a
    
    ; En la dirección de salto intermedio colocamos un
    ; JP BEEPOLA_IM2_JUMP
    ld a,$c3        ; $C3 es el código de JP en assembler
    ld (BEEPOLA_IM2_JUMP),a
    ld hl,BEEPOLA_IM2_TICK  ; 2 bytes para la dirección
    ld (BEEPOLA_IM2_JUMP+1),hl
    
    im 2            ; Ajustamos el modo de interrupción a 2
    ei              ; Activamos las interrupciones        
    jp BEEPOLA_FIN  ; Saltamos al final para salir

    ; Aquí saltará en cada interrupción
BEEPOLA_IM2_TICK:
    ; Guardamos todos los registros
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
    
    ld a,(._Beepola_Status)       ; Recuperamos el estado
    and a                       ; Si es 0 (STOP) salimos
    jr z,BEEPOLA_IM2_TICK_END
    
    call BEEPOLA_NEXTNOTE       ; Tocamos la siguiente nota
   
BEEPOLA_IM2_TICK_END:
    ; Recuperamos todos los registros que hemos guardado
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
        
    ei              ; Activamos las interrupciones
    reti            ; Salimos de la interrupción

    ; Espacio para la tabla de vectores de interrupción
    ; Debe empezar en una dirección múltiplo de 256
    ALIGN 256       ; Alineamos a 256
BEEPOLA_IM2_TABLE:
    defs 257,0      ; Reservamos 257 bytes con el valor 0
 
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
                          LD   A,(HL)                         ; Get the loop start pointer
                          LD   (PATTERN_LOOP_BEGIN),A
                          INC  HL
                          LD   A,(HL)                         ; Get the song end pointer
                          LD   (PATTERN_LOOP_END),A
                          INC  HL
                          LD   (PATTERNDATA1),HL
                          LD   (PATTERNDATA2),HL
                          LD   A,254
                          LD   (PATTERN_PTR),A                ; Set the pattern pointer to zero
                          DI
                          CALL  NEXT_PATTERN
                          EI
                          RET
BEEPOLA_NEXTNOTE:
                          DI
                          CALL  PLAYNOTE

                          EI
                          RET                                 ; Return from playing tune

PATTERN_PTR:              DEFB 0
NOTE_PTR:                 DEFB 0

; ********************************************************************************************************
; * NEXT_PATTERN
; *
; * Select the next pattern in sequence (and handle looping if we've reached PATTERN_LOOP_END
; * Execution falls through to PLAYNOTE to play the first note from our next pattern
; ********************************************************************************************************
NEXT_PATTERN:
                          LD   A,(PATTERN_PTR)
                          INC  A
                          INC  A
                          DEFB $FE                           ; CP n
PATTERN_LOOP_END:         DEFB 0
                          JR   NZ,NO_PATTERN_LOOP
                          DEFB $3E                           ; LD A,n
PATTERN_LOOP_BEGIN:       DEFB 0
                          POP  HL
                          EI
                          RET
NO_PATTERN_LOOP:          LD   (PATTERN_PTR),A
			                    DEFB $21                            ; LD HL,nn
PATTERNDATA1:             DEFW $0000
                          LD   E,A                            ; (this is the first byte of the pattern)
                          LD   D,0                            ; and store it at TEMPO
                          ADD  HL,DE
                          LD   E,(HL)
                          INC  HL
                          LD   D,(HL)
                          LD   A,(DE)                         ; Pattern Tempo -> A
	                	      LD   (TEMPO),A                      ; Store it at TEMPO

                          LD   A,1
                          LD   (NOTE_PTR),A

PLAYNOTE: 
			                    DEFB $21                            ; LD HL,nn
PATTERNDATA2:             DEFW $0000
                          LD   A,(PATTERN_PTR)
                          LD   E,A
                          LD   D,0
                          ADD  HL,DE
                          LD   E,(HL)
                          INC  HL
                          LD   D,(HL)                         ; Now DE = Start of Pattern data
                          LD   A,(NOTE_PTR)
                          LD   L,A
                          LD   H,0
                          ADD  HL,DE                          ; Now HL = address of note data
                          LD   D,(HL)
                          LD   E,1

; IF D = $0 then we are at the end of the pattern so increment PATTERN_PTR by 2 and set NOTE_PTR=0
                          LD   A,D
                          AND  A                              ; Optimised CP 0
                          JR   Z,NEXT_PATTERN

                          PUSH DE
                          INC  HL
                          LD   D,(HL)
                          LD   E,1

                          LD   A,(NOTE_PTR)
                          INC  A
                          INC  A
                          LD   (NOTE_PTR),A                   ; Increment the note pointer by 2 (one note per chan)

                          POP  HL                             ; Now CH1 freq is in HL, and CH2 freq is in DE

                          LD   A,H
                          DEC  A
                          JR   NZ,OUTPUT_NOTE

                          LD   A,D                            ; executed only if Channel 2 contains a rest
                          DEC  A                              ; if DE (CH1 note) is also a rest then..
                          JR   Z,PLAY_SILENCE                 ; Play silence

OUTPUT_NOTE:              LD   A,(TEMPO)
                          LD   C,A
                          LD   B,0
                          LD   A,(BORDER_COL)
                          EX   AF,AF'
                          LD   A,(BORDER_COL)                   ; So now BC = TEMPO, A and A' = BORDER_COL
                          LD   IXH,D
                          LD   D,$10
EAE5:                     NOP
                          NOP
EAE7:                     EX   AF,AF'
                          DEC  E
                          OUT  ($FE),A
                          JR   NZ,EB04

                          LD   E,IXH
                          XOR  D
                          EX   AF,AF'
                          DEC  L
                          JP   NZ,EB0B

EAF5:                     OUT  ($FE),A
                          LD   L,H
                          XOR  D
                          DJNZ EAE5

                          INC  C
                          JP   NZ,EAE7

                          RET

EB04:
                          JR   Z,EB04
                          EX   AF,AF'
                          DEC  L
                          JP   Z,EAF5
EB0B:
                          OUT  ($FE),A
                          NOP
                          NOP
                          DJNZ EAE5
                          INC  C
                          JP   NZ,EAE7
                          RET

PLAY_SILENCE:
                          LD   A,(TEMPO)
                          CPL
                          LD   C,A
SILENCE_LOOP2:            PUSH BC
                          PUSH AF
                          LD   B,0
SILENCE_LOOP:             PUSH HL
                          LD   HL,0000
                          SRA  (HL)
                          SRA  (HL)
                          SRA  (HL)
                          NOP
                          POP  HL
                          DJNZ SILENCE_LOOP
                          DEC  C
                          JP   NZ,SILENCE_LOOP
                          POP  AF
                          POP  BC
                          RET

; *** DATA ***
BORDER_COL:               DEFB $0
TEMPO:                    DEFB 238

BEEPOLA_FIN:
    pop ix
END ASM

    Beepola_Status = Beepola_Status
END SUB
