SUB FASTCALL Triptone_Play()
ASM
; *****************************************************************************
; * Tritone v2 Player (with equal channel volumes)
; *
; * By Shiru (shiru@mail.ru) 03'11
; *
; * Three channels of tone, per-pattern tempo
; * One channel of interrupting drums
; * Feel free to do whatever you want with the code, it is PD
; *
; * Produced by Beepola v1.08.01
; ******************************************************************************

OP_NOP          EQU   $00                 ; NOP opcode  (used for CHECK_KEMPSTON)
OP_SCF          EQU   $37                 ; SCF opcode  (used in CHECK_KEMPSTON)
OP_ORC          EQU   $b1                 ; OR C opcode (used in CHECK_KEMPSTON)

                LD    HL,MUSICDATA
                CALL  TRI_PLAY
                RET

TRI_PLAY:
                DI
                LD    (NEXT_POS_POS + 1),HL
                LD    C,16
                PUSH  IY
                EXX
                PUSH  HL
                LD    (PREV_SP+1),SP
                XOR   A
                LD    H,A
                LD    L,H
                LD    (CNT0 + 1),HL
                LD    (CNT1 + 1),HL
                LD    (CNT2 + 1),HL
                LD    (DUTY0 + 1),A
                LD    (DUTY1 + 1),A
                LD    (DUTY2 + 1),A
                LD    (SKIP_DRUM),A
                IN    A,($1F)
                AND   $1F
                LD    A,OP_NOP
                JR    NZ,SET_KEMPSTON
                LD    A,OP_ORC
SET_KEMPSTON:   LD    (CHECK_KEMPSTON),A
                JP    NEXT_POS

NEXT_ROW:
NEXT_ROW_POS:   LD    HL,0
                LD    A,(HL)
                INC   HL
                CP    2
                JR    C,CH0
                CP    128
                JR    C,DRUM_SOUND
                CP    255
                JP    Z,NEXT_POS
CH0:
                LD    D,1
                CP    D
                JR    Z,CH1
                OR    A
                JR    NZ,CH0_NOTE
                LD    B,A
                LD    C,A
                JR    CH0_SET
CH0_NOTE:       LD    E,A
                AND   $0F
                LD    B,A
                LD    C,(HL)
                INC   HL
                LD    A,E
                AND   $F0
CH0_SET:        LD    (DUTY0 + 1),A
                LD    (CNT0 + 1),BC
CH1:
                LD    A,(HL)
                INC   HL
                CP    D
                JR    Z,CH2
                OR    A
                JR    NZ,CH1_NOTE
                LD    B,A
                LD    C,A
                JR    CH1_SET
CH1_NOTE:       LD    E,A
                AND   $0F
                LD    B,A
                LD    C,(HL)
                INC   HL
                LD    A,E
                AND   $F0
CH1_SET:        LD    (DUTY1 + 1),A
                LD    (CNT1 + 1),BC
CH2:
                LD    A,(HL)
                INC   HL
                CP    D
                JR    Z,SKIP
                OR    A
                JR    NZ,CH2_NOTE
                LD    B,A
                LD    C,A
                JR    CH2_SET
CH2_NOTE:       LD    E,A
                AND   $0F
                LD    B,A
                LD    C,(HL)
                INC   HL
                LD    A,E
                AND   $F0
CH2_SET:        LD    (DUTY2 + 1),A
                LD    (CNT2 + 1),BC
SKIP:
                LD    (NEXT_ROW_POS + 1),HL
SKIP_DRUM:      SCF
                JP    NC,PLAY_ROW
                LD    A,OP_NOP
                LD    (SKIP_DRUM),A
                LD    HL,(TEMPO+1)
                LD    DE,65386                 ; DE = -150 
                ADD   HL,DE
                EX    DE,HL
                JR    C,DRM1
                LD    DE,257
DRM1:           LD    A,D
                OR    A
                JR    NZ,DRM2
                INC   D
DRM2:           LD    A,E
                OR    A
                JR    NZ,DRM3
                INC   E
DRM3:           JR    DRUM

DRUM_SOUND:     LD    (NEXT_ROW_POS + 1),HL
                ADD   A,A
                LD    IXL,A
                LD    IXH,0
                LD    BC,DRUM_SETTINGS - 4
                ADD   IX,BC
                CP    28                       ; 14 * 2
                LD    A,OP_SCF
                LD    (SKIP_DRUM),A
                JR    NC,DRUM_NOISE
DRUM_TONE:      LD    BC,2
                LD    A,B
                LD    DE,$1001
                LD    L,(IX+0)
DRUM_TONE_L0:   BIT   0,B
                JR    Z,DRUM_TONE_L1
                DEC   E
                JR    NZ,DRUM_TONE_L1
                LD    E,L
                EX    AF,AF'
                LD    A,L
                ADD   A,(IX + 1)
                LD    L,A
                EX    AF,AF'
                XOR   D
DRUM_TONE_L1:   OUT   ($FE),A
                DJNZ  DRUM_TONE_L0
                DEC   C
                JP    NZ,DRUM_TONE_L0
                JP    NEXT_ROW
DRUM_NOISE:     LD    B,0
                LD    H,B
                LD    L,H
                LD    DE,$1001
DRUM_NOISE_L0:  LD    A,(HL)
                AND   D
                OUT   ($FE),A
                AND   (IX+0)
                DEC   E
                OUT   ($FE),A
                JR    NZ,DRUM_NOISE_L1
                LD    E,(IX+1)
                INC   HL
DRUM_NOISE_L1:  DJNZ  DRUM_NOISE_L0
                JP    NEXT_ROW

NEXT_POS:
NEXT_POS_POS:   LD    HL,0
NEXT_POS_READ:  LD    E,(HL)
                INC   HL
                LD    D,(HL)
                INC   HL
                LD    A,D
                OR    E
                JR    Z,ORDER_LOOP
                LD    (NEXT_POS_POS+1),HL
                EX    DE,HL
                LD    C,(HL)
                INC   HL
                LD    B,(HL)
                INC   HL
                LD    (NEXT_ROW_POS+1),HL
                LD    (TEMPO+1),BC
                JP    NEXT_ROW

ORDER_LOOP:     LD    E,(HL)
                INC   HL
                LD    D,(HL)
                EX    DE,HL
                JR    NEXT_POS_READ

PLAY_ROW:
TEMPO:          LD    DE,0
DRUM:
CNT0:           LD    BC,0
PREV_HL:        LD    HL,0
                EXX
CNT1:           LD    DE,0
CNT2:           LD    SP,0
                EXX

SOUND_LOOP:
                ADD   HL,BC            ; 11 Ts
                LD    A,H              ;  4 Ts
                EXX                    ;  4 Ts
DUTY0:          CP    128              ;  7 Ts
                SBC   A,A              ;  4 Ts
                AND   C                ;  4 Ts
                ADD   IX,DE            ; 15 Ts
                OUT   ($FE),A          ; 11 Ts
                LD    A,IXH            ;  8 Ts
DUTY1:          CP    128              ;  7 Ts
                SBC   A,A              ;  4 Ts
                AND   C                ;  4 Ts
                OUT   ($FE),A          ; 11 Ts
                ADD   HL,SP            ; 11 Ts
                LD    A,H              ;  4 Ts
DUTY2:          CP    128              ;  7 Ts
                SBC   A,A              ;  4 Ts
                AND   C                ;  4 Ts
                EXX                    ;  4 Ts
                DEC   E                ;  4 Ts
                OUT   ($FE),A          ; 11 Ts
                JP    NZ,SOUND_LOOP    ; 10 Ts  = 153
                DEC   D                ;  4 Ts
                JP    NZ,SOUND_LOOP    ; 10 Ts
                XOR   A
                OUT   ($FE),A
                LD    (PREV_HL + 1),HL

                IN    A,($1F)
                AND   $1F
                LD    C,A
                XOR   A
                IN    A,($FE)
                CPL
CHECK_KEMPSTON: OR    C            ; This is set to NOP if no kempston i/f detected
                AND   $1F
                JP    Z,NEXT_ROW   ; Jump to next row unless key/joystick pressed

STOP_PLAYER:
PREV_SP:        LD    SP,0
                POP   HL
                EXX
                POP   IY
                EI
                RET

DRUM_SETTINGS:
                DEFB  $01,$01     ; 1: Tone, Highest
                DEFB  $01,$02
                DEFB  $01,$04
                DEFB  $01,$08
                DEFB  $01,$20
                DEFB  $20,$04
                DEFB  $40,$04
                DEFB  $40,$08     ; 8: Lowest
                DEFB  $04,$80     ; 9: Special
                DEFB  $08,$80
                DEFB  $10,$80
                DEFB  $10,$02
                DEFB  $20,$02
                DEFB  $40,$02
                DEFB  $16,$01     ; 15: Noise, Highest
                DEFB  $16,$02
                DEFB  $16,$04
                DEFB  $16,$08
                DEFB  $16,$10
                DEFB  $00,$01
                DEFB  $00,$02
                DEFB  $00,$04
                DEFB  $00,$08
                DEFB  $00,$10     ; 24: Last drum

; ************************************************************************
; * Song data...
; ************************************************************************
BORDER_CLR          EQU $0

; *** DATA ***
MUSICDATA:

; *** Song layout ***
LOOPSTART:            DEFW      PAT0
                      DEFW      PAT1
                      DEFW      PAT2
                      DEFW      PAT3
                      DEFW      PAT9
                      DEFW      PAT10
                      DEFW      PAT11
                      DEFW      PAT12
                      DEFW      PAT4
                      DEFW      PAT5
                      DEFW      PAT6
                      DEFW      PAT7
                      DEFW      PAT4
                      DEFW      PAT5
                      DEFW      PAT6
                      DEFW      PAT8
                      DEFW      PAT16
                      DEFW      PAT17
                      DEFW      PAT18
                      DEFW      PAT19
                      DEFW      PAT20
                      DEFW      PAT21
                      DEFW      PAT22
                      DEFW      PAT23
                      DEFW      PAT4
                      DEFW      PAT5
                      DEFW      PAT6
                      DEFW      PAT7
                      DEFW      PAT4
                      DEFW      PAT5
                      DEFW      PAT6
                      DEFW      PAT8
                      DEFW      PAT14
                      DEFW      PAT15
                      DEFW      $0000
                      DEFW      LOOPSTART

; *** Patterns ***
PAT0:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$01    ,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $82,$C3,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$83,$49,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$82,$C3,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$01    ,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $82,$C3,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$83,$49,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $82,$C3,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT1:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$01    ,$81,$D8,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $82,$31,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$82,$31,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$01    ,$81,$D8,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $82,$31,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $82,$31,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT2:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$01    ,$81,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $81,$D8,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$81,$D8,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$01    ,$81,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $81,$D8,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $81,$D8,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT3:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$01    ,$81,$A4,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $82,$11,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$82,$11,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$01    ,$81,$A4,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$80,$D2,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $04,$81,$08,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT4:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$81,$18,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$81,$A4,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$81,$61,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $81,$18,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$81,$61,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $81,$18,$81,$A4,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT5:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$EC,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$81,$61,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$81,$18,$82,$9B,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB  $02,$01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$EC,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$81,$18,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$EC,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT6:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$EC,$82,$ED,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$81,$18,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$80,$EC,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$BB,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$80,$EC,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$BB,$81,$D8,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT7:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$D2,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$81,$3B,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$81,$08,$82,$9B,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB  $02,$01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$D2,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$81,$08,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$D2,$82,$11,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT8:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$D2,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$81,$3B,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$81,$08,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$81,$3B,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $04,$01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT9:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$81,$18,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $82,$C3,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$83,$49,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$82,$C3,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$81,$18,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $82,$C3,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$83,$49,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $81,$18,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT10:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$EC,$81,$D8,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $82,$31,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$82,$31,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$80,$EC,$81,$D8,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $82,$31,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$EC,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT11:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$BB,$81,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $81,$D8,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$81,$D8,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$80,$BB,$81,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $81,$D8,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$BB,$81,$D8,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT12:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$D2,$81,$A4,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $82,$11,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$01    ,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$82,$11,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$80,$D2,$81,$A4,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $81,$3B,$01    ,$01
                DEFB  $03,$01    ,$01    ,$01
                DEFB  $02,$81,$08,$01    ,$01
                DEFB      $01    ,$82,$9B,$01
                DEFB  $FF  ; End of Pattern

PAT14:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $03,$81,$18,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT15:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT16:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$81,$18,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$82,$ED,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $81,$18,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$81,$08,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT17:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$EC,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$EC,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$D2,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT18:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$BB,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$82,$ED,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$B0,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$80,$BB,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT19:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$D2,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$82,$ED,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$83,$49,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$80,$D2,$84,$23,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $04,$81,$08,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT20:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$81,$18,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $81,$18,$01    ,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB  $04,$81,$18,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$81,$18,$82,$ED,$01
                DEFB  $03,$01    ,$01    ,$01
                DEFB      $81,$18,$82,$C3,$01
                DEFB  $03,$01    ,$01    ,$01
                DEFB  $03,$81,$18,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $04,$81,$18,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$81,$08,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT21:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$EC,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$EC,$01    ,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB  $04,$80,$EC,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$80,$EC,$82,$76,$01
                DEFB  $03,$01    ,$01    ,$01
                DEFB      $80,$EC,$82,$C3,$01
                DEFB  $04,$01    ,$01    ,$01
                DEFB  $02,$80,$EC,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $04,$80,$EC,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$80,$D2,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT22:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$BB,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$BB,$01    ,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB  $04,$80,$BB,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $03,$80,$BB,$82,$ED,$01
                DEFB  $03,$01    ,$01    ,$01
                DEFB      $80,$BB,$82,$C3,$01
                DEFB  $03,$01    ,$01    ,$01
                DEFB  $03,$80,$BB,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $04,$80,$B0,$82,$31,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $02,$80,$BB,$82,$76,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $FF  ; End of Pattern

PAT23:
                DEFW  3692     ; Pattern tempo
                ;    Drum,Chan.1 ,Chan.2 ,Chan.3
                DEFB  $02,$80,$D2,$82,$C3,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$D2,$01    ,$01
                DEFB      $01    ,$82,$C3,$01
                DEFB  $04,$80,$D2,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$80,$D2,$82,$ED,$01
                DEFB      $01    ,$01    ,$01
                DEFB  $05,$81,$A4,$83,$49,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $01    ,$01    ,$01
                DEFB      $80,$D2,$84,$23,$01
                DEFB  $03,$01    ,$01    ,$01
                DEFB  $02,$81,$08,$01    ,$01
                DEFB      $01    ,$82,$76,$01
                DEFB  $FF  ; End of Pattern
END ASM
END SUB
