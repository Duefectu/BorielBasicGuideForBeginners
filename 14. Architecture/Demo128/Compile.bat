@echo off
cls
echo Compiling...
echo.

echo Cleaning previous compilations...
del Control.tap
del Menu.tap
del Game.tap
del MiniGames.tap
del GameOver.tap
del Master.tap
echo.

:Control
echo Compiling Control.bas
c:\zxbasic\zxbc Control.bas --org $6000 --heap-size 2048 --optimize 3 --tap --BASIC --autorun --mmap Control.map
if ERRORLEVEL 1 goto compilerError
echo.

:Menu
echo Compiling Menu.bas
c:\zxbasic\zxbc Menu.bas --org $8000 --heap-size 4096 --optimize 3 --tap --mmap Menu.map
if ERRORLEVEL 1 goto compilerError
echo.

:Juego
echo Compiling Game.bas
c:\zxbasic\zxbc Game.bas --org $8000 --heap-size 4096 --optimize 3 --tap --mmap Game.map
if ERRORLEVEL 1 goto compilerError
echo.

:MiniGame
echo Compiling MiniGame.bas
c:\zxbasic\zxbc MiniGame.bas --org $8000 --heap-size 4096 --optimize 3 --tap --mmap MiniGame.map
if ERRORLEVEL 1 goto compilerError
echo.

:GameOver
echo Compiling GameOver.bas
c:\zxbasic\zxbc GameOver.bas --org $8000 --heap-size 4096 --optimize 3 --tap --mmap GameOver.map
if ERRORLEVEL 1 goto compilerError
echo.

:ComponerMaster
echo Mounting Master.tap
copy /b Control.tap + Menu.tap + Game.tap + MiniGame.tap + GameOver.tap Master.tap
echo.

:LaunchEmulator
echo Launching emulador...
"D:\ZX Spectrum\ZX Spin 0.7s\ZXSpin.exe" "c:\spectrum\Demo128\Master.tap"
goto noError


:compilerError
echo.
echo --------------------------------------------------------
echo - Compiler error!!! ------------------------------------
echo --------------------------------------------------------

:noError