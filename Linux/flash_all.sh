#!/bin/bash

echo "###########################################################"
echo "#         Transsion mt6789 Fastboot ROM Flasher           #"
echo "#             Originally Developed/Tested By              #"
echo "#  HELLBOY017, viralbanda, spike0en, PHATwalrus, arter97  #"
echo "#        [From Nothing Phone (2) Telegram Dev Team]       #"
echo "#         Adapted for Transsion mt6789 by rama982         #"
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

read -p "Flash images on both slots? If unsure, say N. (Y/N) " SLOT_RESP
case $SLOT_RESP in
    [yY] )
        SLOT="--slot=all"
        ;;
esac

echo "#################"
echo "# FLASHING BOOT #"
echo "#################"
for i in boot vendor_boot dtbo; do
    if [ $SLOT = "--slot=all" ]; then
        for s in a b; do
            $fastboot flash ${i}_${s} $i.img
        done
    else
        $fastboot flash $i $i.img
    fi
done

echo "#####################"
echo "# FLASHING FIRMWARE #"
echo "#####################"
for i in dpm gz lk logo mcupm md1img pi_img scp spmfw sspm tee; do
    $fastboot flash $SLOT $i $i.img
done

echo "###################"
echo "# FLASHING VBMETA #"
echo "###################"
read -p "Disable android verified boot?, If unsure, say N. Bootloader won't be lockable if you select Y. (Y/N) " VBMETA_RESP
case $VBMETA_RESP in
    [yY] )
        $fastboot flash $SLOT vbmeta --disable-verity --disable-verification vbmeta.img
        ;;
    *)
        $fastboot flash $SLOT vbmeta vbmeta.img
        ;;
esac

echo  "##################"
echo  "# FLASHING SUPER #"
echo  "##################"
sudo fastboot flash super super.img

echo "#################################"
echo "# FLASHING VBMETA SYSTEM/VENDOR #"
echo "#################################"
for i in vbmeta_system vbmeta_vendor; do
    case $VBMETA_RESP in
        [yY] )
            $fastboot flash $i --disable-verity --disable-verification $i.img
            ;;
        *)
            $fastboot flash $i $i.img
            ;;
    esac
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
