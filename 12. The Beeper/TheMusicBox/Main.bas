' - TheMusicBox -------------------------------------------
' https://tinyurl.com/3ndtumxd

' Invoke the main subroutine
Main()
STOP


' - Includes ----------------------------------------------
#INCLUDE "TheMusicBox.bas"
#INCLUDE "Songs.bas"


' - Definitions ------------------------------------------
#DEFINE MAX_SONGS 2


' - Variables ---------------------------------------------
' Names of the songs
DIM Songs_Names(MAX_SONGS) AS String
' Addresses of the songs
DIM Songs_Address(MAX_SONGS) AS UInteger => { _
    @Song_Amelie, _
    @Song_Arp_chaos, _
    @Song_InTheHallOfTheMountainKing }


' - Main subroutine ---------------------------------------
SUB Main()
    ' Current song, starting at 0
    DIM song AS UByte = 0
    ' For the pressed key
    DIM k AS String
    ' To convert the key to a number
    DIM c AS UByte
    ' X coordinate and ball increment
    DIM x, i AS Byte
    
    ' Initialize the system
    Initialize()

    ' The ball starts at column 5
    x = 5
    ' And moves to the right
    i = 1
    
    ' Infinite loop
    DO
        ' Clear the screen
        CLS
        ' Print the current song
        PRINT AT 5,0; INK 6;"Playing:";
        PRINT AT 6,0; INK 7;Songs_Names(song);
        ' Play the current song
        Beepola_Play(Songs_Address(song))

        ' Show the list of songs
        PRINT AT 9,0;INK 5;"Select song";
        FOR n = 0 TO MAX_SONGS
            PRINT AT 10+n,0; INK n+2;n;"-";Songs_Names(n);
        NEXT n
        
        ' Selection loop
        DO
            ' Print the ball
            PRINT AT 20,x;" O ";
            ' Check if it's going to go out
            IF x > 0 AND x < 29 THEN
                ' If it's not going out, move
                x = x + i
            ELSE
                ' If it's going out, change direction
                i = i * -1
                x = x + i
            END IF

            ' Read the keyboard
            k = INKEY$
            IF k <> "" THEN
                ' Convert the key to a number
                c = val(k)
                ' If the key is between 0 and the maximum
                ' number of songs
                IF c >= 0 AND c <= MAX_SONGS THEN
                    ' Stop the current playback
                    Beepola_Stop()
                    ' Set the new song
                    song = c
                    ' Exit the selection loop
                    EXIT DO
                END IF
            END IF
        LOOP
    LOOP
END SUB


SUB Initialize()
    BORDER 0
    PAPER 0
    INK 6
    CLS
    
    ' Names of the songs
    Songs_Names(0) = "Amelie"
    Songs_Names(1) = "Arp chaos"
    Songs_Names(2) = "In the Hall of the Mountain King"
    
    ' Initialize The Music Box engine with interrupts
    Beepola_Init(0,1)
END SUB
