# Альтернативная прошивка для IP камеры ESCAM PVR008

## Внимание - проект на стадии раннего доступа, в нем много ошибок и недоработок. При использовании данной прошивки, ваше оборудование может частично потерять свой функционал или полностью превратиться в кирпич.

Сборка uImage:

```
cp kernel_config kernel/.config
cd kernel
make j=12 ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- uImage
cp arch/arm/boot/uImage ../
cd ..
```

Подготовка MicroSD карты:

```
DISK=/dev/sdb
sudo parted -s $DISK mklabel msdos
sudo parted -s $DISK mkpart primary 1MiB 1025MiB    #нужды ambarella_test
sudo parted -s $DISK mkpart primary 1025MiB 1033MiB #kernel
sudo parted -s $DISK mkpart primary 1033MiB 100%    #rootsf
sudo mkfs.vfat ${DISK}1
sudo mkfs.vfat ${DISK}2
sudo mkfs.ext2 -F ${DISK}3
```

Установка ядра:

```
KERNEL_PART=/dev/sdb2
TEMP_DIR=$(mktemp -d)
sudo mount -t vfat $KERNEL_PART $TEMP_DIR
sudo cp uImage $TEMP_DIR
sudo umount $KERNEL_PART
rm -r $TEMP_DIR
```

Установка rootfs:

```
ROOTFS_PART=/dev/sdb3
TEMP_DIR=$(mktemp -d)
sudo mount -t ext2 $ROOTFS_PART $TEMP_DIR
sudo rsync -avP rootfs/ --exclude .gitignore $TEMP_DIR
sudo umount $ROOTFS_PART
rm -r $TEMP_DIR
```

Настройка U-Boot:

```
setenv bootargs console=ttyAMA0,115200 root=/dev/mmcblk0p3 rootwait rootfstype=ext2 init=/linuxrc mtdparts=hi_sfc:256K(uboot),64K(env),2304K(kernel),6656K(romfs),2048K(webserver),384K(custom),768K(config),3904K(onvif)
setenv bootcmd 'setenv bootargs ${bootargs} mem=${osmem};fatload mmc 0:2 0x42000000 uImage;bootm 0x42000000'
setenv ptzsupport
saveenv
boot
```
