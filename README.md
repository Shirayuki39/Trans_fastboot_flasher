# Transsion mt6789 Fastboot ROM Flasher

### Getting Started
- This script is designed to make it easier for users to go back to the stock ROM or unbrick their device in case of bootloop but still be able to enter recovery since Transsion does not support direct boot to fastboot. Otherwise, you have to go to a local service or use a paid service to restore the stock ROM.

### Usage
- Make sure you unpack the full firmware zip and then place the script suited to your operating system to the directory where the `*.img` files have been extracted. Finally reboot your device to the bootloader and then 

    execute the script by double clicking the `flash_all.bat` file on windows 

    or by doing this on a linux operating system in terminal after opening the terminal in the directory where the `*.img` files have been extracted :

```bash
chmod +x flash_all.sh && bash flash_all.sh
```

### Notes
- NEED TO FLASH A CUSTOM RECOVERY BEFORE USING THIS SCRIPT.
- The script flashes the rom on slot A and it destroys the partitions on slot B to create space for the partitions which are being flashed on slot A. This is the reason why we are not including the ability to switch slots as the partitions would get destroyed on the inactive slot which is why the script flashes the partitions on the primary slot which is slot A.

