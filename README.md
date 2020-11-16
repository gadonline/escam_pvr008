Альтернативная прошивка для IP камеры ESCAM PVR008


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
