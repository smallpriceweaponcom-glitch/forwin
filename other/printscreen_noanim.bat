@echo off
chcp 65001 > nul

:: Перевірка прав адміністратора
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] ПОМИЛКА: ЗАПУСТІТЬ ВІД ІМЕНІ АДМІНІСТРАТОРА!
    pause
    exit /b
)

echo [Крок 1] Класичний PrintScreen...
:: Повертаємо миттєвий скріншот у буфер без затемнення
reg add "HKCU\Control Panel\Keyboard" /v "PrintScreenKeyForSnippingEnabled" /t REG_DWORD /d 0 /f

echo [Крок 2] Вимкнення всіх анімацій...
:: Вікна відкриваються і закриваються миттєво
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_STR /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f

echo [Крок 3] Вимкнення ефектів прозорості...
:: Робимо панель завдань та вікна суцільними (без ефекту скла)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f

echo [Крок 4] Застосування змін...
:: Перезапуск провідника для оновлення графічного інтерфейсу
taskkill /f /im explorer.exe
start explorer.exe

echo.
echo ======================================================
echo [OK] Налаштування завершено:
echo - PrintScreen працює миттєво.
echo - Анімації повністю вимкнено.
echo - Прозорість панелі завдань та вікон вимкнена.
echo ======================================================
pause
