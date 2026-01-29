@echo off
:: Встановлюємо кодування UTF-8
chcp 65001 > nul

:: [ПЕРЕВІРКА ПРАВ АДМІНІСТРАТОРА]
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo ПОМИЛКА: ЗАПУСТІТЬ СКРИПТ ВІД ІМЕНІ АДМІНІСТРАТОРА!
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo.
    pause
    exit /b
)

echo [Крок 1] Повернення стандартного запуску служб...
:: Встановлюємо тип запуску: "Вручну" (demand) та "Авто (відкладено)" (delayed-auto)
sc config wuauserv start= demand
sc config bits start= delayed-auto
sc config dosvc start= demand

echo [Крок 2] Розблокування Medic Service у реєстрі...
:: Повертаємо значення 3 (Запуск вручну), щоб система могла використовувати сервіс
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d 3 /f

echo [Крок 3] Видалення заборони на автооновлення...
:: Видаляємо ключ NoAutoUpdate, який ми створювали в STOP-скрипті
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /f >nul 2>&1

echo [Крок 4] Запуск служб...
:: Активуємо служби прямо зараз
net start wuauserv
net start bits
net start dosvc

echo.
echo ======================================================
echo [OK] Центр оновлень успішно відновлено!
echo Тепер ви можете перевірити наявність оновлень у Параметрах.
echo ======================================================

:: Перезавантаження для повного відновлення всіх процесів
shutdown /r /t 15 /c "Відновлення оновлень Windows. Перезавантаження через 15 секунд..."
