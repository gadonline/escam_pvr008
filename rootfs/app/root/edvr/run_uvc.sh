#!/bin/sh

product=$(cat /tmp/UvcProductInfo)
serialnumber=$(cat /tmp/UvcSerialNumberInfo)

cd /root/edvr/
./Disable_Ether.sh

rmmod /ko/extdrv/usb_f_ecm.ko
rmmod /ko/extdrv/usb_f_rndis.ko
rmmod /ko/extdrv/u_ether.ko

insmod /ko/extdrv/usb_f_uvc.ko
insmod /ko/extdrv/u_audio.ko
insmod /ko/extdrv/usb_f_uac1.ko
insmod /ko/extdrv/usb_f_uac2.ko

export VID="0xfefe"
export PID="0x209d"
export MANUFACTURER="Ruision"
export PRODUCT=$product
export SERIALNUMBER=$serialnumber
export CamControl1=0xff
export CamControl2=0xff
export CamControl3=0xff
export ProcControl1=0x14
export ProcControl2=0xDF  
export MJPEG="1080p 720p 480p 360p"
export YUV="480p 360p"
export H264="1080p 720p 480p 360p"  
./ConfigUVC.sh

#bind dwc interrupt to cpu1
#echo 2 > /proc/irq/29/smp_affinity

#cd /root/edvr
#./uvc_app &
