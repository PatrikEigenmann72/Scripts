@echo off
setlocal enabledelayedexpansion

REM Extract project name from current directory
for %%I in ("%CD%") do set PROJECT=%%~nI

echo Building %PROJECT%...
if not exist bin mkdir bin

if "%1"=="-debug" (
    echo Compiling with DEBUG flag...
    gcc -Wall -Wextra -std=c99 -Iinclude src\*.c -o bin\%PROJECT%.exe -DDEBUG
) else (
    gcc -Wall -Wextra -std=c99 -Iinclude src\*.c -o bin\%PROJECT%.exe
)

echo Installing to %USERPROFILE%\bin\%PROJECT%.exe ...
if not exist "%USERPROFILE%\bin" mkdir "%USERPROFILE%\bin"
copy /Y "bin\%PROJECT%.exe" "%USERPROFILE%\bin\"

echo Done. Type "%PROJECT%" to begin.
endlocal