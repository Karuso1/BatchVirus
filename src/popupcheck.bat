:: Quick batch file to check if the popup works

@echo off
powershell -NoProfile -Command "[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $r = [System.Windows.Forms.MessageBox]::Show('This script contains malicious content. Run at your own risk. The author is not responsible for any damage.','Warning',[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Exclamation); if($r -eq 'No'){ exit 1 }"
pause
