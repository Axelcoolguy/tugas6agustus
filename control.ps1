# ==========================================================
# P2P CONTROLLER - COMPATIBILITY VERSION (No Timeout Parameter)
# ==========================================================
Clear-Host
$subnet = "192.168.1" # GANTI SESUAI SUBNET KAMU (lihat ipconfig)
$discoveredPCs = @()

Write-Host "Mencari PC aktif di jaringan $subnet.x (Tunggu sebentar...)" -ForegroundColor Yellow

for ($i = 1; $i -le 254; $i++) {
    $ip = "$subnet.$i"
    # Skip IP sendiri
    if ($ip -eq $env:COMPUTERNAME) { continue }
    
    # Ping standar tanpa TimeoutSeconds agar kompatibel di semua versi Windows
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        
        # Coba panggil nama PC-nya via PowerShell Remoting
        $data = Invoke-Command -ComputerName $ip -ScriptBlock { "$env:COMPUTERNAME|$env:USERNAME" } -ErrorAction SilentlyContinue
        
        if ($data) {
            $parts = $data.Split("|")
            $discoveredPCs += [PSCustomObject]@{ HostName=$parts[0]; IP=$ip; User=$parts[1] }
            Write-Host "Ditemukan: $($parts[0]) ($ip)" -ForegroundColor Green
        }
    }
}

if ($discoveredPCs.Count -eq 0) {
    Write-Host "`nTidak ada PC yang bisa diakses." -ForegroundColor Red
    Write-Host "PENTING: Pastikan Username & Password Windows di semua PC SAMA." -ForegroundColor Yellow
} else {
    Write-Host "`nDAFTAR PC YANG BISA DIMATIKAN:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $discoveredPCs.Count; $i++) {
        Write-Host "[$($i + 1)] $($discoveredPCs[$i].HostName) | User: $($discoveredPCs[$i].User) | IP: $($discoveredPCs[$i].IP)"
    }
    
    $choice = Read-Host "Pilih nomor PC (0 untuk batal)"
    if ([int]$choice -gt 0 -and [int]$choice -le $discoveredPCs.Count) {
        $target = $discoveredPCs[[int]$choice - 1]
        Write-Host "Mematikan $($target.HostName)..." -ForegroundColor Red
        Stop-Computer -ComputerName $target.IP -Force
        Write-Host "Perintah terkirim." -ForegroundColor Green
    }
}
Pause
