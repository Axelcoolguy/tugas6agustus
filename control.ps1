# ==========================================================
# P2P CONTROLLER - SUB_SCANNER VERSION (LEBIH STABIL)
# ==========================================================
Clear-Host
Write-Host "Mendeteksi IP Subnet lokal..." -ForegroundColor Cyan
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Wi-Fi","Ethernet*" | Where-Object {$_.IPAddress -notlike "169.254*" -and $_.IPAddress -ne "127.0.0.1"} | Select-Object -First 1).IPAddress
$subnet = $ipAddress.Substring(0, $ipAddress.LastIndexOf('.'))
$discoveredPCs = @()

Write-Host "Scanning subnet: $subnet.1 - $subnet.254 (Harap tunggu...)" -ForegroundColor Yellow

# Scan semua IP di subnet (1 sampai 254)
for ($i = 1; $i -le 254; $i++) {
    $targetIP = "$subnet.$i"
    
    # Hanya ping jika bukan IP sendiri untuk menghemat waktu
    if ($targetIP -ne $ipAddress) {
        if (Test-Connection -ComputerName $targetIP -Count 1 -Quiet -TimeoutSeconds 0.2) {
            # Kalau ping nyambung, coba cek apakah ada service Agent yang jalan
            # Kita gunakan koneksi simpel ke port 8888 (port agent kita)
            $tcp = New-Object System.Net.Sockets.TcpClient
            $connect = $tcp.BeginConnect($targetIP, 8888, $null, $null)
            $wait = $connect.AsyncWaitHandle.WaitOne(200, $false)
            
            if ($wait) {
                # Jika port 8888 terbuka, kita anggap itu PC Agent
                $discoveredPCs += [PSCustomObject]@{
                    IP = $targetIP
                }
            }
            $tcp.Close()
        }
    }
}

# Sekarang kita punya daftar IP, mari ambil Hostname & User
Write-Host "Menyusun data..." -ForegroundColor Green
$finalList = @()
foreach ($pc in $discoveredPCs) {
    try {
        $info = Invoke-Command -ComputerName $pc.IP -ScriptBlock { "$env:COMPUTERNAME|$env:USERNAME" } -ErrorAction SilentlyContinue
        if ($info) {
            $parts = $info.Split("|")
            $finalList += [PSCustomObject]@{ HostName=$parts[0]; IP=$pc.IP; User=$parts[1] }
        }
    } catch {}
}

# Tampilkan Hasil
Clear-Host
for ($i = 0; $i -lt $finalList.Count; $i++) {
    Write-Host "[$($i + 1)] Host: $($finalList[$i].HostName) | IP: $($finalList[$i].IP) | User: $($finalList[$i].User)" -ForegroundColor Green
}

if ($finalList.Count -eq 0) {
    Write-Host "Tidak ada PC lain yang ditemukan. Pastikan Firewall mengizinkan port 8888." -ForegroundColor Red
} else {
    $choice = Read-Host "Pilih nomor PC (0 untuk batal)"
    if ([int]$choice -gt 0 -and [int]$choice -le $finalList.Count) {
        $target = $finalList[[int]$choice - 1]
        Write-Host "Mematikan $($target.HostName)..." -ForegroundColor Red
        Stop-Computer -ComputerName $target.IP -Force
    }
}
Pause
