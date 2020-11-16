#���ܣ�
#1.�������Ƿ�����ϣ����δ�������������¼�����ָ������ļ�
#2.�������Ƿ���

if [ $# -ne 2 ]
then
	echo "Usage: $0 <config partition mount poin> <config partition mtd num>"
	exit;
fi

MIN_CFG_PARTITION=/root/edvr/cfg.img

#����������
CFG_MOUNT_RET=`mount | grep $1`
if [ -z "$CFG_MOUNT_RET" ]
then
	echo "$1 partition not mount!"
	echo "start erase /dev/mtd$2"
	flash_eraseall /dev/mtd$2
	
	if [ -e $MIN_CFG_PARTITION ]
	then
		echo "start write $MIN_CFG_PARTITION to /dev/mtd$2"
		dd if=$MIN_CFG_PARTITION of=/dev/mtd$2
	else
		echo "$MIN_CFG_PARTITION not exsit"
	fi
	
	echo "start mount"
	mount -t jffs2     /dev/mtdblock$2 $1 -o sync
	sleep 1
	if [ -z "$CFG_MOUNT_RET" ]
	then
		echo "mount fail again! exit"
	else
		echo "mount success!"
		#��ʼ�ָ�Ŀ¼���ļ�
		#checkConfigFile.sh $1
	fi
fi


TESTFILE="$1/.testFile"

#��ʼ�������Ƿ���
echo "start check partition full!"

integer=1
while [ $integer -le 3 ]
do  
    /bin/touch "$TESTFILE";

	if [ -e "$TESTFILE" ]
	then
        echo "partition $1 not full!";
        rm "$TESTFILE";
		break;
	else
		if [ $integer = 1 ]
		then
			echo "partition $1 is full";
			echo "Delete log.db"
			rm -rf /usr/local/etc/log.db*;
		elif [ $integer = 2 ]
		then
			echo "partition $1 is full";
			echo "Delete boa.conf-bak"
			rm -rf /config/etc/conf.d/boa/boa.conf-bak;
		elif [ $integer = 3 ]
		then
			echo "partition $1 is full";
			echo "Delete pppoe.conf-bak"
			rm -rf /config/etc/ppp/pppoe.conf-bak;
		fi
	fi
	integer=$(($integer+1))
done
