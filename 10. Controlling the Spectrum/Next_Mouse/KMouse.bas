' - Rutinas para la gestión del mouse ---------------------


' Variables globales
' Se actualizan en cada llamada a LeerMouse
' Coordenadas X e Y del ratón
DIM MouseX, MouseY AS UByte
' Valor directo de los botones, botón izquierdo y derecho
DIM MouseBoton, MouseBotonI, MouseBotonD AS UByte


' - Lee los datos del ratón -------------------------------
' Esta rutina actualiza las variables globales MouseX,
' MouseY, MouseBoton (valor directo), MouseBotonI y
' MouseBotonD
Sub LeerMouse()
    ' Leemos las coordenadas x e y del ratón
    MouseX = IN ($fbdf)
    MouseY = IN ($ffdf)
    ' Leemos el estado de los botones
    MouseBoton = IN ($fadf)
    ' El bit 0 es el botón derecho
    MouseBotonD = (MouseBoton bAND %1) = 0
    ' El bit 1 es el botón izquierdo
    MouseBotonI = (MouseBoton bAND %10) = 0
END SUB
