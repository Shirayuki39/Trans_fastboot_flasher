@echo off
title Transsion mt6789 Fastboot ROM Flasher

echo ###########################################################
echo #          Transsion mt6789 Fastboot ROM Flasher          #
echo #             Originally Developed/Tested By              #
echo #  HELLBOY017, viralbanda, spike0en, PHATwalrus, arter97  #
echo #        [From Nothing Phone (2) Telegram Dev Team]       #
echo #          Adapted for Transsion mt6789 by rama982        #
echo #        Modified to flash both slots by Shirayuki39      #
echo ###########################################################

cd %~dp0
set fastboot=.\fastboot.exe

echo #############################
echo # CHANGING ACTIVE SLOT TO A #
echo #############################
%fastboot% --set-active=a

echo ##########################
echo # REBOOTING TO FASTBOOTD #
echo ##########################
%fastboot% reboot fastboot

echo #####################
echo # FLASHING FIRMWARE #
echo #####################
for %%i in (dpm gz lk mcupm md1img pi_img scp spmfw sspm tee tkv) do (
    %fastboot% flash %%i_a %%i.img
)
%fastboot% flash logo_a logo.bin

for %%i in (dpm gz lk mcupm md1img pi_img scp spmfw sspm tee tkv) do (
    %fastboot% flash %%i_b %%i.img
)
%fastboot% flash logo_b logo.bin

echo ###################
echo # FLASHING VBMETA #
echo ###################
choice /m "Disable android verified boot?, If unsure, say N. Bootloader won't be lockable if you select Y. If you're preparing the device for custom ROM installation, say Y"
if %errorlevel% equ 1 (
    set disable_avb=1
    %fastboot% flash vbmeta --slot all --disable-verity --disable-verification vbmeta.img
) else (
    %fastboot% flash vbmeta --slot all vbmeta.img
)

echo #################################
echo # FLASHING VBMETA SYSTEM/VENDOR #
echo #################################
for %%i in (vbmeta_system vbmeta_vendor) do (
    %fastboot% flash %%i_a %%i.img
)

for %%i in (vbmeta_system vbmeta_vendor) do (
    %fastboot% flash %%i_b %%i.img
)

echo #################
echo # FLASHING BOOT #
echo #################
for %%i in (boot vendor_boot dtbo) do (
    %fastboot% flash %%i_a %%i.img
)

for %%i in (boot vendor_boot dtbo) do (
    %fastboot% flash %%i_b %%i.img
)

echo #############
echo # REBOOTING #
echo #############
choice /m "Reboot to system? If unsure, say Y."
if %errorlevel% equ 1 (
    %fastboot% reboot
)

echo ########
echo # DONE #
echo ########
echo System Prepared for Custom ROM

pause
