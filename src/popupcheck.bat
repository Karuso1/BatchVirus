:: Quick batch file to check if the popup works

@echo off
:: Create the popup window
set "VBS_FILE=%temp%\warning_temp_%random%.vbs"

echo x=MsgBox("This script contains malicious content, run at your own risk. The author is not responsible for any damage.", 48 + 4, "Warning") > "%VBS_FILE%"
echo If x=7 Then WScript.Quit >> "%VBS_FILE%"

wscript //nologo "%VBS_FILE%"
if errorlevel 1 goto :Abort

:: Clean up the temporary VBS file
del "%VBS_FILE%" >nul 2>&1

:Abort
echo Operation cancelled by user. Exiting.
pause
