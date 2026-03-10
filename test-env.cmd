@echo off
echo === CMD Environment Variable Test ===

echo PATH:
for %%A in ("%PATH:;=" "%") do echo   %%~A

pause