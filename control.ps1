# ==========================================================
# P2P SHUTDOWN GRID CONTROLLER (FIXED AUTO-CONNECT)
# ==========================================================
$pcList = @(
    @{Name="PC 1";  IP="192.168.125.1"},
    @{Name="PC 2";  IP="192.168.125.2"},
    @{Name="PC 3";  IP="192.168.125.3"},
    @{Name="PC 4";  IP="192.168.125.4"},
    @{Name="PC 5";  IP="192.168.125.5"},
    @{Name="PC 6";  IP="192.168.125.209"},
    @{Name="PC 7";  IP="192.168.125.178"},
    @{Name="PC 8";  IP="192.168.125.194"},
    @{Name="PC 9";  IP="192.168.125.101"},
    @{Name="PC 10"; IP="192.168.125.10"}
)

function Exec-RemoteShutdown ($targetIP) {
    # Trik Handshake IPC$ tanpa password agar sesi diterima
    net use "\\$targetIP\ipc$" "" /user:"" /persistent:no > $null 2>&1
    shutdown /m "\\$targetIP" /s /f /t 0
    net use "\\$targetIP\ipc$" /delete /y > $null 2>&1
}

function Show-Grid {
    Clear-Host
    Write-Host "================= GRID MONITOR (2x5) =================" -ForegroundColor Cyan
    $statusList = @()
    for($i=0; $i -lt 10; $i++){
        $isUp = Test-Connection -ComputerName $pcList[$i].IP -Count 1 -Quiet
        $statusList += if($isUp) { "ON" } else { "OFF" }
    }

    # Baris 1 (PC 1-5)
    for($i=0; $i -lt 5; $i++){ 
        Write-Host "[$($i+1)] $($pcList[$i].Name): " -NoNewline
        if($statusList[$i] -eq "ON") { Write-Host " ON " -ForegroundColor Green -BackgroundColor Black -NoNewline } 
        else { Write-Host " OFF" -ForegroundColor Red -BackgroundColor Black -NoNewline }
        Write-Host " | " -NoNewline 
    }
    Write-Host ""
    
    # Baris 2 (PC 6-10)
    for($i=5; $i -lt 10; $i++){ 
        Write-Host "[$($i+1)] $($pcList[$i].Name): " -NoNewline
        if($statusList[$i] -eq "ON") { Write-Host " ON " -ForegroundColor Green -BackgroundColor Black -NoNewline } 
        else { Write-Host " OFF" -ForegroundColor Red -BackgroundColor Black -NoNewline }
        Write-Host " | " -NoNewline 
    }

    Write-Host "`n`n[A] Shutdown SEMUA | [R] Refresh | [0] Keluar" -ForegroundColor Yellow
}

while($true){
    Show-Grid
    $in = Read-Host "`nInput Perintah"
    if($in -eq '0') { break }
    if($in -eq 'R') { continue }
    if($in -eq 'A') {
        $confirm = Read-Host "YAKIN MATIKAN SEMUA? (y/n)"
        if($confirm -eq 'y') { 
            foreach($pc in $pcList) { Exec-RemoteShutdown $pc.IP } 
        }
    } elseif([int]$in -gt 0 -and [int]$in -le 10) {
        $target = $pcList[[int]$in - 1]
        Exec-RemoteShutdown $target.IP
        Write-Host "Perintah dikirim ke $($target.Name)..." -ForegroundColor Green
        Start-Sleep -Seconds 2
    }
}
