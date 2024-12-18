@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1

whoami /groups | find "Administrators" > nul
if %errorLevel% neq 0 (
    exit /b 1
)

:: Kayıt dosyalarının var olup olmadığını kontrol et ve varsa yükle
if exist "%~dp0RegistrationDomains.reg" (
    "%SystemRoot%\System32\reg.exe" import "%~dp0RegistrationDomains.reg"
)
if exist "%~dp0Vimeo.reg" (
    "%SystemRoot%\System32\reg.exe" import "%~dp0Vimeo.reg"
)

:: Sysinternals VolumeID aracını yükle
reg add "HKEY_CURRENT_USER\Software\Sysinternals\VolumeID" /v EulaAccepted /t REG_DWORD /d 1 /f

:: Mevcut dosyaları kopyala
if exist "%~dp0macc.exe" (
    copy /y "%~dp0macc.exe" "%SystemRoot%\System32\macc.exe"
)
if exist "%~dp0volumeid.exe" (
    copy /y "%~dp0volumeid.exe" "%SystemRoot%\System32\volumeid.exe"
)
if exist "%~dp0reg.vbs" (
    copy /y "%~dp0reg.vbs" "%SystemRoot%\System32\reg.vbs"
)
if exist "%~dp0disk.vbs" (
    copy /y "%~dp0disk.vbs" "%SystemRoot%\System32\disk.vbs"
)
if exist "%~dp0a.vbs" (
    copy /y "%~dp0a.vbs" "%SystemRoot%\System32\a.vbs"
)
if exist "%~dp0b.vbs" (
    copy /y "%~dp0b.vbs" "%SystemRoot%\System32\b.vbs"
)

:: VBS dosyalarını çalıştır
if exist "%SystemDrive%\System32\reg.vbs" (
    cscript "%SystemDrive%\System32\reg.vbs"
)
if exist "%SystemDrive%\System32\disk.vbs" (
    cscript "%SystemDrive%\System32\disk.vbs"
)

:: EFI bölümlerini bağla
mountvol X: /S

:: EFI dosyaları ile işlem yap
if exist "X:\EFI\Microsoft\Boot\bootmgfw.efi" (
    move X:\EFI\Microsoft\Boot\bootmgfw.efi X:\EFI\Microsoft\Boot\boot.efi
)
if exist "X:\EFI\Boot\bootx64.efi" (
    move X:\EFI\Boot\bootx64.efi X:\EFI\Boot\bootx64.efi.backup
)

if exist "%~dp0bootx64.efi" (
    copy /y "%~dp0BOOTX64.efi" "X:\EFI\Boot\BOOTX64.efi"
)
if exist "%~dp0startup.nsh" (
    copy /y "%~dp0startup.nsh" "X:\EFI\Boot\startup.nsh"
)
if exist "%~dp0amideefix64.efi" (
    copy /y "%~dp0amideefix64.efi" "X:\EFI\Boot\amideefix64.efi"
)
if exist "%~dp0afuefix64.efi" (
    copy /y "%~dp0afuefix64.efi" "X:\EFI\Boot\afuefix64.efi"
)
if exist "%~dp0amideefix64.efi" (
    copy /y "%~dp0amideefix64.efi" "X:\EFI\Boot\amideefix64.efi"
)

:: EFI bölümünü de-mount et
mountvol X: /D

:: Mevcut dosyaları çalıştır
if exist "%SystemRoot%\System32\macc.exe" (
    start "" "%SystemRoot%\System32\macc.exe"
)

if exist "%SystemRoot%\System32\b.vbs" (
    cscript "%SystemRoot%\System32\b.vbs"
)

:: Gereksiz dosyaları sil
if exist "%SystemDrive%\reg" (
    rmdir /s /q "%SystemDrive%\reg"
)
if exist "%SystemDrive%\dl" (
    rmdir /s /q "%SystemDrive%\dl"
)

exit
