@echo off
setx PATH "%PATH%;%cd"

title Transsion mt6789 Fastboot ROM Flasher

echo ###########################################################
echo #          Transsion mt6789 Fastboot ROM Flasher          #
echo #             Originally Developed/Tested By              #
echo #  HELLBOY017, viralbanda, spike0en, PHATwalrus, arter97  #
echo #        [From Nothing Phone (2) Telegram Dev Team]       #
echo #          Adapted for Transsion mt6789 by rama982        #
echo ###########################################################

echo #############################
echo # CHANGING ACTIVE SLOT TO A #
echo #############################
fastboot --set-active=a

echo ###################
echo # FORMATTING DATA #
echo ###################
choice /m "Wipe Data?"
if %errorlevel% equ 1 (
    echo Please ignore "Did you mean to format this partition?" warnings.
    fastboot erase userdata
    fastboot erase metadata
)

echo #################
echo # FLASHING BOOT #
echo #################
for %%i in (boot vendor_boot dtbo) do (
    for %%s in (a b) do (
        fastboot flash %%i_%%s %%i.img
    )
)

echo #####################
echo # FLASHING FIRMWARE #
echo #####################
for %%i in (dpm gz lk mcupm md1img pi_img scp spmfw sspm tee) do (
    for %%s in (a b) do (
        fastboot flash %%i_%%s %%i.img
    )
)
fastboot flash preloader_a preloader_raw.img
fastboot flash preloader_b preloader_raw.img
fastboot flash logo_a logo.bin
fastboot flash logo_b logo.bin

echo ###################
echo # FLASHING VBMETA #
echo ###################
choice /m "Disable android verified boot?, If unsure, say N. Bootloader won't be lockable if you select Y."
if %errorlevel% equ 1 (
    set disable_avb=1
    fastboot flash vbmeta --disable-verity --disable-verification vbmeta.img
) else (
    fastboot flash vbmeta vbmeta.img
)

echo ##################
echo # FLASHING SUPER #
echo ##################
fastboot flash super super.img

echo #################################
echo # FLASHING VBMETA SYSTEM/VENDOR #
echo #################################
for %%i in (vbmeta_system vbmeta_vendor) do (
    fastboot flash %%i_a %%i.img
)

echo #############
echo # REBOOTING #
echo #############
choice /m "Reboot to system? If unsure, say Y."
if %errorlevel% equ 1 (
    fastboot reboot
)

echo ########
echo # DONE #
echo ########
echo Stock firmware restored.
echo You may now optionally re-lock the bootloader if you haven't disabled android verified boot.

pause
