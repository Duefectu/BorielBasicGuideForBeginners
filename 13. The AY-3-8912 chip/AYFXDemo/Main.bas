' - AYFXDemo ----------------------------------------------
' https://tinyurl.com/5fte6kft

Main()
STOP


' - Includes ----------------------------------------------
#INCLUDE <input.bas>
#INCLUDE <retrace.bas>
#INCLUDE "AYFXPlayer.bas"


' - Effects Bank -------------------------------------------
EffectsBank:
ASM
    incbin "test.afb"
END ASM


' - Main Subroutine ----------------------------------------
SUB Main()
    DIM effectNumber AS String
    DIM n AS UByte

    ' Initialize the sound effects engine
    AYFX_Init(@EffectsBank)

    ' Infinite loop
    DO
        ' Clear the screen
        CLS
        ' Print the screen
        PRINT AT 0,14;"AYFX Demo";
        PRINT AT 2,0;"Effect number: ";
        ' Ask the user for the effect code
        effectNumber = input(3)
        ' Start playing the effect
        AYFX_Play(VAL(effectNumber))

        ' To play the effect, you need to call
        ' AYFX_PlayFrame every 20ms or on each interrupt
        PRINT AT 4,0;"Playing effect: ";effectNumber;
        ' We will play the first 128 steps of the sound
        FOR n = 0 TO 127
            ' Print the counter
            PRINT AT 4,25;n;
            ' Wait for an interrupt
            waitretrace
            ' Execute the current step
            AYFX_PlayFrame()
        NEXT n
    LOOP
END SUB
