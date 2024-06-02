@echo off
cls
echo Compilando...
echo.

echo Limpiando compilaciones anteriores...
del Control.tap
del Menu.tap
del Juego.tap
del Minijuegos.tap
del GameOver.tap
del Master.tap
echo.

:Control
echo Compilando Control.bas
c:\zxbasic\zxbc Control.bas --org $6000 --heap-size 2048 --optimize 3 --tap --BASIC --autorun --mmap Control.map
if ERRORLEVEL 1 goto compilerError
echo.

:Menu
echo Compilando Menu.bas
c:\zxbasic\zxbc Menu.bas --org $8000 --heap-size 4096 --optimize 3 --tap --mmap Menu.map
if ERRORLEVEL 1 goto compilerError
echo.

:Juego
echo Compilando Juego.bas
c:\zxbasic\zxbc Juego.bas --org $8000 --heap-size 4096 --optimize 3 --tap --mmap Juego.map
if ERRORLEVEL 1 goto compilerError
echo.

:Minijuego
echo Compilando Minijuego.bas
c:\zxbasic\zxbc Minijuego.bas --org $8000 --heap-size 4096 --optimize 3 --tap --mmap Minijuego.map
if ERRORLEVEL 1 goto compilerError
echo.

:GameOver
echo Compilando GameOver.bas
c:\zxbasic\zxbc GameOver.bas --org $8000 --heap-size 4096 --optimize 3 --tap --mmap GameOver.map
if ERRORLEVEL 1 goto compilerError
echo.

:ComponerMaster
echo Montando Master.tap
copy /b Control.tap + Menu.tap + Juego.tap + Minijuego.tap + GameOver.tap Master.tap
echo.

:LanzarEmulador
echo Lanzando emulador...
"D:\ZX Spectrum\ZX Spin 0.7s\ZXSpin.exe" "c:\spectrum\Demo128\Master.tap"
goto fin


:compilerError
echo.
echo --------------------------------------------------------
echo - Compiler error!!! ------------------------------------
echo --------------------------------------------------------

:fin