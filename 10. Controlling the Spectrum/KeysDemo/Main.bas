' - KeysDemo ----------------------------------------------
' https://tinyurl.com/3r3p6st6

#INCLUDE <Keys.bas>

' Declare two functions
DECLARE FUNCTION Menu AS UByte
DECLARE FUNCTION ReadKey AS UInteger


' Store the key codes in an array
DIM Keys(4) AS UInteger => _
    { KEYO, KEYP, KEYQ, KEYA, KEYSPACE }
' And the name of the command for each key in another
DIM KeysS(4) AS String
' Control type, 1=Keyboard, 2=KEMPSTON,
'   3=SINCLAIR 1, 4=SINCLAIR 2, 5=CURSOR 
DIM ControlType AS UByte = 1

' These defines help us avoid confusion with indices
#DEFINE LEFT_KEY 0
#DEFINE RIGHT_KEY 1
#DEFINE UP_KEY 2
#DEFINE DOWN_KEY 3
#DEFINE SHOOT_KEY 4

' Call the Main subroutine to start
Main()


' - Main program subroutine ----------------------
SUB Main()
    DIM option AS UByte
    
    ' Initialize the system
    Initialize()

    ' Infinite loop
    DO    
        CLS
        ' Print the menu and collect the selected option
        option = Menu()
        
        IF option = 1 THEN
            ' Option 1 is for testing
            Test()
        ELSE IF option = 2 THEN
            ' Option 2 is for redefining
            RedefineKeys()  
            ' If redefining, switch to keyboard
            ControlType = 1
        ELSE IF option = 3 THEN
            ' Option 3 is keyboard
            ControlType = 1
        ELSE IF option = 4 THEN
            ' Option 4 is for KEMPSTON
            ControlType = 2
        ELSE IF option = 5 THEN
            ' Option 5 is for SINCLAIR 1
            Sinclair1Keys()
            ControlType = 3
        ELSE IF option = 6 THEN
            ' Option 6 is for SINCLAIR 2
            Sinclair2Keys()
            ControlType = 4
        ELSE IF option = 7 THEN
            ' Option 7 is for CURSOR
            CursorKeys()
            ControlType = 5
        END IF
    LOOP
END SUB


' - Initialize the system ---------------------------------
SUB Initialize()
    ' Set default colours
    BORDER 0
    PAPER 0
    INK 6
    CLS

    ' Define key labels
    KeysS(LEFT_KEY) = " Left  "
    KeysS(RIGHT_KEY) = " Right "
    KeysS(UP_KEY) = " Up    "
    KeysS(DOWN_KEY) =  " Down  "
    KeysS(SHOOT_KEY) = " Shoot "
END SUB


' - Display the main menu and return the selected option
' Returns:
'   UByte: Selected option: 1=Redefine, 2=Test
FUNCTION Menu() AS UByte    
    DIM a AS UByte
    
    CLS
    ' Print labels
    INK 5
    PRINT AT  2,5;"    Main Menu"
    PRINT AT 18,9;"Select an option"

    ' Print fixed options
    INK 6
    PRINT AT 4,5;" 1. Test"
    PRINT AT 6,5;" 2. Redefine keys"
    ' If using keyboard, highlight the option in green
    IF ControlType = 1 THEN
        INK 4
    END IF
    PRINT AT 8,5;" 3. Keyboard"
    INK 6
    ' If using KEMPSTON, highlight the option in green
    IF ControlType = 2 THEN
        INK 4
    END IF
    PRINT AT 10,5;" 4. KEMPSTON Joystick"
    INK 6
    ' If using SINCLAIR 1, highlight the option in green
    IF ControlType = 3 THEN
        INK 4
    END IF
    PRINT AT 12,5;" 5. SINCLAIR 1 Joystick"
    INK 6
    ' If using SINCLAIR 2, highlight the option in green
    IF ControlType = 4 THEN
        INK 4
    END IF
    PRINT AT 14,5;" 6. SINCLAIR 2 Joystick"
    INK 6
    ' If using CURSOR, highlight the option in green
    IF ControlType = 5 THEN
        INK 4
    END IF
    PRINT AT 16,5;" 7. CURSOR Joystick"
    INK 6
    
    ' Loop until a correct option is selected
    DO
        IF INKEY$ <> "" THEN
            ' Convert the key into a number
            a = VAL(INKEY$)
            IF a <> 0 THEN
                ' If it's a number, return it
                RETURN a
            END IF
        END IF
    LOOP
END FUNCTION


' - Option "Redefine keys" -----------------------------
SUB RedefineKeys()
    DIM n AS UByte
    DIM k AS UInteger
    
    CLS
    ' Print the header
    INK 5
    PRINT AT 10,5;"Press a key to:";
    INK 6
    
    ' For each of the 5 keys
    FOR n=0 TO 4
        ' Print the key name
        PRINT AT 14,10;KeysS(n);
        ' Read and store the key code
        Keys(n) = ReadKey()
    NEXT n
END SUB


' - Return the code of the pressed key -----------------
' Returns:
'   UInteger: Code of the pressed key
FUNCTION ReadKey() AS UInteger
    ' Declare k with a default value of 0
    DIM k AS UInteger = 0
    
    ' Wait until nothing is pressed
    WHILE GetKeyScanCode() <> 0
    WEND
    
    ' Repeat until a key is pressed
    WHILE k = 0
        ' Read the pressed key
        k = GetKeyScanCode()        
    WEND
    
    ' Return the code of the pressed key
    RETURN k
END FUNCTION


' - Define keys for SINCLAIR 1 Joystick ------------
SUB Sinclair1Keys()
    Keys(LEFT_KEY)=KEY1
    Keys(RIGHT_KEY)=KEY2
    Keys(DOWN_KEY)=KEY3
    Keys(UP_KEY)=KEY4
    Keys(SHOOT_KEY)=KEY5
END SUB


' - Define keys for SINCLAIR 2 Joystick ------------
SUB Sinclair2Keys()
    Keys(LEFT_KEY)=KEY6
    Keys(RIGHT_KEY)=KEY7
    Keys(DOWN_KEY)=KEY8
    Keys(UP_KEY)=KEY9
    Keys(SHOOT_KEY)=KEY0
END SUB


' - Define keys for CURSOR Joystick ------------
SUB CursorKeys()
    Keys(LEFT_KEY)=KEY5
    Keys(RIGHT_KEY)=KEY8
    Keys(DOWN_KEY)=KEY6
    Keys(UP_KEY)=KEY7
    Keys(SHOOT_KEY)=KEY0
END SUB


' - Option to test keys ----------------------------------
SUB Test()
    DIM n AS UByte
    
    ' Print the title
    CLS
    INK 5
    PRINT AT 5,2;"Test: PRESS ENTER to exit..."
    
    ' Infinite loop...
    DO
        ' If not using KEMPSTON
        IF ControlType <> 2 THEN
            ' Scan all keys
            FOR n = 0 TO 4
                ' Check if the key at index is pressed
                IF Multikeys(Keys(n)) THEN
                    ' If pressed, print its name
                    PRINT AT 7+n,13;INK n+2;KeysS(n);
                ' If the key is not pressed...
                ELSE
                    ' Clear the text
                    PRINT AT 7+n,13;"          ";
                END IF
            NEXT n 
        ' If using KEMPSTON
        ELSE
            ' Read the value of the KEMPSTON Joystick port
            n = IN(31)            
            IF n bAND %10 THEN  ' Left
                PRINT AT 7,13;INK 2;KeysS(LEFT_KEY);
            ELSE
                PRINT AT 7,13;"          ";
            END IF
            IF n bAND %1 THEN   ' Right
                PRINT AT 8,13;INK 3;KeysS(RIGHT_KEY);
            ELSE
                PRINT AT 8,13;"          ";
            END IF
            IF n bAND %1000 THEN    ' Up
                PRINT AT 9,13;INK 4;KeysS(UP_KEY);
            ELSE
                PRINT AT 9,13;"          ";
            END IF
            IF n bAND %100 THEN    ' Down
                PRINT AT 10,13;INK 5;KeysS(DOWN_KEY);
            ELSE
                PRINT AT 10,13;"          ";
            END IF
            IF n bAND %10000 THEN    ' Shoot
                PRINT AT 11,13;INK 6;KeysS(SHOOT_KEY);
            ELSE
                PRINT AT 11,13;"          ";
            END IF
        END IF
                
        ' If the pressed key is to exit, then exit
        IF MultiKeys(KEYENTER) THEN
            RETURN
        END IF
    LOOP
END SUB
