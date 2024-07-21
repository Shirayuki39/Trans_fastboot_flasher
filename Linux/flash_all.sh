#!/bin/bash

echo "###########################################################"
echo "#         Transsion mt6789 Fastboot ROM Flasher           #"
echo "#             Originally Developed/Tested By              #"
echo "#  HELLBOY017, viralbanda, spike0en, PHATwalrus, arter97  #"
echo "#        [From Nothing Phone (2) Telegram Dev Team]       #"
echo "#         Adapted for Transsion mt6789 by rama982         #"
echo "#        Modified to flash both slots by Shirayuki39      #"
echo "###########################################################"

fastboot=bin/fastboot

if [ ! -f $fastboot ] || [ ! -x $fastboot ]; then
    echo "Fastboot cannot be executed, exiting"
    exit 1
fi

echo "#############################"
echo "# CHANGING ACTIVE SLOT TO A #"
echo "#############################"
$fastboot --set-active=a

echo "###################"
echo "# FORMATTING DATA #"
echo "###################"
read -p "Wipe Data? (Y/N) " DATA_RESP
case $DATA_RESP in
    [yY] )
        echo 'Please ignore "Did you mean to format this partition?" warnings.'
        $fastboot erase userdata
        $fastboot erase metadata
        ;;
esac

echo  "##################"
echo  "# FLASHING SUPER #"
echo  "##################"
sudo fastboot flash super super.img

echo "##########################"
echo "# REBOOTING TO FASTBOOTD #"
echo "##########################"
$fastboot reboot fastboot

echo "#####################"
echo "# FLASHING FIRMWARE #"
echo "#####################"
for i in dpm gz lk mcupm md1img pi_img preloader_raw scp spmfw sspm tee tkv; do
    $fastboot flash ${i}_a $i.img
done
$fastboot flash logo_a logo.bin

for i in dpm gz lk mcupm md1img pi_img preloader_raw scp spmfw sspm tee tkv; do
    $fastboot flash ${i}_b $i.img
done
$fastboot flash logo_b logo.bin

echo "###################"
echo "# FLASHING VBMETA #"
echo "###################"
read -p "Disable android verified boot?, If unsure, say N. Bootloader won't be lockable if you select Y. If you're preparing the device for custom ROM installation, say Y (Y/N) " VBMETA_RESP
case $VBMETA_RESP in
    [yY] )
        $fastboot flash vbmeta --slot all --disable-verity --disable-verification vbmeta.img
        ;;
    *)
        $fastboot flash vbmeta --slot all vbmeta.img
        ;;
esac

echo "#################################"
echo "# FLASHING VBMETA SYSTEM/VENDOR #"
echo "#################################"
for i in vbmeta_system vbmeta_vendor; do
    $fastboot flash ${i}_a $i.img
done

for i in vbmeta_system vbmeta_vendor; do
    $fastboot flash ${i}_b $i.img
done

echo "#################"
echo "# FLASHING BOOT #"
echo "#################"
for i in boot vendor_boot dtbo; do
    $fastboot flash ${i}_a $i.img
done

for i in boot vendor_boot dtbo; do
    $fastboot flash ${i}_b $i.img
done

echo "#############"
echo "# REBOOTING #"
echo "#############"
read -p "Reboot to system? If unsure, say Y. (Y/N) " REBOOT_RESP
case $REBOOT_RESP in
    [yY] )
        $fastboot reboot
        ;;
esac

echo "########"
echo "# DONE #"
echo "########"
echo "Stock firmware restored."
echo "You may now optionally re-lock the bootloader if you haven't disabled android verified boot."
