@echo off
title System Information

:menu
cls
echo Select Information Category:
echo 1: Operating System
echo 2: Manufacturer and Model
echo 3: IP Address
echo 4: Installed Programs
echo 5: System Uptime
echo 6: Battery Information (if available)
echo 7: Uninstall Programs
echo 8: Exit

choice /c 12345678 /n /m "Enter your choice:"

if errorlevel 8 exit /b
if errorlevel 7 goto uninstall_programs
if errorlevel 6 goto battery_info
if errorlevel 5 goto uptime
if errorlevel 4 goto installed_programs
if errorlevel 3 goto ip_info
if errorlevel 2 goto manufacturer_model
if errorlevel 1 goto os_info

:os_info
cls
echo ------------------------------
echo Operating System:
systeminfo | find "OS Name"
pause
goto menu

:manufacturer_model
cls
echo ------------------------------
echo Manufacturer:
systeminfo | find "System Manufacturer"
echo Model:
systeminfo | find "System Model"
pause
goto menu

:ip_info
cls
echo ------------------------------
echo IP Address:
ipconfig | findstr /i "IPv4"
pause
goto menu

:installed_programs
cls
echo ------------------------------
echo Installed Programs:
wmic product get name, version | findstr /r /v "^$" > programs.txt

setlocal enabledelayedexpansion
set "counter=1"

for /f "skip=1 delims=" %%G in (programs.txt) do (
    echo !counter!: %%G
    set /a "counter+=1"
)

del programs.txt

pause
goto menu

:uninstall_programs
cls
echo ------------------------------
echo Uninstall Programs:
wmic product get name, version | findstr /r /v "^$" > programs.txt

setlocal enabledelayedexpansion
set "counter=1"

for /f "skip=1 delims=" %%G in (programs.txt) do (
    echo !counter!: %%G
    set /a "counter+=1"
)

del programs.txt

set /p program="Enter the number of the program you want to uninstall: "

for /f "usebackq tokens=1,* delims=:" %%A in (`findstr /n "^" programs.txt`) do (
    if "%%A"=="%program%" (
        set "selectedProgram=%%B"
        goto uninstall_confirm
    )
)

:uninstall_confirm
cls
echo ------------------------------
echo Uninstall Program:
echo %selectedProgram%
pause

wmic product where name="%selectedProgram%" call uninstall /nointeractive

goto menu

:uptime
cls
echo ------------------------------
echo System Uptime:
systeminfo | find "System Up Time"
pause
goto menu

:battery_info
cls
echo ------------------------------
echo Battery Information (if available):
wmic path win32_battery get EstimatedChargeRemaining, EstimatedRunTime
pause
goto menu
