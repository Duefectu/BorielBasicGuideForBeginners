' - Horizon ----------------------------------------------
' https://tinyurl.com/5t4rhs28

' Declare two variables for use within IM2CallMyRoutine
' These variables must be global
' Counter for wasting time
Dim im2_Counter AS UInteger
' Height of the horizon
DIM im2_Horizon AS UInteger = 400

' Call the Main subroutine
Main()

' - Main subroutine --------------------------------------
SUB Main()   
    CLS
    
    ' Set up and start interrupts
    SetUpIM2()
    
    ' Infinite loop
    DO
        ' Print the current height of the horizon
        PRINT AT 0,0;im2_Horizon;"  ";
        ' If "q" is pressed, raise the horizon
        IF INKEY$ = "q" THEN
            ' Raise it as long as it's not 0
            IF im2_Horizon > 0 THEN
                ' Raising means less pause
                im2_Horizon = im2_Horizon - 1
            END IF
        ' If "a" is pressed, lower the horizon
        ELSEIF INKEY$ = "a" THEN
            ' Lowering means more pause
            im2_Horizon = im2_Horizon + 1
        END IF
    LOOP   
END SUB

' - This is our routine called every 20ms ---------------
' We can't do many things inside
' No local variable definitions, no using ROM,
' don't linger too long...
SUB FASTCALL MyInterruptRoutine()
    ' The sky is cyan
    BORDER 5
    ' Wait to change from sky to ground
    FOR im2_Counter = 0 TO im2_Horizon
    NEXT im2_Counter
    ' The ground is green
    BORDER 4
END SUB

' - Initializes the interrupt system ---------------------
SUB SetUpIM2()
cls
ASM
IM2_JUMP    EQU     $fefe   ; Intermediate jump address

    di              ; Disable interrupts
    ; Build the vector table
    ld de,IM2_Table ; Table address
    ld hl,IM2_JUMP  ; Intermediate jump address
    ld a,d          ; Adjust the value of I
    ld i,a
    ld a,l          ; Fill the table with 257 bytes
NO_LOOP:
    ld (de),a
    inc e
    jr nz,NO_LOOP    
    inc d
    ld (de),a
    
    ; At the intermediate jump address, place a
    ; JP IM2_JUMP
    ld a,$c3        ; $C3 is the JP code in assembly
    ld (IM2_JUMP),a
    ld hl,IM2_Tick  ; Next 2 bytes for the address
    ld (IM2_JUMP+1),hl
    
    im 2            ; Set interrupt mode to 2
    ei              ; Enable interrupts        
    jp IM2_END      ; Jump to end to exit

    ; Here it will jump at each interrupt
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
    
END ASM

    ' Here we put our ASM or Basic routine
    ' In this case, we jump to a Basic subroutine
    MyInterruptRoutine()    ' Call MyInterruptRoutine
    
ASM
    ; Retrieve all saved registers
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
IM2_Table:
    defs 257,0      ; Reserve 257 bytes with value 0

IM2_END:            ; Exit SetUpIM2
    END ASM
END SUB
