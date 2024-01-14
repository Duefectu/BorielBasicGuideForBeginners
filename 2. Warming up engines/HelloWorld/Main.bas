' - HelloWorld --------------------------------------------
' http://tinyurl.com/32ttk46b

Dim x, y AS UByte

BORDER 0
PAPER 0
INK 7
CLS

FOR y = 0 TO 7
    FOR x = 0 TO 7
        PRINT AT y,x; PAPER x; INK y; "X";
    NEXT x
NEXT y

PAUSE 0
