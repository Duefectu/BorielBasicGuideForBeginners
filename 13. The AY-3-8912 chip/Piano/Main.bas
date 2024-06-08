' - Piano -------------------------------------------------
' https://tinyurl.com/898s89d7

Main()
STOP


' - Includes ----------------------------------------------
' Boriel Libraries
#INCLUDE <keys.bas>
' Resources
#INCLUDE "Piano.fnt.bas"
#INCLUDE "Waves.udg.bas"


' - Defines -----------------------------------------------
' AY-3-8912 chip ports
#DEFINE AY_CONTROL 65533
#DEFINE AY_DATA 49149
' AY-3-8912 chip registers
#DEFINE AY_A_FINEPITCH 0
#DEFINE AY_A_COARSEPITCH 1
#DEFINE AY_B_FINEPITCH 2
#DEFINE AY_B_COARSEPITCH 3
#DEFINE AY_C_FINEPITCH 4
#DEFINE AY_C_COARSEPITCH 5
#DEFINE AY_NOISEPITCH 6
#DEFINE AY_MIXER 7
#DEFINE AY_A_VOLUME 8
#DEFINE AY_B_VOLUME 9
#DEFINE AY_C_VOLUME 10
#DEFINE AY_ENVELOPE_FINE 11
#DEFINE AY_ENVELOPE_COURSE 12
#DEFINE AY_ENVELOPE_SHAPE 13
#DEFINE AY_PORT_A 14
#DEFINE AY_PORT_B 15


' - Variables ---------------------------------------------
' Musical notes frequencies
Dim Music_Notes(59, 1) As UByte => { _
    { $06, $af }, _     ' C2   1711 0
    { $06, $4e }, _     ' C#2  1614 1
    { $05, $f4 }, _     ' D2   1524 2
    { $05, $9e }, _     ' D#2  1438 3
    { $05, $4e }, _     ' E2   1358 4
    { $05, $01 }, _     ' F2   1281 5
    { $04, $ba }, _     ' F#2  1210 6
    { $04, $76 }, _     ' G2   1142 7
    { $04, $36 }, _     ' G#2  1078 8
    { $03, $f9 }, _     ' A2   1017 9
    { $03, $c0 }, _     ' A#2  960  10
    { $03, $8a }, _     ' B2   906  11
_
    { $03, $57 }, _     ' C3   855  12
    { $03, $27 }, _     ' C#3  807  13
    { $02, $fa }, _     ' D3   762  14
    { $02, $cf }, _     ' D#3  719  15
    { $02, $a7 }, _     ' E3   679  16
    { $02, $81 }, _     ' F3   641  17
    { $02, $5d }, _     ' F#3  605  18
    { $02, $3b }, _     ' G3   571  19
    { $02, $1b }, _     ' G#3  539  20
    { $01, $fd }, _     ' A3   509  21
    { $01, $e0 }, _     ' A#3  480  22
    { $01, $c5 }, _     ' B3   453  23
_
    { $01, $ac }, _     ' C4   428  24
    { $01, $94 }, _     ' C#4  404  25
    { $01, $7d }, _     ' D4   381  26
    { $01, $68 }, _     ' D#4  360  27
    { $01, $53 }, _     ' E4   339  28
    { $01, $40 }, _     ' F4   320  29
    { $01, $2e }, _     ' F#4  302  30
    { $01, $1d }, _     ' G4   285  31
    { $01, $0d }, _     ' G#4  269  32
    { $00, $fe }, _     ' A4   254  33
    { $00, $f0 }, _     ' A#4  240  34
    { $00, $e3 }, _     ' B4   227  35
_
    { $00, $d6 }, _     ' C5   214  36
    { $00, $ca }, _     ' C#5  202  37
    { $00, $be }, _     ' D5   190  38
    { $00, $b4 }, _     ' D#5  180  39
    { $00, $aa }, _     ' E5   170  40
    { $00, $a0 }, _     ' F5   160  41
    { $00, $97 }, _     ' F#5  151  42
    { $00, $8f }, _     ' G5   143  43
    { $00, $87 }, _     ' G#5  135  44
    { $00, $7f }, _     ' A5   127  45
    { $00, $78 }, _     ' A#5  120  46
    { $00, $71 }, _     ' B5   113  47  
_
    { $00, $6b }, _     ' C6   107  48
    { $00, $65 }, _     ' C#6  101  49
    { $00, $5f }, _     ' D6   95   50
    { $00, $5a }, _     ' D#6  90   51
    { $00, $55 }, _     ' E6   85   52
    { $00, $50 }, _     ' F6   80   53
    { $00, $4c }, _     ' F#6  76   54
    { $00, $47 }, _     ' G6   71   55
    { $00, $43 }, _     ' G#6  67   56
    { $00, $40 }, _     ' A6   64   57
    { $00, $3c }, _     ' A#6  60   58
    { $00, $39 } _      ' B6   57   59  
}
' Piano keyboard keys
Dim Keys(23) As UInteger => { _
    KEYZ, KEYS, KEYX, KEYD, KEYC, KEYV, _
    KEYG, KEYB, KEYH, KEYN, KEYJ, KEYM, _
    KEYQ, KEY2, KEYW, KEY3, KEYE, KEYR, _
    KEY5, KEYT, KEY6, KEYY, KEY7, KEYU _
}
' Note names
Dim notation(12) As String
' AY-3-8912 chip waveform types
Dim waveTypes(8) As String
' AY-3-8912 chip waveform type identifiers
Dim WaveIds(8) As UByte => {255, 0, 4, 8, 10, 11, 12, 13, 14}
' Current note and octave, and number of pressed keys
Dim note, octave, numNotes As UByte
' Volume, copy of volume, waveform, and instrument
Dim volume, volume2, wave, type As UByte
' Prevents key bounce
Dim rOctave, rVolume, rWave, rFrequency, rType As UByte
'   Volume has been modified
Dim mVolume As UByte
' Up to three notes can be played simultaneously
Dim notes(2) As UByte
' Waveform oscillation frequency
Dim frequency As UInteger


' - Additional Modules -----------------------------------
#INCLUDE "Keyboard.bas"


' - Main Subroutine -----------------------------------
Sub Main()
    ' Temporary variables
    Dim n, m, o, f1, f2, fo1, fo2, channel As UByte

    ' Initialize the system
    Initialize()

    ' Initialize the mixer
    AYReg(AY_MIXER,%00111000)
    ' Adjust channel volumes
    AYReg(AY_A_VOLUME, 15)   ' Maximum volume
    AYReg(AY_B_VOLUME, 15)   ' Maximum volume
    AYReg(AY_C_VOLUME, 15)   ' Maximum volume

    ' Initial octave minus 2
    octave = 0
    ' Initial volume
    volume = 15
    ' Volume copy
    volume2 = 15
    ' Flat waveform
    wave = 0
    ' Default frequency
    frequency = 10

    ' Infinite loop
    Do
        ' Start with 0 keys/notes
        numNotes = 0
        ' Scan all possible keys
        For n = 0 To 23
            ' Key pressed...
            If Multikeys(Keys(n)) <> 0 Then
                ' Add the note to "notes"
                notes(numNotes) = (octave * 12) + n
                ' If we already have three notes...
                If numNotes = 3 Then
                    ' Don't want more notes
                    Exit For
                    ' If we don't have three notes yet...
                Else
                    ' Increment the note counter
                    numNotes = numNotes + 1
                End If
            End If
        Next n

        ' Control the upper options (octave, volume, waveform, etc...)
        ControlKeyboard()

        ' If a waveform is defined...
        If wave <> 0 Then
            ' If the volume is not 16...
            If volume <> 16 Then
                ' Make a copy of the current volume
                volume2 = volume
                ' Set the volume to 16
                volume = 16
                ' Mark volume as modified
                mVolume = 1
            End If
        End If

        ' Update information on screen
        ' Current octave
        PRINT AT 2, 16;(octave + 2);
        ' If no waveform is selected...
        If wave = 0 Then
            ' Display volume
            PRINT AT 3, 16;volume;" ";
            ' Don't display waveform frequency
            PRINT AT 5, 16;"-    ";
        ' If a waveform is selected...
        Else
            ' Don't display volume
            PRINT AT 3, 16;"- ";
            ' Display waveform frequency
            PRINT AT 5, 16;frequency;" ";
        End If

        ' Display the selected waveform type
        PRINT AT 4, 16;waveTypes(wave);

        ' Print the instrument type used 
        If type = 0 Then
            PRINT AT 6, 16;"Tone ";
        ElseIf type = 1 Then
            PRINT AT 6, 16;"Noise";
        Else
            PRINT AT 6, 16;"T + N";
        End If

        ' Volume has been modified or there's a waveform
        If mVolume <> 0 Or wave <> 0 Then
            ' Adjust volume
            AYReg(AY_A_VOLUME, volume)
            AYReg(AY_B_VOLUME, volume)
            AYReg(AY_C_VOLUME, volume)
            ' Reset volume modified flag
            mVolume = 0
            ' Adjust volume mixer
            If type = 0 Then
                ' Tone only
                AYReg(AY_MIXER,%00111000)
            ElseIf type = 1 Then
                ' Noise only
                AYReg(AY_MIXER,%00000111)
            Else
                ' Tone + Noise
                AYReg(AY_MIXER,%00111111)
            End If
        End If

        ' Play notes --------------------------
        ' Up to three notes
        For n = 1 To 3
            ' Channel equals counter n - 1
            channel = n - 1
            ' If all notes have been played...
            If n > numNotes Then
                ' Print "-" on channel info
                PRINT AT n+7, 16;"-  ";
                ' Silence the channel with note 0
                AYReg(AY_A_COARSEPITCH + (channel * 2), 0)
                AYReg(AY_A_FINEPITCH + (channel * 2), 0)
                ' If there are still notes to play...
            Else
                ' Current note
                note = notes(channel)
                ' Get the note's frequency
                f1 = Music_Notes(note, 0)
                f2 = Music_Notes(note, 1)
                ' Calculate the note's octave
                o = INT(note / 12) + 2
                ' Print the note and octave
                PRINT AT n+7, 16;notation(note Mod 12);o;" "; 

                ' Play the note
                AYReg(AY_A_COARSEPITCH + (channel * 2), f1)
                AYReg(AY_A_FINEPITCH + (channel * 2), f2)

                ' If the volume is 16, use waveform...
                If volume = 16 Then
                    ' Program the waveform
                    AYReg(AY_ENVELOPE_SHAPE, WaveIds(wave))
                    ' High byte of frequency
                    fo1 = frequency >> 8
                    ' Low byte of frequency
                    fo2 = frequency bAND $00Ff
                    ' Program the waveform's frequency
                    AYReg(AY_ENVELOPE_COURSE, fo1)
                    AYReg(AY_ENVELOPE_FINE, fo2)
                End If
            End If
        Next n
    Loop
End Sub


' - Initialize the system ---------------------------------
Sub Initialize()
    ' Text for each note
    notation(0) = "C"
    notation(1) = "C#"
    notation(2) = "D"
    notation(3) = "D#"
    notation(4) = "E"
    notation(5) = "F"
    notation(6) = "F#"
    notation(7) = "G"
    notation(8) = "G#"
    notation(9) = "A"
    notation(10) = "A#"
    notation(11) = "B"

    ' Adjust GDUs to point to waves
    POKE (uinteger 23675, @Waves)
    
    ' Define AY chip waveform types
    waveTypes(0)="\G\G\G\G"
    waveTypes(1)="\A\B\B\B"
    waveTypes(2)="\D\B\B\B"
    waveTypes(3)="\E\E\E\E"
    waveTypes(4)="\A\F\A\F"
    waveTypes(5)="\E\C\C\C"
    waveTypes(6)="\D\D\D\D"
    waveTypes(7)="\F\C\C\C"
    waveTypes(8)="\F\A\F\A"
    
    ' Draw piano keyboard
    DrawKeyboard()    
    
    ' Draw fixed text for indicators
    PRINT AT 0,15;INK 1;"PIANO";
    PRINT AT 2,0;"       Octave :          (0-9)";
    PRINT AT 3,0;"       Volume :          (O-P)";
    PRINT AT 4,0;"         Wave :          (K-L)";
    PRINT AT 5,0;"    Frequency :       (O-P-CS)";
    PRINT AT 6,0;"   Instrument :            (1)";
    PRINT AT 8,0;"    Channel A :";
    PRINT AT 9,0;"    Channel B :";
    PRINT AT 10,0;"    Channel C :";
END SUB


SUB DrawKeyboard()
    ' Use piano font
    POKE (uinteger 23606, @Piano-256)
    ' Print piano keys (see Piano.fnt)
    PRINT AT 13,1;"af$l$kaf$l$l$kaf$l$kaf$l$l$ka";
    PRINT AT 14,1;"amnopkaqrstuvkamnopkaqrstuvka";
    PRINT AT 15,1;"afSlDkafGlHlJkaf2l3kaf5l6l7ka";
    PRINT AT 16,1;"aghihjaghihihjaghihjaghihihja";
    PRINT AT 17,1;"a a a a a a a a a a a a a a a";
    PRINT AT 18,1;"awaxayaza{a|a}awaxayaza{a|a}a";
    PRINT AT 19,1;"aZaXaCaVaBaNaMaQaWaEaRaTaYaUa";
    PRINT AT 20,1;"bcdcdcdcdcdcdcdcdcdcdcdcdcdce";
    ' Restore default font
    POKE (uinteger 23606, $3c00)
END SUB


' - Sends a value to the specified AY register ------------
' Parameters:
'   register (UByte): Register to modify
'   value (UByte): Value to store in the register
SUB AYReg(register AS UByte, value AS UBYTE)
    OUT AY_CONTROL,register
    OUT AY_DATA,value
END SUB



