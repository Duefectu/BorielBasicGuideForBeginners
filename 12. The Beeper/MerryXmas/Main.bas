' - MerryXmas ---------------------------------------------
' https://tinyurl.com/5dvzebd2

' 52 notes = 52 x 2 = 104 (-1 as it starts from 0)
' We use one line for each 3/4 bar
' First value is duration, second is pitch (128 for pause)
' Use duration = 1 for Eight note
DIM Christmas(103) AS Integer = { _
    2,14, _
    2,18, 1,18, 1,20, 1,18, 1,17, _
    2,15, 2,15, 2,15, _
    2,20, 1,20, 1,22, 1,20, 1,18, _
    2,17, 2,14, 2,14, _
    2,22, 1,22, 1,23, 1,22, 1,20, _
    2,18, 2,15, 1,14, 1,14, _
    2,15, 2,20, 2,17, _
    4,18, 2,14, _
    2,18, 2,18, 2,18, _
    4,17, 2,17, _
    2,18, 2,17, 2,15, _
    4,14, 2,14, _
    2,22, 2,20, 2,18, _
    2,25, 2,14, 1,14, 1,14, _
    2,15, 2,20, 2,17, _
    4,18 }

DIM n AS UByte          ' Counter
DIM duration AS Fixed   ' Note duration  
DIM pitch AS Byte       ' Note pitch
' Define a tempo of 0.214 = 30 / 140
DIM tempo AS Fixed = 0.214
' A variable for conversion to PAUSE
DIM pauseTempo AS Fixed
' This variable stores the lyrics
DIM lyrics AS String

' Clear the screen
CLS

' Print the title
PRINT "Karaoke: Merry Christmas"
PRINT "------------------------"
PRINT ""

' Calculate pause time
' One unit in PAUSE is 0.02 seconds
pauseTempo = tempo / .02

' Set READ pointer to the "LyricsData" label
RESTORE LyricsData

' Loop to go through the entire song
FOR n = 0 TO 103 STEP 2
    ' Read the lyrics of the song
    READ lyrics
    ' Print the lyrics of the song
    PRINT lyrics;

    ' Read raw duration
    duration = Christmas(n)    
    ' Read the pitch
    pitch = Christmas(n+1) 
    ' If pitch is 128, it's a pause
    IF pitch = 128 THEN        
        ' Use PAUSE (20 ms per unit)
        ' 0.020 x 21.45 = 0.429
        PAUSE duration * pauseTempo
    ' If it's not a pause
    ELSE
        ' Play the duration * 0.429 and the pitch
        BEEP duration * tempo, pitch
    END IF
    
    ' If any key is pressed, stop everything
    IF INKEY$ <> "" THEN
        STOP
    END IF
NEXT n


LyricsData:
' Lyrics of the song, one element per note
DATA "We "
DATA "wish ","you ","a ", "Mer", "ry "
' Code 013 is carriage return
DATA "Christ","mas,\#013","we "
DATA "wish ","you ","a ", "Mer", "ry "
DATA "Christ","mas,\#013","we "
DATA "wish ","you ","a ", "Mer", "ry " 
DATA "Christ","mas\#013","and ","a "
DATA "Hap","py ","New "
DATA "Year.\#013","Good "
DATA "ti", "dings ","we "
DATA "bring ","to\#013"
DATA "you ","and ","your ","kin,\#013","good "
DATA "ti","dings ","for "
DATA "Christ","mas\#013","and ", "a "
DATA "Hap","py ","New "," Year!"
