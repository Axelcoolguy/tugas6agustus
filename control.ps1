# ==========================================
# P2P CONTROLLER (AUTO DISCOVERY & SHUTDOWN)
# ==========================================
Clear-Host
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   MENCARI PC AKTIF DI JARINGAN LOKAL...  " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$port = 8888
$udpClient = New-Object System.Net.Sockets.UdpClient
$udpClient.Client.ReceiveTimeout = 2000 # Timeout pencarian 2 detik
$udpClient.EnableBroadcast = $true

# Kirim sinyal pencarian
$broadcastEP = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Broadcast, $port)
$requestBytes = [System.Text.Encoding]::ASCII.GetBytes("DISCOVER_P2P_PCS")
$udpClient.Send($requestBytes, $requestBytes.Length, $broadcastEP) | Out-Null

$discoveredPCs = @()
$remoteEP = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)

# Kumpulkan jawaban dari PC lain
$startTime = Get-Date
while ((Get-Date) -lt $startTime.AddSeconds(2)) {
    try {
        $responseBytes = $udpClient.Receive([ref]$remoteEP)
        $responseData = [System.Text.Encoding]::ASCII.GetString($responseBytes)
        $parts = $responseData.Split("|")
        
        # Simpan jika belum ada di daftar
        if (-not ($discoveredPCs | Where-Object { $_.IP -eq $parts[1] })) {
            $discoveredPCs += [PSCustomObject]@{
                HostName = $parts[0]
                IP       = $parts[1]
                User     = $parts[2]
            }
        }
    } catch {
        # Timeout/Selesai mencari
    }
}
$udpClient.Close()

# Tampilkan Hasil Pencarian
if ($discoveredPCs.Count -eq 0) {
    Write-Host "Tidak ada PC lain yang ditemukan di jaringan." -ForegroundColor Yellow
    Pause
    exit
}

for ($i = 0; $i -lt $discoveredPCs.Count; $i++) {
    $pc = $discoveredPCs[$i]
    Write-Host "[$($i + 1)] Host: $($pc.HostName) | IP: $($pc.IP) | Active User: $($pc.User)" -ForegroundColor Green
}

Write-Host "------------------------------------------"
Write-Host "[A] MATIKAN SEMUA PC DALAM LIST" -ForegroundColor Red
Write-Host "[0] Batal / Keluar" -ForegroundColor Yellow
Write-Host "------------------------------------------"

$choice = Read-Host "Pilih nomor PC yang ingin dimatikan"

if ($choice -eq "0" -or [string]::IsNullOrWhitespace($choice)) {
    exit
}

# Eksekusi Perintah Shutdown Remote
if ($choice -eq "A" -or $choice -eq "a") {
    foreach ($pc in $discoveredPCs) {
        Write-Host "Mematikan $($pc.HostName) ($($pc.IP))..." -ForegroundColor Red
        Stop-Computer -ComputerName $pc.IP -Force -ErrorAction SilentlyContinue
    }
}
elseif ([int]$choice -gt 0 -and [int]$choice -le $discoveredPCs.Count) {
    $target = $discoveredPCs[[int]$choice - 1]
    Write-Host "Mengirim sinyal shutdown ke $($target.HostName) ($($target.IP)) [User: $($target.User)]..." -ForegroundColor Yellow
    
    Stop-Computer -ComputerName $target.IP -Force -ErrorAction Stop
    Write-Host "Berhasil! PC $($target.HostName) sedang dimatikan." -ForegroundColor Green
}
else {
    Write-Host "Pilihan tidak valid!" -ForegroundColor Red
}

Pause
