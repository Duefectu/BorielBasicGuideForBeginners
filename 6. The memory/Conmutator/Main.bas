' - Conmutator ---------------------------------------------
' http://tinyurl.com/bdhxrazb 

' Declare the GetSlot3 function
Declare FUNCTION GetSlot3() AS UByte

DIM n AS UByte

CLS

' Loop through 8 memory banks (8 x 16k = 128k)
FOR n = 0 TO 7
    ' Place bank "n" in slot 3
    SetSlot3(n)
    ' Write the number "n" at the beginning of
    ' slot 3 ($c000)
    POKE $c000, n
NEXT n

' Now check if it went well
FOR n = 0 TO 7
    ' Place bank "n" in slot 3
    SetSlot3(n)
    ' Print "n"
    PRINT "Bank: "; n;
    ' Print the bank in slot 3 according to BANKM
    PRINT ", BANKM: "; GetSlot3();
    ' Value at memory address $C000
    PRINT ", $C000: "; PEEK($c000)
NEXT n

' - Switch the specified bank into slot 3 -----------------
' Parameters:
'   bank (UByte): Bank to place in slot 3 (0-7)
SUB FASTCALL SetSlot3(bank AS UByte)
ASM
    ld d, a         ; With FASTCALL, bank is placed in A
    ld a, ($5b5c)   ; Read BANKM
    and %11111000   ; Reset the first 3 bits
    or d            ; Adjust the first 3 bits with the
                    ; "bank"
    ld bc, $7ffd    ; Port where we will perform the OUT
    di              ; Disable interrupts
    ld ($5b5c), a   ; Update BANKM
    out (c), a      ; Perform the OUT
    ei              ; Enable interrupts
END ASM
END SUB

'- Get the Slot3 page from BANKM ---------------------------
' Output:
'   UByte: Bank in slot 3 according to BANKM (0-7)
FUNCTION GetSlot3() AS UByte
    RETURN PEEK $5b5c AND %111
END FUNCTION
