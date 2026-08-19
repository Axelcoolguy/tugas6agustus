@echo off
:: ====================================================================
:: AUTOMATED P2P SHUTDOWN SETUP & AGENT INSTALLER
:: Target Folder : C:\crypt\
:: Target Script : C:\crypt\agent.ps1
:: ====================================================================

:: 1. Force Auto-Elevate to Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Mengambil hak akses Administrator...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

echo ===================================================
echo   MEMULAI KONFIGURASI P2P SHUTDOWN AGENT
echo ===================================================
echo.

:: 2. Konfigurasi PowerShell Remoting & TrustedHosts
echo [1/4] Mengaktifkan PowerShell Remoting...
powershell -Command "Enable-PSRemoting -Force; Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*' -Force"

:: 3. Konfigurasi Firewall Rule untuk UDP Port 8888
echo [2/4] Membuka Port UDP 8888 di Firewall...
powershell -Command "New-NetFirewallRule -DisplayName 'P2P Shutdown Listener' -Direction Inbound -Protocol UDP -LocalPort 8888 -Action Allow -ErrorAction SilentlyContinue" >nul

:: 4. Buka Izin Limit Blank Password di Registry
echo [3/4] Mengatur Policy Password Registry...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f >nul

:: 5. Buat Task Scheduler Auto-Start pada System Startup
echo [4/4] Daftarkan Agent ke Task Scheduler...
schtasks /create /tn "P2P_Shutdown_Agent" /tr "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File \"C:\crypt\agent.ps1\"" /sc onstart /ru "SYSTEM" /rl highest /f >nul

:: 6. Jalankan Agent Pertama Kali Secara Instant
echo.
echo Jalankan Agent sekarang...
schtasks /run /tn "P2P_Shutdown_Agent" >nul

echo.
echo ===================================================
echo   SETUP BERHASIL! PC SIAP DIGUNAKAN DI JARINGAN P2P
echo ===================================================
echo.
pause
