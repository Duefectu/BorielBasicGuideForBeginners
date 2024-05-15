
MUSICDATA:
                    DEFB 0   ; Loop start point * 2
                    DEFB 16   ; Song Length * 2
PATTERNDATA:        DEFW      PAT0
                    DEFW      PAT1
                    DEFW      PAT0
                    DEFW      PAT2
                    DEFW      PAT3
                    DEFW      PAT4
                    DEFW      PAT3
                    DEFW      PAT5

; *** Pattern data consists of pairs of frequency values CH1,CH2 with a single $0 to
; *** Mark the end of the pattern, and $01 for a rest
PAT0:
         DEFB 238  ; Pattern tempo
             DEFB 48,192
             DEFB 48,1
             DEFB 43,1
             DEFB 43,1
             DEFB 40,128
             DEFB 40,1
             DEFB 36,1
             DEFB 36,1
             DEFB 32,192
             DEFB 32,1
             DEFB 40,1
             DEFB 40,1
             DEFB 32,128
             DEFB 32,1
         DEFB $0
PAT1:
         DEFB 238  ; Pattern tempo
             DEFB 32,1
             DEFB 32,1
             DEFB 34,192
             DEFB 34,1
             DEFB 43,1
             DEFB 43,1
             DEFB 34,128
             DEFB 34,1
             DEFB 34,1
             DEFB 34,1
             DEFB 36,192
             DEFB 36,1
             DEFB 45,1
             DEFB 45,1
             DEFB 36,128
             DEFB 36,1
             DEFB 36,1
             DEFB 36,1
         DEFB $0
PAT2:
         DEFB 238  ; Pattern tempo
             DEFB 24,1
             DEFB 24,1
             DEFB 27,161
             DEFB 27,1
             DEFB 32,1
             DEFB 32,1
             DEFB 40,108
             DEFB 40,1
             DEFB 32,1
             DEFB 32,1
             DEFB 27,161
             DEFB 27,1
             DEFB 27,1
             DEFB 27,1
             DEFB 27,108
             DEFB 27,1
             DEFB 27,1
             DEFB 27,1
         DEFB $0
PAT3:
         DEFB 238  ; Pattern tempo
             DEFB 128,255
             DEFB 128,1
             DEFB 114,1
             DEFB 114,1
             DEFB 102,171
             DEFB 102,1
             DEFB 96,1
             DEFB 96,1
             DEFB 86,255
             DEFB 86,1
             DEFB 102,1
             DEFB 102,1
             DEFB 86,171
             DEFB 86,1
         DEFB $0
PAT4:
         DEFB 238  ; Pattern tempo
             DEFB 86,1
             DEFB 86,1
             DEFB 81,161
             DEFB 81,1
             DEFB 102,1
             DEFB 102,1
             DEFB 81,203
             DEFB 81,1
             DEFB 81,1
             DEFB 81,1
             DEFB 86,255
             DEFB 86,1
             DEFB 102,1
             DEFB 102,1
             DEFB 86,171
             DEFB 86,1
             DEFB 86,1
             DEFB 86,1
         DEFB $0
PAT5:
         DEFB 238  ; Pattern tempo
             DEFB 86,1
             DEFB 86,1
             DEFB 81,161
             DEFB 81,1
             DEFB 102,1
             DEFB 102,1
             DEFB 81,203
             DEFB 81,1
             DEFB 81,1
             DEFB 81,1
             DEFB 86,255
             DEFB 86,1
             DEFB 86,1
             DEFB 86,1
             DEFB 86,171
             DEFB 86,1
             DEFB 86,1
             DEFB 86,1
         DEFB $0
