param (
    [switch]$lf,
    [switch]$fl
)

$localPath = "D:\Documents\Chabot College"
$flashPath = "E:\Chabot College"

function Sync-Folders($source, $destination) {
    if (!(Test-Path $source)) {
        Write-Host "Source path '$source' does not exist." -ForegroundColor Red
        return
    }
    if (!(Test-Path $destination)) {
        Write-Host "Destination path '$destination' does not exist. Creating it..." -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $destination -Force | Out-Null
    }

    Write-Host "Syncing from '$source' to '$destination'..." -ForegroundColor Cyan
    robocopy $source $destination /E /R:2 /W:5 /NFL /NDL /NP /NS /NC
    Write-Host "Sync complete." -ForegroundColor Green
}

if ($lf) {
    Sync-Folders -source $localPath -destination $flashPath
}
elseif ($fl) {
    Sync-Folders -source $flashPath -destination $localPath
}
else {
    Write-Host "Please specify -lf or -fl to sync." -ForegroundColor Yellow
}
