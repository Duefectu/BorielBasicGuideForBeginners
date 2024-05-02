' - Next Mouse demo ---------------------------------------
' Menu module

' - Game menu
SUB Menu()
    ' Clear ULA screen
    CLS
    ' Clear Layer 2 screen
    CLS256(0)

    ' Print "MOUSE DEMO!" centered at 16x16
    PrintCentered16(1,"MOUSE DEMO!")
    ' Print the record centered
    PrintCentered16(4,"RECORD: " + STR(Record))
    ' Wait for mouse click
    PrintCentered16(8,"CLICK MOUSE!")
    PauseClick()
    
    ' Seed random numbers to TIMER
    RANDOMIZE 0
END SUB


' - Wait for left mouse button click ----------------------
' If the button is pressed upon entering, wait until it is
' released
SUB PauseClick()
    ' Loop until the left button is not pressed
    DO
        ' Read the mouse state
        ReadMouse()  
    ' Repeat if MouseButtonL is not zero (pressed)
    LOOP WHILE MouseButtonL <> 0
    
    ' Loop until we press the left button
    DO
        ' Read the mouse state
        ReadMouse()
    ' Repeat if MouseButtonL is (not pressed)
    LOOP WHILE MouseButtonL = 0  
END SUB
