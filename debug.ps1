# GANTI angka 192.168.1 sesuai subnet kamu (lihat dari ipconfig)
$subnet = "192.168.1" 

Write-Host "Mulai scan (ini mungkin agak lama, mohon tunggu)..." -ForegroundColor Yellow
for ($i = 1; $i -le 254; $i++) {
    $ip = "$subnet.$i"
    # Menggunakan ping standar tanpa timeoutseconds
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        Write-Host "PC ditemukan di IP: $ip" -ForegroundColor Green
    }
}
Write-Host "Scan Selesai." -ForegroundColor Cyan
Pause
