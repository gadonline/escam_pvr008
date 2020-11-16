#!/bin/sh

cd /root/edvr/
./Disable_UVC.sh

#	UVC:
rmmod /ko/extdrv/usb_f_uac2.ko
rmmod /ko/extdrv/usb_f_uac1.ko
rmmod /ko/extdrv/u_audio.ko
rmmod /ko/extdrv/usb_f_uvc.ko

#	Ether：
insmod /ko/extdrv/u_ether.ko
insmod /ko/extdrv/usb_f_rndis.ko
insmod /ko/extdrv/usb_f_ecm.ko

export MANUFACTURER="Huawei"
export PRODUCT="HiEthernet"
export SERIALNUMBER="1234567891"
./Config_Ether.sh

#sleep 1
#ifconfig usb0 192.168.60.10
#ifconfig usb1 192.168.0.10



