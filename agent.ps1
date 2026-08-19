# ==========================================
# P2P LISTENER AGENT (AUTO DETECT IP & USER)
# ==========================================
$port = 8888
$udpClient = New-Object System.Net.Sockets.UdpClient($port)
$remoteEP = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)

# Ambil IP Lokal & User yang sedang Login secara dinamis
$localIP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Wi-Fi","Ethernet*" | Where-Object {$_.IPAddress -notlike "169.254*" -and $_.IPAddress -ne "127.0.0.1"} | Select-Object -First 1).IPAddress
$currentUser = [System.Environment]::UserName
$computerName = $env:COMPUTERNAME

Write-Host "Agent aktif di $computerName ($localIP) - User: $currentUser..." -ForegroundColor Green

while ($true) {
    try {
        # Terima sinyal broadcast
        $bytes = $udpClient.Receive([ref]$remoteEP)
        $message = [System.Text.Encoding]::ASCII.GetString($bytes)

        if ($message -eq "DISCOVER_P2P_PCS") {
            # Kirim balik Identitas PC (Host, IP, User)
            $response = "$computerName|$localIP|$currentUser"
            $sendBytes = [System.Text.Encoding]::ASCII.GetBytes($response)
            $udpClient.Send($sendBytes, $sendBytes.Length, $remoteEP) | Out-Null
        }
    } catch {
        # Tangani error jika ada interrupted socket
    }
}
