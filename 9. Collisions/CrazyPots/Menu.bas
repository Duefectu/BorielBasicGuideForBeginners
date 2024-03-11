' - Crazy Pots -------------------------------------------
' - Game Menu --------------------------------------------


' - Main Menu --------------------------------------------
SUB Menu()
    ' Local variables
    DIM txt AS String
    DIM x AS UByte
    
    ' Clear the screen
    BORDER 1
    PAPER 7
    INK 0
    CLS
    
    ' Print the title in double size
    DoubleSizeText(52,140,"CRAZY POTS")
    ' Print four large pots
    INK 1
    DoubleSizeSprite(10,100,@Things_Pot1)
    INK 2
    DoubleSizeSprite(75,100,@Things_Pot2)
    INK 3
    DoubleSizeSprite(135,100,@Things_Pot3)
    INK 4
    DoubleSizeSprite(204,100,@Things_Gift)
    
    ' Print the record
    INK 1
    txt = "Record: " + STR(Record)
    x = 128 - ((LEN(txt) * 16) / 2)
    DoubleSizeText(x,60,txt)
    
    ' Ask to press a key
    INK 0
    PRINT AT 20,5;"Press any key to start";
    ' Wait for a key press
    PauseKey()
END SUB


' - Print a pot sprite double its size -------------------
SUB DoubleSizeSprite(x AS UByte, y AS UByte, _
    dir AS Integer)
    ' Top-left character
    DoubleSize8x8(x,y+16,dir)
    ' Bottom-left
    DoubleSize8x8(x,y,dir + 8)
    ' Top-right
    DoubleSize8x8(x+16,y+16,dir + 24)
    ' Bottom-right
    DoubleSize8x8(x+16,y,dir + 32)
END SUB


' - Wait for a key press ----------------------------------
' If a key is being pressed upon entering, wait for it
' to be released, then wait for another key press
SUB PauseKey()
    ' Wait while a key is being pressed
    WHILE INKEY$<>""
    WEND
    ' Wait while no key is being pressed
    WHILE INKEY$=""
    WEND
END SUB
