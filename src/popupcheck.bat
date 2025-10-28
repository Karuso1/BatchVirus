:: Checking if the popup window work

@echo off
:: --- Insert this section at the start of your script ---
set "VBS_FILE=%temp%\warning_temp_%random%.vbs"

echo x=MsgBox("This script contains malicious content, run at your own risk. The author has no responsibility of your damage.", 48 + 4, "Warning") > "%VBS_FILE%"
echo If x=7 Then WScript.Quit >> "%VBS_FILE%"

wscript //nologo "%VBS_FILE%"
if errorlevel 1 goto :Abort

:: Clean up the temporary VBS file
del "%VBS_FILE%" >nul 2>&1

:: --- Add this label at the end of your script ---
:Abort
echo Operation cancelled by user. Exiting.
pause
