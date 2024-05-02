' - Next Mouse demo ---------------------------------------
' Módulo de menú

' - Menú del juego
SUB Menu()
    ' Borramos la pantalla de la ULA
    CLS
    ' Borramos la pantalla de la Layer 2
    CLS256(0)

    ' Imprimimos "MOUSE DEMO!" centrado a 16x16
    ImprimirCentrado16(1,"MOUSE DEMO!")
    ' Imprime el record centrado
    ImprimirCentrado16(4,"RECORD: " + STR(Record))
    ' Espera a que hagamos clic
    ImprimirCentrado16(8,"CLICK MOUSE!")
    PausaClic()
    
    ' Semilla de los números aleatorios al TIMER
    RANDOMIZE 0
END SUB


' - Espera a que hagamos clic con el botón izquierdo ------
' Si el botón está pulsado al entrar, espera a que lo
' soltemos
SUB PausaClic()
    ' Bucle hasta que el botón izquierdo no esté apretado
    DO
        ' Leermos el estado del ratón
        LeerMouse()  
    ' Repetimos si MouseBotonI no es cero (pulsado)
    LOOP WHILE MouseBotonI <> 0
    
    ' Bucle hasta que pulsemos el botón izquierdo
    DO
        ' Leemos el estado del ratón
        LeerMouse()
    ' Repetimos si MouseBotonI es (no pulsado)
    LOOP WHILE MouseBotonI = 0  
END SUB
