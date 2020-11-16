
#password custom
if [ -e /config/usr/local/etc/user.db ]
then
	echo "user.db exsit"
else
	cp /custom/usrpswd/* /config/usr/local/etc/
fi

#Edvr.default custom
#if [ -e /custom/config/Edvr.default ]
#then
#	CST_EDVR_DEF=$(md5sum /custom/config/Edvr.default | awk -F " "  '{printf $1}')
#	CFG_EDVR_DEF=$(md5sum /root/edvr/Edvr.default | awk -F " "  '{printf $1}')
#
#	if [ "$CST_EDVR_DEF" != "$CFG_EDVR_DEF" ]
#	then 
#		if [ -e /usr/local/etc/Edvr.default ]
#		then
#			rm -rf /usr/local/etc/Edvr.default;
#		fi
#		ln -s /custom/config/Edvr.default /usr/local/etc/Edvr.default;
#		echo "Use custom-made default!!"
#		echo "$CST_EDVR_DEF"
#		echo "$CFG_EDVR_DEF"	
#	fi
#fi