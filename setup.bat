@echo off
net session >nul 2>&1 || (powershell -Command "Start-Process '%~0' -Verb RunAs" & exit /b)

echo [1/4] Mengatur Network Profile ke Private...
powershell -Command "Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private -ErrorAction SilentlyContinue" >nul

echo [2/4] Mengaktifkan Remote Registry Service...
sc config RemoteRegistry start= auto >nul
net start RemoteRegistry >nul 2>&1

echo [3/4] Membuka Firewall Rule...
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes >nul
netsh advfirewall firewall set rule group="Remote Shutdown" new enable=Yes >nul

echo [4/4] Bypass UAC Remote & Blank Password...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 1 /f >nul

echo.
echo SETUP SELESAI!
pause
