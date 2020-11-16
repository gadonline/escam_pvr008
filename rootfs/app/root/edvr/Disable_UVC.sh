cd /sys/kernel/config/usb_gadget/camera
echo > UDC
rm configs/c.1/uvc.usb0
rm configs/c.1/uac1.usb0
rmdir configs/c.1/strings/0x409
rmdir configs/c.1
rmdir functions/uac1.usb0

cd functions/uvc.usb0
rm streaming/class/fs/h/
rm streaming/class/hs/h/
rm streaming/class/ss/h/
rm streaming/header/h/u/
rm streaming/header/h/m/
rm streaming/header/h/fb/
rmdir streaming/header/h/

rmdir streaming/framebased/fb/360p/ 
rmdir streaming/framebased/fb/720p/
rmdir streaming/framebased/fb/1080p/	
rmdir streaming/framebased/fb/

rmdir streaming/mjpeg/m/360p/ 
rmdir streaming/mjpeg/m/720p/
rmdir streaming/mjpeg/m/1080p/
rmdir streaming/mjpeg/m/

rmdir streaming/uncompressed/u/360p/
rmdir streaming/uncompressed/u/

rm control/class/fs/h/
rm control/class/ss/h/
rmdir control/header/h/
cd ../../
rmdir functions/uvc.usb0

rmdir strings/0x409
cd ../
rmdir camera
cd /root/
umount /sys/kernel/config/
