@echo off
:: Встановлюємо кодування UTF-8
chcp 65001 > nul

:: [ПЕРЕВІРКА ПРАВ АДМІНІСТРАТОРА]
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo ПОМИЛКА: ЗАПУСТІТЬ СКРИПТ ВІД ІМЕНІ АДМІНІСТРАТОРА!
    echo (Правий клік на файл -> Запуск від імені адміністратора)
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo.
    pause
    exit /b
)

echo [Крок 1] Зупинка активних служб...
net stop wuauserv /y
net stop bits /y
net stop dosvc /y
net stop waasmedicsvc /y

echo [Крок 2] Вимкнення автозапуску служб...
sc config wuauserv start= disabled
sc config bits start= disabled
sc config dosvc start= disabled

echo [Крок 3] Блокування Windows Update Medic Service...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d 4 /f

echo [Крок 4] Встановлення заборони в політиках реєстру...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f

echo [Крок 5] Видалення завантажених файлів оновлень...
rd /s /q %systemroot%\SoftwareDistribution\Download
mkdir %systemroot%\SoftwareDistribution\Download

echo.
echo ======================================================
echo [OK] Блокування завершено успішно!
echo Система буде перезавантажена через 15 секунд.
echo ======================================================

:: Перезавантаження
shutdown /r /t 15 /c "Блокування оновлень Windows застосовано. Очікуйте перезавантаження..."
