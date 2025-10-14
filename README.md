# Boriel Basic Manual For Beginners
Source code of the listings published in the book "Boriel Basic for ZX Spectrum - A Guide for Beginners...and Those Who Aren't So Much"

The book can be purchased on Amazon in digital, hardcover, or paperback formats:
- US: [https://www.amazon.co.uk/dp/B0D7S9NYR3](https://www.amazon.com/dp/B0DBF4BHXY)
- UK: https://www.amazon.co.uk/dp/B0DBF4BHXY
- DE: https://www.amazon.de/dp/B0DBF4BHXY
- FR: https://www.amazon.fr/dp/B0DBF4BHXY
- ES: https://www.amazon.es/dp/B0DBF4BHXY
- IT: https://www.amazon.it/dp/B0DBF4BHXY
- NL: https://www.amazon.nl/dp/B0DBF4BHXY
- PL: https://www.amazon.pl/dp/B0DBF4BHXY
- SE: https://www.amazon.se/dp/B0DBF4BHXY
- JP: https://www.amazon.co.jp/dp/B0DBF4BHXY
- CA: https://www.amazon.ca/dp/B0DBF4BHXY
- AU: https://www.amazon.com.au/dp/B0DBF4BHXY

Patrons are entitled to the PDF and EPUB versions: https://www.patreon.com/DuefectuCorp

# ZX Basic Studio
Download the latest version from the ZX Basic Studio GitHub: https://github.com/boriel-basic/ZXBasicStudio/releases

Thank you for your support!


# Changes in New Compiler Versions
Here I comment on the critical changes in the compiler that may cause some examples not to work.

*Version 1.18.3 and later*
- The addressing of arrays has changed. The @ prefix now returns the address of the variable itself, not of the data. Therefore, to refer to the first value of the array, you must use "@myArray(0)" instead of "@myArray".


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
- Chapter 12. The Beeper: In this chapter it is erroneously reported that the center DO has the value of 12 for the tone, when in fact it should be 0, so in the examples of the BEEP command 12 units should be subtracted from the value of the tone.
- DBAdventure listing: In the Main.bas file the line “#INCLUDE <retrace.bas>” should be moved to line 14. The listing has been updated: https://github.com/Duefectu/BorielBasicGuideForBeginners/blob/main/7.%20The%20screen%20on%20the%20ZX%20Spectrum/DBAdventure/Main.bas
