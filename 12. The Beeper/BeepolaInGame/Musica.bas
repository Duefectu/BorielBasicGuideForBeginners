' - Beepola DEMO ------------------------------------------
' - Módulo de música --------------------------------------

DIM Music_Playing AS UByte

' - Inicia la reproducción de la música -------------------
SUB FASTCALL Music_Init()
    ' Llamamos a MUSIC_START del motor Music Box
ASM
    call MUSIC_START
END ASM
    ' Inicializamos nuestro sistema de interrupciones
    SetUpIM2()
END SUB


' - Hace que la música suene ------------------------------
SUB Music_Play()
    Music_Playing = 1
END SUB


' - Para la música ----------------------------------------
SUB Music_Stop()
    Music_Playing = 0
END SUB

' - Inicializa el sistema de interrupciones ---------------
SUB SetUpIM2()
ASM
IM2_JUMP    EQU     $fefe   ; Dirección de salto intermedio

    di              ; Deshabilitamos las interrupciones
    ; Construimos la tabla de vectores
    ld de,IM2_Table ; Dirección de la tabla
    ld hl,IM2_JUMP  ; Dirección de salto intermedio
    ld a,d          ; Ajustamos el valor de I
    ld i,a
    ld a,l          ; Rellenamos la tabla con 257 bytes
NO_BUC:
    ld (de),a
    inc e
    jr nz,NO_BUC    
    inc d
    ld (de),a
    
    ; En la dirección de salto intermedio colocamos un
    ; JP IM2_JUMP
    ld a,$c3        ; $C3 es el código de JP en assembler
    ld (IM2_JUMP),a
    ld hl,IM2_Tick  ; 2 bytes siguientes para la dirección
    ld (IM2_JUMP+1),hl
    
    im 2            ; Ajustamos el modo de interrupción a 2
    ei              ; Activamos las interrupciones        
    jp IM2_FIN      ; Saltamos al final para salir

    ; Aquí saltará en cada interrupción
IM2_Tick:
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
    
    ; Si la variable Music_Playing es 0, no reproduce música
    ld a,[_Music_Playing]
    and a
    jr z,IM2_Mute
    
    ; Llamamos a NEXTNOTE del motor Music Box para que
    ; toque la siguiente nota
    call NEXTNOTE

IM2_Mute:

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
IM2_Table:
    defs 257,0      ; Reservamos 257 bytes con el valor 0

IM2_FIN:            ; Salimos de SetUpIM2
    END ASM
END SUB
