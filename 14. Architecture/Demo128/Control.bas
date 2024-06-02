' - Demo128 -----------------------------------------------
' https://tinyurl.com/55jh39x5
' - Módulo de control -------------------------------------

Main()
STOP


' - Zona de variables comunes -----------------------------
VariablesComunes:
ASM
    DEFS 1024
END ASM


' - Includes ----------------------------------------------
#INCLUDE <memcopy.bas>
#INCLUDE "Vars.bas"


' - Subrutina principal de control ------------------------
SUB Main()
    ' Cargamos el resto de módulos desde cinta
    CargarModulos()
    
    ' Definimos el siguiente módulo a ejecutar
    ModuloAEjecutar = MODULO_MENU
    Parametro1 = 0
    Parametro2 = 0
    ' Bucle infinito
    DO
        ' Ejecutamos el módulo seleccionado
        EjecutarModulo(ModuloAEjecutar)
    LOOP
END SUB


' - Carga los módulos y recursos adicionales --------------
SUB CargarModulos()
    ' Módulo de menú
    PaginarMemoria(MODULO_MENU)
    LOAD "" CODE $c000
    ' Módulo de juego
    PaginarMemoria(MODULO_JUEGO)
    LOAD "" CODE $c000
    ' Módulo de minijuegos
    PaginarMemoria(MODULO_MINIJUEGOS)
    LOAD "" CODE $c000
    ' Módulo de Game Over
    PaginarMemoria(MODULO_GAMEOVER)
    LOAD "" CODE $c000
    ' TODO: Cargar recursos gráficos, música, etc...
END SUB


' - Ejecuta un módulo -------------------------------------
' Parámetros:
'   modulo (UByte): módulo a ejecutar
SUB EjecutarModulo(modulo AS UByte)
    ' Conmutamos a la página donde está el módulo
    PaginarMemoria(modulo)
    ' Copiamos del slot 3 ($c000) al 2 ($8000)
    memcopy($c000,$8000,$4000)
    ' Ejecutamos el módulo
    PRINT AT 0,0;USR $8000;
END SUB
