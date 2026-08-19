# ==========================================================
# P2P CONTROLLER - MANUAL IP LIST (STABIL)
# ==========================================================
Clear-Host

# --- INPUT MANUAL IP DISINI ---
$pcList = @(
    @{ Name = "PC Kasir";   IP = "192.168.1.10" },
    @{ Name = "PC Gudang";  IP = "192.168.1.11" },
    @{ Name = "PC Admin";   IP = "192.168.1.12" }
)

Write-Host "Mengecek status PC..." -ForegroundColor Yellow

$i = 1
foreach ($pc in $pcList) {
    $status = if (Test-Connection -ComputerName $pc.IP -Count 1 -Quiet) { "ONLINE" } else { "OFFLINE" }
    $color = if ($status -eq "ONLINE") { "Green" } else { "Red" }
    Write-Host "[$i] $($pc.Name) ($($pc.IP)) - STATUS: $status" -ForegroundColor $color
    $pc.Status = $status
    $i++
}

Write-Host "------------------------------------------"
$choice = Read-Host "Pilih nomor PC (0 untuk batal)"

if ([int]$choice -gt 0 -and [int]$choice -le $pcList.Count) {
    $target = $pcList[[int]$choice - 1]
    
    if ($target.Status -eq "OFFLINE") {
        Write-Host "PC sedang mati/offline!" -ForegroundColor Red
        Pause; exit
    }

    Write-Host "--- LOGIN KE $($target.Name) ---"
    $user = Read-Host "Masukkan Username PC target"
    $pass = Read-Host "Masukkan Password PC target" -AsSecureString
    $plainPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))

    Write-Host "Menghubungkan..." -ForegroundColor Yellow
    
    # Konek & Shutdown
    net use "\\$($target.IP)\ipc$" /user:"$user" "$plainPass" /persistent:no > $null 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Berhasil login! Mematikan PC..." -ForegroundColor Green
        shutdown /m "\\$($target.IP)" /s /f /t 0
        net use "\\$($target.IP)\ipc$" /delete /y > $null 2>&1
    } else {
        Write-Host "GAGAL LOGIN! Cek User/Pass atau cek Firewall PC target." -ForegroundColor Red
    }
}
Pause
