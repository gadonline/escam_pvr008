#Альтернативная прошивка для IP камеры ESCAM PVR008


Сборка uImage:

```
cp kernel_config kernel/.config
cd kernel
make j=12 ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- uImage
```

Сборка rootfs:

```
rm -r rootfs.squashfs
mksquashfs rootfs rootfs.squashfs -comp xz -ef rootfs/excludelist
```

Подготовка MicroSD карты:

```
DISK=/dev/sdb
sudo parted -s $DISK mklabel msdos
sudo parted -s $DISK mkpart primary 1MiB 1025MiB    #нужды ambarella_test
sudo parted -s $DISK mkpart primary 1025MiB 1033MiB #kernel
sudo parted -s $DISK mkpart primary 1033MiB 1049MiB #rootsf
sudo parted -s $DISK mkpart primary 1049MiB 100%    #entware
sudo mkfs.vfat ${DISK}1
sudo mkfs.vfat ${DISK}2
sudo mkfs.ext2 -F ${DISK}4
sudo e2label ${DISK}4 ENTWARE
```

Установка ядра:

```
KERNEL_PART=/dev/sdb2
TEMP_DIR=$(mktemp -d)
sudo mount -t vfat $KERNEL_PART $TEMP_DIR
sudo cp kernel/arch/arm/boot/uImage $TEMP_DIR
sudo umount $KERNEL_PART
rm -r $TEMP_DIR
```

Установка rootfs:

```
ROOTFS_PART=/dev/sdb3
sudo dd if=rootfs.squashfs of=$ROOTFS_PART
```

Установка entware:

```
ENTWARE_PART=/dev/sdb4
TEMP_DIR=$(mktemp -d)
sudo mount -t ext2 $KERNEL_PART $TEMP_DIR
sudo cp -r entware/* $TEMP_DIR
sudo umount $ENTWARE_PART
rm -r $TEMP_DIR
```

Настройка U-Boot:

```
setenv bootargs console=ttyAMA0,115200 root=/dev/mmcblk0p3 rootwait rootfstype=squashfs init=/linuxrc mtdparts=hi_sfc:256K(uboot),64K(env),2304K(kernel),6656K(romfs),2048K(webserver),384K(custom),768K(config),3904K(onvif)
setenv bootcmd 'setenv bootargs ${bootargs} mem=${osmem};fatload mmc 0:2 0x42000000 uImage;bootm 0x42000000'
setenv ptzsupport
saveenv
boot
```
