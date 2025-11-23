# install.ps1

# Extract project name from current directory
$PROJECT = Split-Path -Leaf (Get-Location)

Write-Host "Building $PROJECT..."
New-Item -ItemType Directory -Force -Path "bin" | Out-Null

if ($args.Count -gt 0 -and $args[0] -eq "-debug") {
    Write-Host "Compiling with DEBUG flag..."
    gcc -Wall -Wextra -std=c99 -Iinclude src\*.c -o "bin\$PROJECT.exe" -DDEBUG
} else {
    gcc -Wall -Wextra -std=c99 -Iinclude src\*.c -o "bin\$PROJECT.exe"
}

Write-Host "Installing to $env:USERPROFILE\bin\$PROJECT.exe ..."
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\bin" | Out-Null
Copy-Item "bin\$PROJECT.exe" "$env:USERPROFILE\bin\" -Force

Write-Host "Done. Type '$PROJECT' to begin."