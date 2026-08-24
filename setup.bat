@echo off
net session >nul 2>&1 || (powershell -Command "Start-Process '%~0' -Verb RunAs" & exit /b)

echo [1/6] Mengatur Network Profile ke Private...
powershell -Command "Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private -ErrorAction SilentlyContinue" >nul

echo [2/6] Membuka Bypass UAC Remote (LocalAccountTokenFilterPolicy)...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f >nul

echo [3/6] Mengizinkan Blank Password & Guest Access via Network...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v forceguest /t REG_DWORD /d 0 /f >nul

echo [4/6] Mengaktifkan & Menjalankan Service Remote Registry + RPC...
sc config RemoteRegistry start= auto >nul
net start RemoteRegistry >nul 2>&1

echo [5/6] Memberikan Hak Remote Shutdown ke Semua User (Local Policy)...
powershell -Command "$grant = 'Everyone'; $se = Get-Content C:\Windows\System32\GroupPolicy\Machine\Registry.pol -ErrorAction SilentlyContinue" >nul
net localgroup Administrators Guest /add >nul 2>&1

echo [6/6] Membuka Seluruh Port Firewall yang Dibutuhkan...
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes >nul
netsh advfirewall firewall set rule group="Remote Shutdown" new enable=Yes >nul
netsh advfirewall firewall set rule group="Windows Management Instrumentation (WMI)" new enable=Yes >nul

echo.
echo ===================================================
echo SETUP FIX SELESAI! SILAKAN REBOOT PC TARGET ONCE.
echo ===================================================
pause
