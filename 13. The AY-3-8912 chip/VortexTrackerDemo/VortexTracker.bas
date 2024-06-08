' - Vortex Tracker Playback Module --------------------------

' - Defines -----------------------------------------------
#DEFINE VTPLAYER_INIT $eb00
#DEFINE VTPLAYER_NEXTNOTE $eb05
#DEFINE VTPLAYER_MUTE $eb08


' - Variables ---------------------------------------------
' Player status, 0=stopped, 1=playing
DIM VortexTracker_Status AS UByte = 0


' - Initialize the Vortex Tracker engine -------------------
' Parameters:
'   usarIM2 (byte): 1 uses the interrupt engine
'                   0 only initializes the Vortex engine
SUB VortexTracker_Initialize(usarIM2 AS UByte)
    ASM
        push ix             ; Save ix               
        call VTPLAYER_INIT  ; Initialize the engine
        pop ix              ; Restore ix
    END ASM
    
    ' If using interrupts...
    IF usarIM2 = 1 THEN
        ' Initialize the interrupt engine to execute 
        ' "VortexTracker_NextNote" at each interrupt
        IM2_Initialize(@VortexTracker_NextNote)
    END IF
    
    ' Status: 1 (playing)
    VortexTracker_Status = 1
END SUB


' - Play the next note of the song --------------------------
' Automatically invoked by the interrupt manager.
' If not using the manager, this method must be called every 20ms.
SUB FASTCALL VortexTracker_NextNote()
    ' Play only if the status is 1 (playing)
    if VortexTracker_Status = 1 THEN
        ASM
            push ix                 ; Save ix          
            call VTPLAYER_NEXTNOTE  ; Play a note
            pop ix                  ; Restore ix
        END ASM
    end if
END SUB


' - Stop music playback -------------------------------------
SUB VortexTracker_Stop()
    ' Status equals 0 (stopped)
    VortexTracker_Status = 0
    ASM
        push ix             ; Save ix
        call VTPLAYER_MUTE  ; Set volume to 0
        pop ix              ; Restore ix
    END ASM
END SUB
