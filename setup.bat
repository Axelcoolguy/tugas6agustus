@echo off
:: ====================================================================
:: SETUP PC TARGET (Untuk Metode Shutdown Remote IPC$ Authentication)
:: ====================================================================

:: 1. Force Auto-Elevate to Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Mengambil hak akses Administrator...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

echo ===================================================
echo   MEMULAI KONFIGURASI PC TARGET (REMOTE SHUTDOWN)
echo ===================================================
echo.

:: 2. Ubah Profil Jaringan ke Private (Agar sharing services aktif)
echo [1/5] Mengatur profil jaringan ke Private...
powershell -Command "Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private -ErrorAction SilentlyContinue" >nul

:: 3. Mengaktifkan File and Printer Sharing (Wajib untuk net use / IPC$)
echo [2/5] Mengaktifkan File and Printer Sharing...
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes >nul

:: 4. Bypass UAC Remote (Mengizinkan remote shutdown tanpa error Access Denied)
echo [3/5] Mengatur kebijakan Remote Admin (UAC)...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f >nul

:: 5. Mengizinkan Blank Password (Jika ada user tanpa password)
echo [4/5] Mengatur kebijakan Password kosong...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f >nul

:: 6. Mengaktifkan PowerShell Remoting (Fleksibilitas tambahan)
echo [5/5] Mengaktifkan PowerShell Remoting...
powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force" >nul

echo.
echo ===================================================
echo   SETUP BERHASIL! PC SIAP MENERIMA PERINTAH REMOTE
echo ===================================================
echo.
pause
