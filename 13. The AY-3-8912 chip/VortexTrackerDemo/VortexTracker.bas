' - Módulo de reproducción de Vortex Tracker --------------

' - Defines -----------------------------------------------
#DEFINE VTPLAYER_INIT $eb00
#DEFINE VTPLAYER_NEXTNOTE $eb05
#DEFINE VTPLAYER_MUTE $eb08


' - Variables ---------------------------------------------
' Estado del reproductor, 0=parado, 1=sonando
DIM VortexTracker_Status AS UByte = 0


' - Inicializa el motor de Vortex Tracker -----------------
' Parámetros:
'   usarIM2 (byte): 1 utiliza el motor de interrupciones
'                   0 solo inicializa el motor de Vortex
SUB VortexTracker_Inicializar(usarIM2 AS UByte)
    ASM
        push ix             ; Guardamos ix               
        call VTPLAYER_INIT  ; Inicializamos el motor
        pop ix              ; Recuperamos ix
    END ASM
    
    ' Si usamos interrupciones...
    IF usarIM2 = 1 THEN
        ' Inicializamos el motor de interrupciones para
        ' que se ejecute "VortexTracker_NextNote" en cada
        ' interrupción
        IM2_Inicializar(@VortexTracker_NextNote)
    END IF
    
    ' Estado: 1 (sonando)
    VortexTracker_Status = 1
END SUB


' - Toca la próxima nota de la canción --------------------
' Se invoca de forma automática por el gestor de 
' interrupciones. Si no usamos el gestor, se debe llamar a
' este método cada 20ms.
SUB FASTCALL VortexTracker_NextNote()
    ' Solo toca si el estado es 1 (sonando)
    if VortexTracker_Status = 1 THEN
        ASM
            push ix                 ; Guardamos ix          
            call VTPLAYER_NEXTNOTE  ; Reproducimos una nota
            pop ix                  ; Recuperamos ix
        END ASM
    end if
END SUB


' - Detiene la reproducción de la música ------------------
SUB VortexTracker_Stop()
    ' Estado igual a 0 (detenido)
    VortexTracker_Status = 0
    ASM
        push ix             ; Guardamos ix
        call VTPLAYER_MUTE  ; Bajamos el volumen a 0
        pop ix              ; Recuperamos ix
    END ASM
END SUB
