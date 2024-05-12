' - Mouse management routines -----------------------------


' Global variables
' Updated with each call to ReadMouse
' Mouse X and Y coordinates
DIM MouseX, MouseY AS UByte
' Direct value of the buttons, left and right button
DIM MouseButton, MouseButtonL, MouseButtonR AS UByte


' - Reads mouse data --------------------------------------
' This routine updates the global variables MouseX,
' MouseY, MouseButton (direct value), MouseButtonL and
' MouseButtonR
Sub ReadMouse()
    ' Reads the x and y coordinates of the mouse
    MouseX = IN ($fbdf)
    MouseY = IN ($ffdf)
    ' Reads the state of the buttons
    MouseButton = IN ($fadf)
    ' Bit 0 is the right button
    MouseButtonR = (MouseButton bAND %1) = 0
    ' Bit 1 is the left button
    MouseButtonL = (MouseButton bAND %10) = 0
END SUB
