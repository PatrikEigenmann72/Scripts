# Show local IPs
Write-Host "=== Local IP Addresses ===" -ForegroundColor Green
Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.IPAddress -ne "127.0.0.1" } |
    ForEach-Object { Write-Host $_.IPAddress }

# Define ranges to scan (add more if needed)
$ranges = @("192.168.0", "192.168.1", "10.0.0", "172.16.0", "169.254")

foreach ($range in $ranges) {
    Write-Host "`n=== Scanning $range.* ===" -ForegroundColor Yellow
    1..254 | ForEach-Object {
        $ip = "$range.$_"
        if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
            Write-Host "$ip is alive"
        }
    }
}