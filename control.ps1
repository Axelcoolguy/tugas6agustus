# ==========================================================
# P2P SHUTDOWN GRID CONTROLLER
# ==========================================================
# Input IP PC Target kamu di sini (Urutan 1-10)
$pcList = @(
    @{Name="PC 1";  IP="192.168.1.10"}, @{Name="PC 2";  IP="192.168.1.11"}, @{Name="PC 3";  IP="192.168.1.12"}, @{Name="PC 4";  IP="192.168.1.13"}, @{Name="PC 5";  IP="192.168.1.14"},
    @{Name="PC 6";  IP="192.168.1.15"}, @{Name="PC 7";  IP="192.168.1.16"}, @{Name="PC 8";  IP="192.168.1.17"}, @{Name="PC 9";  IP="192.168.1.18"}, @{Name="PC 10"; IP="192.168.1.19"}
)

function Show-Grid {
    Clear-Host
    Write-Host "================= GRID MONITOR (2x5) =================" -ForegroundColor Cyan
    $statusList = @()
    for($i=0; $i -lt 10; $i++){
        $isUp = Test-Connection -ComputerName $pcList[$i].IP -Count 1 -Quiet
        $statusList += if($isUp) { "ON" } else { "OFF" }
    }
    
    # Baris 1
    for($i=0; $i -lt 5; $i++){ Write-Host "[$($i+1)] $($pcList[$i].Name): " -NoNewline; if($statusList[$i] -eq "ON") { Write-Host " ON " -ForegroundColor Green -BackgroundColor Black -NoNewline } else { Write-Host " OFF" -ForegroundColor Red -BackgroundColor Black -NoNewline }; Write-Host " | " -NoNewline }
    Write-Host ""
    # Baris 2
    for($i=5; $i -lt 10; $i++){ Write-Host "[$($i+1)] $($pcList[$i].Name): " -NoNewline; if($statusList[$i] -eq "ON") { Write-Host " ON " -ForegroundColor Green -BackgroundColor Black -NoNewline } else { Write-Host " OFF" -ForegroundColor Red -BackgroundColor Black -NoNewline }; Write-Host " | " -NoNewline }
    
    Write-Host "`n`n[A] Shutdown SEMUA | [R] Refresh | [0] Keluar" -ForegroundColor Yellow
}

while($true){
    Show-Grid
    $in = Read-Host "`nInput Perintah"
    if($in -eq '0') { break }
    if($in -eq 'R') { continue }
    if($in -eq 'A') {
        $confirm = Read-Host "YAKIN MATIKAN SEMUA? (y/n)"
        if($confirm -eq 'y') { foreach($pc in $pcList) { shutdown /m "\\$($pc.IP)" /s /f /t 0 } }
    } elseif([int]$in -gt 0 -and [int]$in -le 10) {
        $target = $pcList[[int]$in - 1]
        shutdown /m "\\$($target.IP)" /s /f /t 0
        Write-Host "Perintah dikirim ke $($target.Name)" -ForegroundColor Green; Start-Sleep -Seconds 2
    }
}
