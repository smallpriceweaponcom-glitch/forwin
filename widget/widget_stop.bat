@echo off
chcp 65001 > nul
echo [Крок 1] Вимкнення віджетів через реєстр...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f

echo [Крок 2] Перезапуск Провідника для застосування змін...
taskkill /f /im explorer.exe
start explorer.exe

echo.
echo [OK] Віджети приховано.
pause
