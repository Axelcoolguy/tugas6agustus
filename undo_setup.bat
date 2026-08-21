@echo off
:: Auto-Elevate to Administrator
net session >nul 2>&1 || (powershell -Command "Start-Process '%~0' -Verb RunAs" & exit /b)

echo ===================================================
echo   REVERTING SETUP (KEBALIKAN DARI SETUP LAMA)
echo ===================================================
echo.

:: 1. Kembalikan UAC Remote Admin Policy (Hapus token filter bypass)
echo [1/4] Mengembalikan kebijakan Remote Admin (UAC)...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /f >nul 2>&1

:: 2. Kembalikan Limit Blank Password (Kunci kembali akun tanpa password)
echo [2/4] Mengunci kembali akses akun tanpa password...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 1 /f >nul

:: 3. Hapus Firewall Rule Remote Shutdown (Kunci akses shutdown jauh)
echo [3/4] Menutup port Remote Shutdown di Firewall...
netsh advfirewall firewall set rule group="Remote Shutdown" new enable=No >nul 2>&1
netsh advfirewall firewall delete rule name="Allow Port 8888" >nul 2>&1
netsh advfirewall firewall delete rule name="Allow P2P UDP 8888" >nul 2>&1
netsh advfirewall firewall delete rule name="Allow WMI" >nul 2>&1

:: 4. MEMPASTIKAN FILE & PRINTER SHARING TETAP NYALA (Untuk Shared Folder)
echo [4/4] Memastikan File & Printer Sharing tetap AKTIF...
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes >nul

echo.
echo ===================================================
echo REVERT SELESAI. SISTEM KEMBALI AMAN & SHARED FOLDER TETAP AKTIF.
echo ===================================================
pause
