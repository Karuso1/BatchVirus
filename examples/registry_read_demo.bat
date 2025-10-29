@echo off
:: registry_read_demo.bat
:: SANITIZED — safe to run. Reads environment variables from registry and prints them.
:: Purpose: demonstrate registry inspection without modifications.

echo -- HKCU\Environment values --
reg query "HKCU\Environment" 2>nul || echo (none found)

echo.
echo -- HKLM SYSTEM\Environment values --
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" 2>nul || echo (none found)

pause
