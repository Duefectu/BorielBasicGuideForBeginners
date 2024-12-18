# Boriel Basic Manual For Beginners
Source code of the listings published in the book "Boriel Basic for ZX Spectrum - A Guide for Beginners...and Those Who Aren't So Much"

The book can be purchased on Amazon in digital, hardcover, or paperback formats: https://www.amazon.co.uk/dp/B0D7S9NYR3

Patrons are entitled to the PDF and EPUB versions: https://www.patreon.com/DuefectuCorp

# ZX Basic Studio
Download the latest version from the ZX Basic Studio GitHub: https://github.com/boriel-basic/ZXBasicStudio/releases

Thank you for your support!

# Bug Fixes
In this section, I will add any bugs or clarifications that arise. Thank you for reporting them.

- Page 101: In the list the “Loop” tag is used, which is a reserved word and cannot be used. The Loop tag must be changed to “MyLoop”, for example, leaving the list like this:
```Basic
DIM n AS UByte 
n = 0 
' Initiating the loop 
MyLoop: 
    ' Increment the counter by 1 
    n = n + 1 
    ' Exit if the counter reaches 10 
    IF n = 10 THEN GOTO EndOfLoop 
    ' Print the counter 
    PRINT n 
    ' Closing the loop 
    GOTO MyLoop 
 
' Jump here when closing the loop 
EndOfLoop:
```
- Page 104: En el listado se usa la variable "paper", que es una palabra reservada. Debe cambiarse "paper" por "myPaper", por ejemplo:
```Basic
DIM line, column, myPaper AS UByte 
 
BORDER 1 
PAPER 0 
INK 0 
CLS 
 
' Traverse the lines (Y coordinate) from 0 to 23 
FOR line = 0 TO 23 
    ' Traverse the 32 columns (X coordinate) 
    FOR column = 0 TO 31 
        ' Set the paper colour 
        PAPER myPaper 
        ' Print an X at the loop coordinates 
        PRINT AT line, column; "X"; 
        ' Increment the myPaper colour counter 
        myPaper = myPaper + 1 
    NEXT column 
NEXT line
```
- Page 245: In the list remove the "warr" line.
- Page 471: It not a bug, but..., in the list code "txt = INPUT$(2)", better use "txt = input(2)"

