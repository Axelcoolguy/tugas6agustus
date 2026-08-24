@echo off
net session >nul 2>&1 || (powershell -Command "Start-Process '%~0' -Verb RunAs" & exit /b)

:: 1. Policy agar Shutdown Remote tanpa password diizinkan
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 1 /f

:: 2. Izin Firewall
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
netsh advfirewall firewall set rule group="Remote Shutdown" new enable=Yes

echo SETUP SELESAI. PC SIAP DIMATIKAN TANPA PASSWORD.
pause
