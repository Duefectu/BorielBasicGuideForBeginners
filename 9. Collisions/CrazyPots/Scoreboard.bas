' - Crazy Pots -----------------------------------------
' - Scoreboard Module ----------------------------------


' - Draw the fixed elements of the scoreboard ------------
SUB Scoreboard_Draw()
    INK 1
    PRINT AT 18,1;"SCORE:";
    PRINT AT 18,22;"LEVEL:";     
END SUB


' - Update the values of the scoreboard -----------------
SUB Scoreboard_Update()
    ' Local variables
    DIM n AS UByte
    
    ' Score and level
    INK 1
    PRINT AT 18,9;Points;
    PRINT AT 18,29;Level;
    
    ' Lives
    ' Hearts will be printed at 18,14
    PRINT AT 18,14;"";
    FOR n = 1 TO 3
        ' If the counter is smaller than the lives...
        IF Lives >= n THEN
            ' Red heart
            PRINT INK 2;chr(92);
        ' If the counter is greater than the lives...
        ELSE
            ' Empty heart
            PRINT INK 1;chr(91);
        END IF
    NEXT n       
END SUB


' - Draw the pots to collect ----------------------------
SUB Scoreboard_DrawFlowerpots()
    ' Local variables
    DIM x,n AS UByte
    
    ' Print in magenta
    INK 3
    ' Start from pixel 0
    x = 0
    ' 8 pots
    FOR n = 0 TO 7
        ' Print the pot sprite
        DoubleSizeSprite(x,4,_
            PotsDir(FlowerpotsSequence(n,0)))
        ' The next pot is within 32 pixels
        x = x + 32
    NEXT n
END SUB


' - Update the status of the pots to collect ------------
' Returns:
'   UByte: Pots remaining to collect
FUNCTION Scoreboard_UpdateFlowerpots() AS UByte
    ' Local variables
    DIM x, n, remaining AS UByte
    
    ' Start from the left
    x = 0 
    ' Counter for remaining pots
    remaining = 0
    ' Traverse the entire sequence of pots to collect
    FOR n = 0 TO 7
        ' If the pot has not been collected...
        IF FlowerpotsSequence(n,1) = 0 THEN
            ' Color it with PAPER 7 and INK 3
            paint(x,19,4,5,%111011)
            ' One more pot remaining to collect
            remaining = remaining + 1
        ' If the pot has been collected...
        ELSE
            ' Color with BRIGHT 1, PAPER 7 and INK 1
            paint(x,19,4,5,%1111001)
        END IF
        ' The next pot is 4 cells to the right
        x = x + 4
    NEXT n
    ' Return the number of remaining pots
    RETURN remaining
END FUNCTION
