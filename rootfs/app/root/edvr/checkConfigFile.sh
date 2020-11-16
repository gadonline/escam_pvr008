#该脚本必须放到APP，CFG分区做完链接后调用
#功能：
#1.检测目录是否存在
#2.检测关键文件是否存在

if [ $# -ne 1 ]
then
	echo "Usage: $0 <config partition mount poin>"
	exit;
fi


#检测关键目录是否存在
if [ ! -d $1/usr/local/etc ]
then
	echo "$1/usr/local/etc not exsit!"
	mkdir -p $1/usr/local/etc
	ln -s /config/usr/local/etc /usr/local/etc
fi	

if [ ! -d $1/etc/conf.d/boa ]
then
	echo "$1/etc/conf.d/boa not exsit!"
	mkdir -p $1/etc/conf.d/boa
	ln -s $1/etc/conf.d /etc/conf.d
fi	

if [ ! -d $1/etc/network/ ]
then
	echo "$1/etc/network/ not exsit!"
	mkdir -p $1/etc/network/
fi	

if [ ! -d $1/etc/wifi ]
then
	echo "$1/etc/wifi not exsit!"
	mkdir -p $1/etc/wifi
fi	

if [ ! -d $1/http ]
then
	echo "$1/http not exsit!"
	mkdir -p $1/http
fi	

if [ ! -d $1/usr/share/udhcpc/ ]
then
	echo "$1/usr/share/udhcpc/ not exsit!"
	mkdir -p $1/usr/share/udhcpc/
fi	

if [ ! -e $1/usr/local/etc/config.ini ] && [ -e /root/edvr/config.ini ]
then
	echo "recover $1/usr/local/etc/config.ini"
	cp /root/edvr/config.ini $1/usr/local/etc/
fi

if [ ! -e $1/usr/local/etc/Edvr.flag ] && [ -e /root/edvr/Edvr.flag ]
then
	echo "recover $1/usr/local/etc/Edvr.flag"
	cp /root/edvr/Edvr.flag $1/usr/local/etc/
fi

if [ ! -e $1/etc/conf.d/boa/boa.conf ] && [ -e /root/edvr/boa.conf ]
then
	echo "recover $1/etc/conf.d/boa/boa.conf"
	cp /root/edvr/boa.conf $1/etc/conf.d/boa/
fi

if [ ! -e $1/etc/conf.d/boa/mime.types ] && [ -e /root/edvr/mime.types ]
then
	echo "recover $1/etc/conf.d/boa/mime.types"
	cp /root/edvr/mime.types $1/etc/conf.d/boa/
fi

if [ ! -e $1/etc/conf.d/boa/userlist.conf ] && [ -e /root/edvr/userlist.conf ]
then
	echo "recover $1/etc/conf.d/boa/userlist.conf"
	cp /root/edvr/userlist.conf $1/etc/conf.d/boa/
fi

if [ ! -e $1/etc/network/interfaces ]
then
	echo "recover $1/etc/network/interfaces"
	echo "auto lo" >> $1/etc/network/interfaces
	echo "iface lo inet loopback" >> $1/etc/network/interfaces
	echo "" >> $1/etc/network/interfaces
	echo "auto eth0" >> $1/etc/network/interfaces
	echo "iface eth0 inet static" >> $1/etc/network/interfaces
	echo "address 192.168.1.11" >> $1/etc/network/interfaces
	echo "netmask 255.255.255.0" >> $1/etc/network/interfaces
	echo "gateway 192.168.1.1" >> $1/etc/network/interfaces
	echo "" >> $1/etc/network/interfaces
	echo "auto wlan0" >> $1/etc/network/interfaces
	echo "iface wlan0 inet static" >> $1/etc/network/interfaces
	echo "address 192.168.2.11" >> $1/etc/network/interfaces
	echo "netmask 255.255.255.0" >> $1/etc/network/interfaces
	echo "gateway 192.168.2.1" >> $1/etc/network/interfaces
	ln -s $1/etc/network/interfaces /etc/network/interfaces
fi

if [ ! -e $1/etc/resolv.conf ]
then
	echo "recover $1/etc/resolv.conf"
	if [ -e /root/edvr/resolv.conf ]
	then
		cp /root/edvr/resolv.conf $1/etc/resolv.conf
	else
		echo "nameserver  114.114.114.114" >> $1/etc/resolv.conf
		echo "nameserver  8.8.8.8" >> $1/etc/resolv.conf
	fi
	ln -s $1/etc/resolv.conf /etc/resolv.conf
fi

if [ ! -e $1/etc/resolv_wlan.conf ]
then
	echo "recover $1/etc/resolv_wlan.conf"
	if [ -e /root/edvr/resolv_wlan.conf ]
	then
		cp /root/edvr/resolv_wlan.conf $1/etc/resolv_wlan.conf
	else
		echo "nameserver  nameserver 192.168.2.1" >> $1/etc/resolv_wlan.conf
		echo "nameserver 1.0.0.0" >> $1/etc/resolv.conf
	fi
	ln -s $1/etc/resolv_wlan.conf /etc/resolv_wlan.conf
fi

if [ ! -e $1/etc/wifi.conf ]
then
	echo "recover $1/etc/wifi.conf"
	echo "" >> $1/etc/wifi.conf
	echo "ctrl_interface=/var/run/wpa_supplicant" >> $1/etc/wifi.conf
	echo "" >> $1/etc/wifi.conf
	ln -s $1/etc/wifi.conf /etc/wifi.conf
fi

if [ ! -e $1/http/Config.html ]
then
	echo "recover $1/http/Config.html"
	echo "[Network]" >> $1/http/Config.html
	echo "CommandPort=6060" >> $1/http/Config.html
	echo "MobilePort=10000" >> $1/http/Config.html
	ln -s $1/http/Config.html /home/http/Config.html
fi

if [ ! -e $1/usr/share/udhcpc/default.script ] && [ -e /root/edvr/default.script ]
then
	echo "recover $1/usr/share/udhcpc/default.script"
	cp /root/edvr/default.script $1/usr/share/udhcpc/default.script
	ln -s $1/usr/share/udhcpc/default.script /usr/share/udhcpc/default.script
fi

if [ -e /root/edvr/rtmp_cfg.ini ] && [ ! -e /usr/local/etc/rtmp_cfg.ini ]
then
	echo "recover /usr/local/etc/rtmp_cfg.ini"
	cp /root/edvr/rtmp_cfg.ini /usr/local/etc/
fi

if [ -e /root/edvr/host.conf ] && [ ! -e /usr/local/etc/host.conf ]
then
    echo "recover /usr/local/etc/host.conf"
    cp /root/edvr/host.conf /usr/local/etc/
fi

USR_CFG_DEF=$(md5sum /usr/local/etc/config.ini | awk -F " "  '{printf $1}')
APP_CFG_DEF=$(md5sum /root/edvr/config.ini | awk -F " "  '{printf $1}')

if [ "$USR_CFG_DEF" != "$APP_CFG_DEF" ]
then
	cp /root/edvr/config.ini /usr/local/etc/ -rf
	echo "Use app config.ini!"
	echo "$USR_CFG_DEF"
	echo "$APP_CFG_DEF"	
fi
	
chmod 777 $1 -R
