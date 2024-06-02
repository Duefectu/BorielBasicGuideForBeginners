' - Demo128 -----------------------------------------------
' https://tinyurl.com/wxm7tcfr
' - Control Module -----------------------------------------

Main()
STOP


' - Common Variables Area -----------------------------------
CommonVariables:
ASM
    DEFS 1024
END ASM


' - Includes ------------------------------------------------
#INCLUDE <memcopy.bas>
#INCLUDE "Vars.bas"


' - Main control subroutine ---------------------------------
SUB Main()
    ' Load the rest of modules from tape
    LoadModules()
    
    ' Define the next module to execute
    ModuleToExecute = MODULE_MENU
    Parameter1 = 0
    Parameter2 = 0
    ' Infinite loop
    DO
        ' Execute the selected module
        ExecuteModule(ModuleToExecute)
    LOOP
END SUB


' - Load modules and additional resources -------------------
SUB LoadModules()
    ' Menu module
    SwitchMemoryBank(MODULE_MENU)
    LOAD "" CODE $c000
    ' Game module
    SwitchMemoryBank(MODULE_GAME)
    LOAD "" CODE $c000
    ' Minigames module
    SwitchMemoryBank(MODULE_MINIGAMES)
    LOAD "" CODE $c000
    ' Game Over module
    SwitchMemoryBank(MODULE_GAMEOVER)
    LOAD "" CODE $c000
    ' TODO: Load graphics, music resources, etc...
END SUB


' - Execute a module ----------------------------------------
' Parameters:
'   module (UByte): module to execute
SUB ExecuteModule(module AS UByte)
    ' Switch to the page where the module is located
    SwitchMemoryBank(module)
    ' Copy from slot 3 ($c000) to 2 ($8000)
    memcopy($c000,$8000,$4000)
    ' Execute the module
    PRINT AT 0,0;USR $8000;
END SUB
