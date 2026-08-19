@echo off
:: Jalankan sebagai Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (powershell -Command "Start-Process '%~0' -Verb RunAs" & exit /b)

echo [1/3] Mengatur Network ke Private & Firewall...
powershell -Command "Set-NetConnectionProfile -NetworkCategory Private"
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes >nul

echo [2/3] Membuka akses UAC Remote (Agar Shutdown bisa)...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f >nul

echo [3/3] Mengizinkan koneksi Guest/Blank Password...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f >nul

echo ===================================================
echo SETUP SELESAI. PC SUDAH SIAP DI-REMOTE.
echo ===================================================
pause
