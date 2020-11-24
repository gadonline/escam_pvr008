#!/bin/sh

#link
ifconfig eth0 192.168.1.11
ifconfig lo 127.0.0.1

export LD_LIBRARY_PATH='/tmp/lib:/usr/local/lib:/usr/lib'

#app
mkdir -p /root/edvr
ln -s /app/root/edvr/* /root/edvr
cp /app/root/edvr/DeviceVersion.ini /root/edvr -rf
cp /app/root/edvr/DeviceCap.xml /root/edvr -rf
mkdir /root/edvr/res/
ln -s /app/usr/bin/* /usr/bin
ln -s /app/usr/lib/* /usr/lib
ln -s /app/usr/sbin/* /usr/sbin
ln -s /app/usr/share/fonts /usr/share/fonts
ln -s /custom/bin/* /usr/sbin/

cp /app/usr/lib/libmysystem.so /usr/lib
cp /app/usr/lib/libAuthority.so /usr/lib

#web
rm -rf /home/http/download
rm -rf /home/http/Protocol.html
rm -rf /home/http/DeviceCapTable.ini
ln -s /dat/mmcblk0p1 /home/http/download
ln -s /config/http/Protocol.html /home/http/Protocol.html

#wifi
cp /app/entropy.bin /tmp/entropy.bin
mkdir -p /var/lib
cp -rf /app/lib/misc /var/lib/.

#cfg
if [ -d /config/etc/conf.d/boa ]
then
	echo "boa exsit"
else
	mkdir -p /config/etc/conf.d/boa
fi

if [ -d /config/usr/local/etc ]
then
    echo "etc exsit"
else
    mkdir -p /config/usr/local/etc
fi

ln -s /config/etc/conf.d /etc/conf.d
mkdir -p /etc/network/
mkdir -p /usr/local

if [ -e /etc/network/interfaces ]
then
	rm /etc/network/interfaces
fi

ln -s /config/etc/network/interfaces /etc/network/interfaces
ln -s /config/etc/ppp /etc/ppp
ln -s /config/etc/wifi /etc/wifi
ln -s /config/etc/resolv.conf /etc/resolv.conf
ln -s /config/etc/resolv_wlan.conf /etc/resolv_wlan.conf
ln -s /config/etc/wifi.conf /etc/wifi.conf
ln -s /config/etc/Wireless /etc/Wireless
ln -s /config/etc/hosts /etc/hosts
ln -s /config/usr/local/etc /usr/local/etc
ln -s /config/usr/share/udhcpc /usr/share/udhcpc

if [ ! -e /config/etc/udhcpd.conf ]
then
    cp -af /custom/config/udhcpd.conf /config/etc/udhcpd.conf
fi

if [ -h /config/etc/udhcpd.conf ]
then
    rm -rf /config/etc/udhcpd.conf
    cp -af /custom/config/udhcpd.conf /config/etc/udhcpd.conf
fi

ln -s /config/etc/udhcpd.conf /etc/udhcpd.conf

cp /app/usr/sbin/operate_router  /usr/sbin
cp -v /app/usr/sbin/systemd /usr/sbin

/usr/sbin/systemd &

cd /ko
./load3518ev300  -i -sensor0 sc4236 -osmem 46
#sensor时钟
himm 0x120100f0 0x19

# Authorize License Code
echo "Start board authorize ..."
/root/edvr/BoardAuthInit

#get board id
echo "Start wifi detect ..."
/usr/sbin/wifi_detect id

if [ -e "/tmp/.SensorName_F23" ]; then
	#24M
	himm 0x120100f0 0xD
elif [ -e "/tmp/.SensorName_SC2232H" ]; then
	#27M
	himm 0x120100f0 0x19
elif [ -e "/tmp/.SensorName_F37" ]; then
	#24M
	himm 0x120100f0 0xD
elif [ -e "/tmp/.SensorName_SC3235" ]; then
	#27M
	himm 0x120100f0 0x19
else
    echo "Warning: not found sensor_name flag file, default: sc4236";
	#24M
	himm 0x120100f0 0xD
fi

cd /
echo "checkPartitionFull start"
#check if config partition full, delete some file when full.
/root/edvr/checkPartitionFull.sh /config 5

#check if config file borken.
/root/edvr/checkConfigFile.sh /config

#do custom
/root/edvr/doCustom.sh
echo "checkPartitionFull end"

#system config
echo 1 > /proc/sys/vm/dirty_ratio
echo 1 > /proc/sys/vm/dirty_background_ratio
echo 100 > /proc/sys/vm/dirty_expire_centisecs
echo 50 > /proc/sys/vm/dirty_writeback_centisecs

#DHCPC续租
echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
#echo 0 > /proc/sys/net/ipv4/conf/all/arp_ignore
#echo 0 > /proc/sys/net/ipv4/conf/all/arp_announce
#echo 0 > /proc/sys/net/ipv4/conf/all/arp_filter
#echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter

ulimit -s 2048

#########################################
himm 0x112C0050 0x0000
himm 0x120B8400 0x40
#8188高电平使能
#8189低电平使能
#reset wifi dev
#if [ -e "/tmp/.SensorName_F23" ]; then
if [ -e "/onvif/wifi/8188fu.ko" -o -e "/onvif/wifi/hi3881.ko" ]; then
	himm 0x120B8100 0x00
	sleep 1
	himm 0x120B8100 0x40
else
	himm 0x120B8100 0x40
	sleep 1
	himm 0x120B8100 0x00
fi

himm 0x112C0048 0x1D54
himm 0x112C004C 0x1174
himm 0x112C0064 0x1174
himm 0x112C0060 0x1174
himm 0x112C005C 0x1174
himm 0x112C0058 0x1174
himm 0x10020028 0x28000000
himm 0x10020028 0x20000000

himm 0x120C0020 0x02
# 0:input，1:output
himm 0x120B2400 0x01
himm 0x120B2004 0x0

himm 0x120C0010 0x1E02
himm 0x120C0014 0x1E02
himm 0x120C0018 0x1E02
himm 0x120C001C 0x1E02

himm 0x112C0068 0x1000
himm 0x112C006C 0x1A00
himm 0x112C0070 0x1000
himm 0x112C0074 0x1000

himm 0x120B6400 0xF0
himm 0x120B1400 0xF0

himm 0x120B63C0 0
himm 0x120B13C0 0
#########################################

##############SD卡驱动能力#################
himm 0x1001002c 0x1
himm 0x120101F4 0x12010000
himm 0x1001002c 0x5

himm 0x100C0040 0x00000641
himm 0x100C0044 0x00000561
himm 0x100C0048 0x00000561
himm 0x100C004C 0x00000561
himm 0x100C0050 0x00000561
himm 0x100C0054 0x00000561
#himm 0x100C005C 0x00000121
#########################################

#SD卡升级
#/usr/sbin/wifi_detect sdUpgrade

# Check Sd Card Status
/root/edvr/checkSDCard 0;
SD_STATUS=`cat /tmp/.sd_status`

#set MAC, wifi
WifiModFile="/tmp/.wifi.mod.ok"

ln -s /onvif/wifi/wpa_*       /usr/sbin/
ln -s /onvif/wifi/iw*         /usr/sbin/
ln -s /onvif/ramdisk/*        /usr/sbin/
ln -s /onvif/wifi/host*       /usr/sbin/

mkdir -p /tmp/picture/pic_for_email
mkdir -p /tmp/picture/pic_for_sd
mkdir -p /tmp/picture/pic_for_ftp

insmod /onvif/phy/sr9900.ko
ifconfig eth0 up

insmod /onvif/wifi/cfg80211.ko
#if [ -e "/tmp/.SensorName_F23" ]; then
if [ -e "/onvif/wifi/8188fu.ko" -o -e "/onvif/wifi/hi3881.ko" ]; then
    sleep 1
    hi3881_status=`cat /proc/mci/mci_info | awk '/MCI1/ {print $2}'`
    if [ "$hi3881_status" = "pluged_connected" ] 
    then
        #根据定制决定是否开启wifi功率增强
        wifiPowerBoostEnable=`cat /usr/local/etc/Edvr.cfg | grep wifiPowerBoostEnable | awk -F "=" '{print $2}' | awk '{sub("^ *","");sub(" *$","");print $1}'`
        if [ "$wifiPowerBoostEnable" = "1" ]
        then
            cp -vr /onvif/wifi/hisilicon/wifi_cfg_max /tmp/wifi_cfg
        else
            cp -vr /onvif/wifi/hisilicon/wifi_cfg_ce /tmp/wifi_cfg
        fi
        
        #设置3881 mac地址
        /usr/sbin/wifi_detect setMac
        
        if [ ! -e "/config/debug3881" ]
        then
            insmod /onvif/wifi/hi3881.ko
            touch $WifiModFile
        fi
    else	
        insmod /onvif/wifi/8188fu.ko
        touch $WifiModFile
    fi
else
    insmod /onvif/wifi/rtl8189f.ko
    touch $WifiModFile
fi
insmod /onvif/moto/moto_drv.ko
ifconfig wlan0 up
ApMode=`cat /usr/local/etc/config.ini | grep bSupportWlanAP | awk -F "=" '{print $2}'`
if [ "1" == "$ApMode" ]; then
    echo "Current device is support ApMode!"
    #/onvif/wifi/softAp &
fi
/usr/sbin/wifi_detect noInsmodWifi

/usr/sbin/boa -c /home/http -f /etc/conf.d/boa/boa.conf

if [ -e /ko/extdrv/rtc_8563.ko ]
then
	insmod /ko/extdrv/hi_rtc.ko 
	insmod /ko/extdrv/rtc_8563.ko 
	RTC8563_EXIST=`lsmod | grep rtc_8563`
	if [ -z "$RTC8563_EXIST" ]
	then
		echo "RTC 8563 not exist!"
		hwclock --systohc 
	else
		echo "RTC 8563 exist!"
# we don't need creat rtc node		
#		rm /dev/rtc0
#		mknod /dev/rtc0 c 254 1
		#hwclock -s
	fi
fi	

hwclock -s

SYS_TIME_CFG="/usr/local/etc/system_time.cfg"
if [ -f ${SYS_TIME_CFG} ]; then
    cat ${SYS_TIME_CFG} | xargs date
    echo "set last time `cat ${SYS_TIME_CFG}` to device!"
else
    echo "${SYS_TIME_CFG} not exist!"
fi

LOCALTIME=`date | awk -F "UTC" '{print$2}'`
if [ $LOCALTIME \< 2016 ]
then
	echo "reset system time"
	date 2016.01.01-00:00
	hwclock -w &
else
	echo "no need change time"
fi
hwclock --systohc &

/root/edvr/record_system_time.sh ${SYS_TIME_CFG} &

echo 3 > /proc/sys/vm/drop_caches

echo 1460 > /sys/class/net/wlan0/mtu
echo 1460 > /sys/class/net/eth0/mtu

DbgFlagFile="/config/.DebugFlag"
WifiFlagFile="/config/.wifiok"
if [ ! -f "$DbgFlagFile" ]; then
	cp -v /app/usr/sbin/MonitorProcess /usr/sbin/
	/usr/sbin/MonitorProcess & > /dev/console
	cd /root/edvr

	ulimit -s 2048
	# not insmod
	if [ ! -f "$WifiModFile" ]; then
		exit 0;
	fi

	# wifi ok
	#if [ -f "$WifiFlagFile" ]; then
		./myWatchDogProcess &
		./ambarella_test & 
	#fi
else
    LOCALIP=`cat /usr/local/etc/Edvr.cfg-bak | grep "LocalIP" | awk -F "=" '{print $2}'`;
    NETMASK=`cat /usr/local/etc/Edvr.cfg-bak | grep "LocalSubnetMask" | awk -F "=" '{print $2}'`;
    #DHCPENABLE=`cat /usr/local/etc/Edvr.cfg-bak | grep -m 1 "DHCP_Enable" | awk	-F "=" '{print $2}'`;
    ifconfig eth0 $LOCALIP netmask $NETMASK;

    echo "Into Manual Mode!" > /dev/console;
    echo "No Passwd";
    cp -v /app/passwd/*  /etc/;
	telnetd;
	exit;
fi
