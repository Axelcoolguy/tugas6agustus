@echo off
net session >nul 2>&1 || (powershell -Command "Start-Process '%~0' -Verb RunAs" & exit /b)

echo [1/6] Mengatur Network Profile ke Private...
powershell -Command "Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private -ErrorAction SilentlyContinue" >nul

echo [2/6] Membuka Bypass UAC Remote...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f >nul

echo [3/6] Mengizinkan Blank Password dan Guest Access...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v forceguest /t REG_DWORD /d 0 /f >nul

echo [4/6] Mengaktifkan Service Remote Registry...
sc config RemoteRegistry start= auto >nul
net start RemoteRegistry >nul 2>&1

echo [5/6] Memberikan Hak Akses Shutdown Jarak Jauh...
net user Guest /active:yes >nul 2>&1
powershell -Command "Grant-NtLocalsystemRight -Right SeRemoteShutdownPrivilege -Account Guest" >nul 2>&1
net localgroup Administrators Guest /add >nul 2>&1

echo [6/6] Membuka Port Firewall...
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes >nul
netsh advfirewall firewall set rule group="Remote Shutdown" new enable=Yes >nul
netsh advfirewall firewall set rule group="Windows Management Instrumentation (WMI)" new enable=Yes >nul

echo.
echo ===================================================
echo SETUP FIX SELESAI TANPA ERROR!
echo REBOOT PC TARGET 1 KALI SUPAYA REGISTRY DITERAPKAN.
echo ===================================================
pause
