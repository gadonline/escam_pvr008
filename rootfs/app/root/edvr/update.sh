#!/bin/sh
echo "Updating"
cd / 

if [ -f /root/edvr/zw_device_update.tar.gz ] ; then
    if [ -f /root/edvr/.update_success ] ; then
		if [ -f /root/edvr/update ] ; then
			./root/edvr/update
		fi
	fi
fi

if [ -f /root/edvr/zw_device_update.tar.gz ] ; then
    if [ -f /root/edvr/.update_success ] ; then
        tar -xzvf root/edvr/zw_device_update.tar.gz
        echo `date` "Updated!"> /root/edvr/Update.log
    	rm -rf /root/edvr/.update_success
	    rm -rf root/edvr/zw_device_update.tar.gz
		#reboot
    else
    	rm -rf /root/edvr/.update_success
	    rm -rf root/edvr/zw_device_update.tar.gz
        echo `date` "Update Failed!"
    fi
fi

cd /root/edvr
