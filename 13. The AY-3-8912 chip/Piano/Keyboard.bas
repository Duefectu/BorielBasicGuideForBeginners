' - PIANO ---------------------------------------------
' - Module for keyboard control -----------------------

' - Keyboard Control ---------------------------------
SUB ControlKeyboard()
    ' Octave Control -----------------------------------
    ' If key 9 is pressed...
    IF Multikeys(KEY9) THEN
        ' If the debounce flag is not active...
        IF rOctave = 0 THEN
            ' If the octave is greater than 0...
            IF octave > 0 THEN
                ' Decrease the current octave by one
                octave = octave - 1
                ' Set the debounce flag
                rOctave = 1
            END IF
        END IF
    ' If key 0 is pressed...
    ELSEIF Multikeys(KEY0) THEN
        ' If the debounce flag is not active...
        IF rOctave = 0 THEN
            ' If the octave is less than 3...
            IF octave < 3 THEN
                ' Increase the octave by one
                octave = octave + 1
                ' Set the debounce flag
                rOctave = 1
            END IF
        END IF
    ' If neither 9 nor 0 are pressed...
    ELSE
        ' Reset the debounce flag
        rOctave = 0
    END IF     

    ' Volume Control -----------------------------------
    ' If there is no waveform...
    IF wave = 0 THEN
        ' If O key is pressed...
        IF Multikeys(KEYO) THEN
            ' If the debounce flag is not active...
            IF rVolume = 0 THEN
                ' If the volume is not 0...
                IF volume > 0 THEN
                    ' Decrease the volume
                    volume = volume - 1
                    ' Activate the debounce flag
                    rVolume = 1
                    ' Volume modified flag
                    mVolume = 1
                END IF
            END IF
        ' If P key is pressed...
        ELSEIF Multikeys(KEYP) THEN
            ' If the debounce flag is not active...
            IF rVolume = 0 THEN
                ' If the volume is less than 15...
                IF volume < 15 THEN
                    ' Increase the volume
                    volume = volume + 1
                    ' Activate the debounce flag
                    rVolume = 1
                    ' Volume modified flag
                    mVolume = 1
                END IF
            END IF
        ' If neither O nor P are pressed...
        ELSE
            ' Reset the debounce flag
            rVolume = 0
        END IF
    END IF

    ' Waveform Control ---------------------------------
    ' If K key is pressed...
    IF Multikeys(KEYK) THEN
        ' If the debounce flag is not active...
        IF rWave = 0 THEN
            ' If the waveform type is not zero
            IF wave > 0 THEN
                ' Decrease the waveform type
                wave = wave - 1
                ' Activate the debounce flag 
                rWave = 1
            END IF
            ' If the waveform is 0...
            IF wave = 0 THEN
                ' Restore the original volume
                volume = volume2
            END IF
        END IF
    ' If L key is pressed...
    ELSEIF Multikeys(KEYL) THEN 
        ' If the debounce flag is not active...
        IF rWave = 0 THEN
            ' If the waveform is less than 8...
            IF wave < 8 THEN
                ' Increase the waveform type
                wave = wave + 1
                ' Activate the debounce flag
                rWave = 1
            END IF
        END IF
    ' If neither K nor L are pressed...
    ELSE 
        ' Reset the debounce flag
        rWave = 0
    END IF

    ' Frequency Control -------------------------------
    ' Only control if a waveform type is defined
    IF wave <> 0 THEN
        ' If CAPS SHIFT is pressed...
        IF Multikeys(KEYCAPS) THEN
            ' If O + CAPS SHIFT is pressed...
            IF Multikeys(KEYO) THEN
                ' If the debounce flag is not active.. 
                IF rFrequency = 0 THEN
                    ' If the frequency is greater than 0...
                    IF frequency > 0 THEN
                        ' Decrease the frequency
                        frequency = frequency - 1
                        ' Activate the debounce flag
                        rFrequency = 1
                    END IF
                END IF
            ' If P + CAPS SHIFT is pressed... 
            ELSEIF Multikeys(KEYP) THEN
                ' If the debounce flag is not active..
                IF rFrequency = 0 THEN
                    ' If the frequency is less than 65564...
                    IF frequency < 65564 THEN
                        ' Increase the frequency
                        frequency = frequency + 1
                        ' Activate the debounce flag
                        rFrequency = 1
                    END IF
                END IF
            ' If neither CAPS SHIFT + O nor P are pressed...
            ELSE
                ' Reset the debounce flag
                rFrequency = 0
            END IF 
        ' If CAPS SHIFT is not pressed...
        ELSE
            ' If O key is pressed...
            IF Multikeys(KEYO) THEN
                ' Ignore the debounce flag
                ' If the frequency is greater than 0...
                IF frequency > 0 THEN
                    ' Decrease the frequency
                    frequency = frequency - 1
                END IF
            ' If P key is pressed...
            ELSEIF Multikeys(KEYP) THEN
                ' Ignore the debounce flag
                ' If the frequency is less than 65564...
                IF frequency < 65564 THEN
                    ' Increase the frequency
                    frequency = frequency + 1
                END IF
            ELSE
                ' Reset the debounce flag
                rFrequency = 0
            END IF 
        END IF
    END IF
    
    ' Instrument Type Control --------------------------
    ' If 1 key is pressed...
    IF Multikeys(KEY1) THEN
        ' If the debounce flag is not active...
        IF rType = 0 THEN            
            ' If the type is 2...
            IF type = 2 THEN
                ' Set the type to 0
                type = 0
            ' If the type is not 2...
            ELSE
                ' Increase the type
                type = type + 1
            END IF
            ' Mark the volume as modified
            mVolume = 1
            ' Activate the debounce flag
            rType = 1
        END IF
    ELSE
        ' Reset the debounce flag
        rType = 0
    END IF    
END SUB
