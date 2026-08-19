$subnet = "192.168.1"  # GANTI SESUAI SUBNET KAMU (misal 192.168.0 atau 10.0.0)
Write-Host "Scanning..." -ForegroundColor Yellow
for ($i = 1; $i -le 254; $i++) {
    $ip = "$subnet.$i"
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet -TimeoutSeconds 0.2) {
        Write-Host "PC ditemukan di IP: $ip" -ForegroundColor Green
        # Coba cek apakah WinRM (skrip agent) jalan
        try {
            $s = New-PSSession -ComputerName $ip -SessionOption (New-PSSessionOption -IdleTimeout 5000) -ErrorAction Stop
            Write-Host "   -> Bisa diakses (WinRM OK)" -ForegroundColor Cyan
            Remove-PSSession $s
        } catch {
            Write-Host "   -> Tidak bisa diakses (WinRM Access Denied)" -ForegroundColor Red
        }
    }
}
Pause
