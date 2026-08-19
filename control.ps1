# ==========================================================
# P2P CONTROLLER - IPC$ AUTHENTICATION VERSION
# (Tanpa Agent, Hanya Butuh Username/Password Target)
# ==========================================================
Clear-Host
$subnet = "192.168.1" # GANTI SESUAI SUBNET KAMU
$discoveredPCs = @()

Write-Host "Mencari PC aktif di jaringan (Ping test)..." -ForegroundColor Yellow

# Scan IP yang aktif
for ($i = 1; $i -le 254; $i++) {
    $ip = "$subnet.$i"
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet -TimeoutSeconds 0.2) {
        $discoveredPCs += $ip
        Write-Host "Ditemukan PC di IP: $ip" -ForegroundColor Green
    }
}

if ($discoveredPCs.Count -eq 0) {
    Write-Host "Tidak ada PC aktif." -ForegroundColor Red
} else {
    Write-Host "`nDAFTAR IP PC:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $discoveredPCs.Count; $i++) {
        Write-Host "[$($i + 1)] IP: $($discoveredPCs[$i])"
    }
    
    $choice = Read-Host "Pilih nomor IP"
    if ([int]$choice -gt 0 -and [int]$choice -le $discoveredPCs.Count) {
        $targetIP = $discoveredPCs[[int]$choice - 1]
        
        # Minta Kredensial Target
        $user = Read-Host "Masukkan Username PC target (contoh: PC-Admin)"
        $pass = Read-Host "Masukkan Password PC target" -AsSecureString
        $plainPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))

        Write-Host "Mencoba otentikasi ke $targetIP..." -ForegroundColor Yellow
        
        # Langkah 1: Konek via IPC$
        net use "\\$targetIP\ipc$" /user:"$user" "$plainPass" /persistent:no > $null 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Berhasil login! Mengirim perintah shutdown..." -ForegroundColor Green
            # Langkah 2: Shutdown
            shutdown /m "\\$targetIP" /s /f /t 0
            # Langkah 3: Bersihkan koneksi
            net use "\\$targetIP\ipc$" /delete /y > $null 2>&1
        } else {
            Write-Host "GAGAL LOGIN! Cek Username/Password atau pastikan Firewall mengizinkan File Sharing." -ForegroundColor Red
        }
    }
}
Pause
