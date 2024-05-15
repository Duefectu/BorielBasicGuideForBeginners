' - Inicializa el motor The Music Box ---------------------
SUB FASTCALL TheMusicBox_Init()
ASM
    push ix
    call TMB_START
    pop ix
END ASM
END SUB


' - Toca la siguiente nota --------------------------------
SUB FASTCALL TheMusicBox_PlayNote()
ASM
    PROC
    LOCAL TEMPO, MUSICDATA, PAT0, PAT1, PAT2, PAT3, PAT4, PAT5, PAT7, PAT8
    
    push ix
    call TMB_NEXTNOTE
    pop ix
    
    jp TMB_FIN

; *****************************************************************************
; * The Music Box Player Engine
; *
; * Based on code written by Mark Alexander for the utility, The Music Box.
; * Modified by Chris Cowley
; *
; * Produced by Beepola v1.08.01
; ******************************************************************************
 
TMB_START:
                          LD    HL,MUSICDATA         ;  <- Pointer to Music Data. Change
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
TMB_NEXTNOTE:
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
                          LD   A,BORDER_COL
                          EX   AF,AF'
                          LD   A,BORDER_COL                   ; So now BC = TEMPO, A and A' = BORDER_COL
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
BORDER_COL                EQU $0
TEMPO:                    DEFB 250

MUSICDATA:
                    DEFB 0   ; Loop start point * 2
                    DEFB 24   ; Song Length * 2
PATTERNDATA:        DEFW      PAT0
                    DEFW      PAT1
                    DEFW      PAT0
                    DEFW      PAT1
                    DEFW      PAT2
                    DEFW      PAT3
                    DEFW      PAT7
                    DEFW      PAT8
                    DEFW      PAT4
                    DEFW      PAT5
                    DEFW      PAT4
                    DEFW      PAT5

; *** Pattern data consists of pairs of frequency values CH1,CH2 with a single $0 to
; *** Mark the end of the pattern, and $01 for a rest
PAT0:
         DEFB 250  ; Pattern tempo
             DEFB 151,1
             DEFB 151,1
             DEFB 151,1
             DEFB 151,1
             DEFB 151,1
             DEFB 151,1
             DEFB 151,1
             DEFB 1,1
             DEFB 61,40
             DEFB 51,40
             DEFB 61,40
             DEFB 51,40
             DEFB 1,38
             DEFB 1,38
             DEFB 1,38
             DEFB 1,38
             DEFB 61,34
             DEFB 51,34
             DEFB 61,34
             DEFB 51,34
             DEFB 1,30
             DEFB 1,30
             DEFB 1,30
             DEFB 1,30
             DEFB 151,34
             DEFB 151,34
             DEFB 151,34
             DEFB 151,34
             DEFB 151,34
             DEFB 151,34
             DEFB 151,34
             DEFB 1,34
             DEFB 61,34
             DEFB 51,34
             DEFB 61,34
             DEFB 51,34
             DEFB 1,34
             DEFB 1,34
             DEFB 1,34
             DEFB 1,34
             DEFB 61,34
             DEFB 51,34
             DEFB 61,34
             DEFB 51,34
             DEFB 1,34
             DEFB 1,34
             DEFB 1,34
             DEFB 1,34
             DEFB 151,1
             DEFB 151,1
             DEFB 151,1
             DEFB 151,1
             DEFB 151,1
             DEFB 151,1
             DEFB 151,1
             DEFB 1,1
             DEFB 61,40
             DEFB 51,40
             DEFB 61,40
             DEFB 51,40
             DEFB 1,38
             DEFB 1,38
             DEFB 1,38
             DEFB 1,38
             DEFB 61,34
             DEFB 51,34
             DEFB 61,34
             DEFB 51,34
             DEFB 1,30
             DEFB 1,30
             DEFB 1,30
             DEFB 1,30
             DEFB 151,34
             DEFB 151,34
             DEFB 151,34
             DEFB 151,34
             DEFB 151,34
             DEFB 151,34
             DEFB 151,34
             DEFB 1,34
             DEFB 61,38
             DEFB 51,38
             DEFB 61,38
             DEFB 51,38
             DEFB 1,38
             DEFB 1,38
             DEFB 1,38
             DEFB 1,38
             DEFB 61,38
             DEFB 51,38
             DEFB 61,38
             DEFB 51,38
             DEFB 1,40
             DEFB 1,40
             DEFB 1,40
             DEFB 1,40
         DEFB $0
PAT1:
         DEFB 250  ; Pattern tempo
             DEFB 192,43
             DEFB 192,43
             DEFB 192,43
             DEFB 192,43
             DEFB 192,43
             DEFB 192,43
             DEFB 192,43
             DEFB 1,43
             DEFB 76,43
             DEFB 64,43
             DEFB 76,43
             DEFB 64,43
             DEFB 1,43
             DEFB 1,43
             DEFB 1,43
             DEFB 1,43
             DEFB 76,43
             DEFB 64,43
             DEFB 76,43
             DEFB 64,43
             DEFB 1,43
             DEFB 1,43
             DEFB 1,43
             DEFB 1,43
             DEFB 192,48
             DEFB 192,48
             DEFB 192,48
             DEFB 192,48
             DEFB 192,48
             DEFB 192,48
             DEFB 192,48
             DEFB 1,48
             DEFB 76,48
             DEFB 64,48
             DEFB 76,48
             DEFB 64,48
             DEFB 1,48
             DEFB 1,48
             DEFB 1,48
             DEFB 1,48
             DEFB 76,48
             DEFB 64,48
             DEFB 76,48
             DEFB 64,48
             DEFB 1,48
             DEFB 1,48
             DEFB 1,48
             DEFB 1,48
             DEFB 192,51
             DEFB 192,51
             DEFB 192,51
             DEFB 192,51
             DEFB 192,51
             DEFB 192,51
             DEFB 192,51
             DEFB 1,51
             DEFB 76,51
             DEFB 64,51
             DEFB 76,51
             DEFB 64,51
             DEFB 1,51
             DEFB 1,51
             DEFB 1,51
             DEFB 1,51
             DEFB 76,51
             DEFB 64,51
             DEFB 76,51
             DEFB 64,51
             DEFB 1,51
             DEFB 1,51
             DEFB 1,51
             DEFB 1,51
             DEFB 192,48
             DEFB 192,48
             DEFB 192,48
             DEFB 192,48
             DEFB 192,48
             DEFB 192,48
             DEFB 192,48
             DEFB 1,48
             DEFB 76,48
             DEFB 64,48
             DEFB 76,48
             DEFB 64,48
             DEFB 1,48
             DEFB 1,48
             DEFB 1,48
             DEFB 1,48
             DEFB 76,48
             DEFB 64,48
             DEFB 76,48
             DEFB 64,48
             DEFB 1,48
             DEFB 1,48
             DEFB 1,48
             DEFB 1,48
         DEFB $0
PAT2:
         DEFB 250  ; Pattern tempo
             DEFB 151,40
             DEFB 151,20
             DEFB 151,40
             DEFB 151,20
             DEFB 151,40
             DEFB 151,20
             DEFB 151,40
             DEFB 1,20
             DEFB 61,40
             DEFB 51,20
             DEFB 61,40
             DEFB 51,20
             DEFB 1,40
             DEFB 1,20
             DEFB 1,40
             DEFB 1,20
             DEFB 61,40
             DEFB 51,20
             DEFB 61,40
             DEFB 51,20
             DEFB 1,40
             DEFB 1,20
             DEFB 1,40
             DEFB 1,20
             DEFB 151,38
             DEFB 151,19
             DEFB 151,38
             DEFB 151,19
             DEFB 151,38
             DEFB 151,19
             DEFB 151,38
             DEFB 1,19
             DEFB 61,38
             DEFB 51,19
             DEFB 61,38
             DEFB 51,19
             DEFB 1,38
             DEFB 1,19
             DEFB 1,38
             DEFB 1,19
             DEFB 61,38
             DEFB 51,19
             DEFB 61,38
             DEFB 51,19
             DEFB 1,38
             DEFB 1,19
             DEFB 1,38
             DEFB 1,19
             DEFB 151,34
             DEFB 151,17
             DEFB 151,34
             DEFB 151,17
             DEFB 151,34
             DEFB 151,17
             DEFB 151,34
             DEFB 1,17
             DEFB 61,34
             DEFB 51,17
             DEFB 61,34
             DEFB 51,17
             DEFB 1,34
             DEFB 1,17
             DEFB 1,34
             DEFB 1,17
             DEFB 61,34
             DEFB 51,17
             DEFB 61,34
             DEFB 51,17
             DEFB 1,34
             DEFB 1,17
             DEFB 1,34
             DEFB 1,17
             DEFB 151,30
             DEFB 151,15
             DEFB 151,30
             DEFB 151,15
             DEFB 151,30
             DEFB 151,15
             DEFB 151,30
             DEFB 1,15
             DEFB 61,30
             DEFB 51,15
             DEFB 61,30
             DEFB 51,15
             DEFB 1,30
             DEFB 1,15
             DEFB 1,30
             DEFB 1,15
             DEFB 61,30
             DEFB 51,15
             DEFB 61,30
             DEFB 51,15
             DEFB 1,30
             DEFB 1,15
             DEFB 1,30
             DEFB 1,15
         DEFB $0
PAT3:
         DEFB 250  ; Pattern tempo
             DEFB 192,51
             DEFB 192,25
             DEFB 192,51
             DEFB 192,25
             DEFB 192,51
             DEFB 192,25
             DEFB 192,51
             DEFB 1,25
             DEFB 76,51
             DEFB 64,25
             DEFB 76,51
             DEFB 64,25
             DEFB 1,51
             DEFB 1,25
             DEFB 1,51
             DEFB 1,25
             DEFB 76,51
             DEFB 64,25
             DEFB 76,51
             DEFB 64,25
             DEFB 1,51
             DEFB 1,25
             DEFB 1,51
             DEFB 1,25
             DEFB 192,48
             DEFB 192,24
             DEFB 192,48
             DEFB 192,24
             DEFB 192,48
             DEFB 192,24
             DEFB 192,48
             DEFB 1,24
             DEFB 76,48
             DEFB 64,24
             DEFB 76,48
             DEFB 64,24
             DEFB 1,48
             DEFB 1,24
             DEFB 1,48
             DEFB 1,24
             DEFB 76,48
             DEFB 64,24
             DEFB 76,48
             DEFB 64,24
             DEFB 1,48
             DEFB 1,24
             DEFB 1,48
             DEFB 1,24
             DEFB 192,43
             DEFB 192,21
             DEFB 192,43
             DEFB 192,21
             DEFB 192,43
             DEFB 192,21
             DEFB 192,43
             DEFB 1,21
             DEFB 76,43
             DEFB 64,21
             DEFB 76,43
             DEFB 64,21
             DEFB 1,43
             DEFB 1,21
             DEFB 1,43
             DEFB 1,21
             DEFB 76,43
             DEFB 64,21
             DEFB 76,43
             DEFB 64,21
             DEFB 1,43
             DEFB 1,21
             DEFB 1,43
             DEFB 1,21
             DEFB 192,38
             DEFB 192,19
             DEFB 192,38
             DEFB 192,19
             DEFB 192,38
             DEFB 192,19
             DEFB 192,38
             DEFB 1,19
             DEFB 76,38
             DEFB 64,19
             DEFB 76,38
             DEFB 64,19
             DEFB 1,38
             DEFB 1,19
             DEFB 1,38
             DEFB 1,19
             DEFB 76,38
             DEFB 64,19
             DEFB 76,38
             DEFB 64,19
             DEFB 1,38
             DEFB 1,19
             DEFB 1,38
             DEFB 1,20
         DEFB $0
PAT4:
         DEFB 250  ; Pattern tempo
             DEFB 151,20
             DEFB 151,20
             DEFB 151,20
             DEFB 151,1
             DEFB 151,19
             DEFB 151,1
             DEFB 151,19
             DEFB 1,1
             DEFB 121,20
             DEFB 102,1
             DEFB 121,20
             DEFB 102,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 121,20
             DEFB 102,1
             DEFB 121,20
             DEFB 102,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 151,23
             DEFB 151,23
             DEFB 151,23
             DEFB 151,1
             DEFB 151,19
             DEFB 151,1
             DEFB 151,19
             DEFB 1,1
             DEFB 121,23
             DEFB 102,1
             DEFB 121,23
             DEFB 102,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 121,23
             DEFB 102,1
             DEFB 121,23
             DEFB 102,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 151,25
             DEFB 151,25
             DEFB 151,25
             DEFB 151,1
             DEFB 151,19
             DEFB 151,1
             DEFB 151,19
             DEFB 1,1
             DEFB 121,25
             DEFB 102,1
             DEFB 121,25
             DEFB 102,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 121,25
             DEFB 102,1
             DEFB 121,25
             DEFB 102,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 151,28
             DEFB 151,28
             DEFB 151,28
             DEFB 151,1
             DEFB 151,19
             DEFB 151,1
             DEFB 151,19
             DEFB 1,1
             DEFB 121,28
             DEFB 102,1
             DEFB 121,28
             DEFB 102,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 121,30
             DEFB 102,1
             DEFB 121,30
             DEFB 102,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
         DEFB $0
PAT5:
         DEFB 250  ; Pattern tempo
             DEFB 192,21
             DEFB 192,21
             DEFB 192,21
             DEFB 192,1
             DEFB 192,19
             DEFB 192,1
             DEFB 192,19
             DEFB 1,1
             DEFB 151,21
             DEFB 128,1
             DEFB 151,21
             DEFB 128,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 151,21
             DEFB 128,1
             DEFB 151,21
             DEFB 128,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 192,24
             DEFB 192,24
             DEFB 192,24
             DEFB 192,1
             DEFB 192,19
             DEFB 192,1
             DEFB 192,19
             DEFB 1,1
             DEFB 151,24
             DEFB 128,1
             DEFB 151,24
             DEFB 128,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 151,24
             DEFB 128,1
             DEFB 151,24
             DEFB 128,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 192,25
             DEFB 192,25
             DEFB 192,25
             DEFB 192,1
             DEFB 192,19
             DEFB 192,1
             DEFB 192,19
             DEFB 1,1
             DEFB 151,25
             DEFB 128,1
             DEFB 151,25
             DEFB 128,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 151,25
             DEFB 128,1
             DEFB 151,25
             DEFB 128,1
             DEFB 1,19
             DEFB 1,1
             DEFB 1,19
             DEFB 1,1
             DEFB 192,24
             DEFB 192,24
             DEFB 192,24
             DEFB 192,1
             DEFB 192,32
             DEFB 192,1
             DEFB 192,32
             DEFB 1,1
             DEFB 151,27
             DEFB 128,1
             DEFB 151,27
             DEFB 128,1
             DEFB 1,25
             DEFB 1,1
             DEFB 1,25
             DEFB 1,1
             DEFB 151,24
             DEFB 128,1
             DEFB 151,24
             DEFB 128,1
             DEFB 1,21
             DEFB 1,1
             DEFB 1,21
             DEFB 1,1
         DEFB $0
PAT7:
         DEFB 250  ; Pattern tempo
             DEFB 151,40
             DEFB 151,20
             DEFB 151,40
             DEFB 151,20
             DEFB 151,40
             DEFB 151,20
             DEFB 151,40
             DEFB 1,20
             DEFB 61,40
             DEFB 51,20
             DEFB 61,40
             DEFB 51,20
             DEFB 1,40
             DEFB 1,20
             DEFB 1,40
             DEFB 1,20
             DEFB 61,40
             DEFB 51,20
             DEFB 61,40
             DEFB 51,20
             DEFB 1,40
             DEFB 1,20
             DEFB 1,40
             DEFB 1,19
             DEFB 151,38
             DEFB 151,19
             DEFB 151,38
             DEFB 151,19
             DEFB 151,38
             DEFB 151,19
             DEFB 151,38
             DEFB 1,19
             DEFB 61,38
             DEFB 51,19
             DEFB 61,38
             DEFB 51,19
             DEFB 1,38
             DEFB 1,19
             DEFB 1,38
             DEFB 1,19
             DEFB 61,38
             DEFB 51,19
             DEFB 61,38
             DEFB 51,19
             DEFB 1,38
             DEFB 1,19
             DEFB 1,38
             DEFB 1,17
             DEFB 151,34
             DEFB 151,17
             DEFB 151,34
             DEFB 151,17
             DEFB 151,34
             DEFB 151,17
             DEFB 151,34
             DEFB 1,17
             DEFB 61,34
             DEFB 51,17
             DEFB 61,34
             DEFB 51,17
             DEFB 1,34
             DEFB 1,17
             DEFB 1,34
             DEFB 1,17
             DEFB 61,34
             DEFB 51,17
             DEFB 61,34
             DEFB 51,17
             DEFB 1,34
             DEFB 1,17
             DEFB 1,34
             DEFB 1,15
             DEFB 151,30
             DEFB 151,15
             DEFB 151,30
             DEFB 151,15
             DEFB 151,30
             DEFB 151,15
             DEFB 151,30
             DEFB 1,15
             DEFB 61,30
             DEFB 51,15
             DEFB 61,30
             DEFB 51,15
             DEFB 1,30
             DEFB 1,15
             DEFB 1,30
             DEFB 1,15
             DEFB 61,30
             DEFB 51,15
             DEFB 61,30
             DEFB 51,15
             DEFB 1,30
             DEFB 1,15
             DEFB 1,30
             DEFB 1,15
         DEFB $0
PAT8:
         DEFB 250  ; Pattern tempo
             DEFB 192,51
             DEFB 192,25
             DEFB 192,51
             DEFB 192,25
             DEFB 192,51
             DEFB 192,25
             DEFB 192,51
             DEFB 1,25
             DEFB 76,51
             DEFB 64,25
             DEFB 76,51
             DEFB 64,25
             DEFB 1,51
             DEFB 1,25
             DEFB 1,51
             DEFB 1,25
             DEFB 76,51
             DEFB 64,25
             DEFB 76,51
             DEFB 64,25
             DEFB 1,51
             DEFB 1,25
             DEFB 1,51
             DEFB 1,24
             DEFB 192,48
             DEFB 192,24
             DEFB 192,48
             DEFB 192,24
             DEFB 192,48
             DEFB 192,24
             DEFB 192,48
             DEFB 1,24
             DEFB 76,48
             DEFB 64,24
             DEFB 76,48
             DEFB 64,24
             DEFB 1,48
             DEFB 1,24
             DEFB 1,48
             DEFB 1,24
             DEFB 76,48
             DEFB 64,24
             DEFB 76,48
             DEFB 64,24
             DEFB 1,48
             DEFB 1,24
             DEFB 1,48
             DEFB 1,21
             DEFB 192,43
             DEFB 192,21
             DEFB 192,43
             DEFB 192,21
             DEFB 192,43
             DEFB 192,21
             DEFB 192,43
             DEFB 1,21
             DEFB 76,43
             DEFB 64,21
             DEFB 76,43
             DEFB 64,21
             DEFB 1,43
             DEFB 1,21
             DEFB 1,43
             DEFB 1,21
             DEFB 76,43
             DEFB 64,21
             DEFB 76,43
             DEFB 64,21
             DEFB 1,43
             DEFB 1,21
             DEFB 1,43
             DEFB 1,19
             DEFB 192,38
             DEFB 192,19
             DEFB 192,38
             DEFB 192,19
             DEFB 192,38
             DEFB 192,19
             DEFB 192,38
             DEFB 1,19
             DEFB 76,38
             DEFB 64,19
             DEFB 76,38
             DEFB 64,19
             DEFB 1,38
             DEFB 1,19
             DEFB 1,38
             DEFB 1,19
             DEFB 76,38
             DEFB 64,19
             DEFB 76,38
             DEFB 64,19
             DEFB 1,38
             DEFB 1,19
             DEFB 1,38
             DEFB 1,19
         DEFB $0
TMB_FIN:         
    ENDP
END ASM
END SUB
