#!/bin/sh

mount -t configfs none /sys/kernel/config/
cd /sys/kernel/config/usb_gadget/
mkdir camera
cd camera

echo "0x01" > bDeviceProtocol
echo "0x02" > bDeviceSubClass
echo "0xEF" > bDeviceClass
echo $VID > idVendor
echo $PID > idProduct
mkdir strings/0x409
echo $MANUFACTURER > strings/0x409/manufacturer
echo $PRODUCT > strings/0x409/product
echo $SERIALNUMBER > strings/0x409/serialnumber

mkdir functions/uvc.usb0
cd functions/uvc.usb0
mkdir control/header/h/
echo "0x0110" > control/header/h/bcdUVC
echo "48000000" > control/header/h/dwClockFrequency
ln -s control/header/h/ control/class/fs/
ln -s control/header/h/ control/class/ss/

cat <<EOF> control/terminal/camera/default/bmControls
$CamControl2
$CamControl1
$CamControl3
EOF

cat <<EOF> control/processing/default/bmControls
$ProcControl2
$ProcControl1
EOF

#MJPEG
mkdir streaming/mjpeg/m/
for i in $MJPEG
do
    if [ $i = 360p ];then
        mkdir streaming/mjpeg/m/360p/                                            
	echo "333333" > streaming/mjpeg/m/360p/dwFrameInterval                  
	echo "333333" > streaming/mjpeg/m/360p/dwDefaultFrameInterval
	echo "10240000" > streaming/mjpeg/m/360p/dwMaxBitRate                   
	echo "460800" > streaming/mjpeg/m/360p/dwMaxVideoFrameBufferSize        
	echo "10240000" > streaming/mjpeg/m/360p/dwMinBitRate                   
	echo "360" > streaming/mjpeg/m/360p/wHeight                       
	echo "640" > streaming/mjpeg/m/360p/wWidth 
    elif [ $i = 480p ];then
        mkdir streaming/mjpeg/m/480p/                                       
	echo "333333" > streaming/mjpeg/m/480p/dwFrameInterval                   
	echo "333333" > streaming/mjpeg/m/480p/dwDefaultFrameInterval
	echo "10240000" > streaming/mjpeg/m/480p/dwMaxBitRate                    
	echo "614400" > streaming/mjpeg/m/480p/dwMaxVideoFrameBufferSize        
	echo "10240000" > streaming/mjpeg/m/480p/dwMinBitRate                    
	echo "480" > streaming/mjpeg/m/480p/wHeight                              
	echo "640" > streaming/mjpeg/m/480p/wWidth 
    elif [ $i = 720p ];then
        mkdir streaming/mjpeg/m/720p/                                       
	echo "333333" > streaming/mjpeg/m/720p/dwFrameInterval                   
	echo "333333" > streaming/mjpeg/m/720p/dwDefaultFrameInterval
	echo "20480000" > streaming/mjpeg/m/720p/dwMaxBitRate                    
	echo "1843200" > streaming/mjpeg/m/720p/dwMaxVideoFrameBufferSize        
	echo "20480000" > streaming/mjpeg/m/720p/dwMinBitRate                    
	echo "720" > streaming/mjpeg/m/720p/wHeight                              
	echo "1280" > streaming/mjpeg/m/720p/wWidth 
    elif [ $i = 1080p ];then
        mkdir streaming/mjpeg/m/1080p/                                    
	echo "333333" > streaming/mjpeg/m/1080p/dwFrameInterval             
	echo "333333" > streaming/mjpeg/m/1080p/dwDefaultFrameInterval
	echo "40960000" > streaming/mjpeg/m/1080p/dwMaxBitRate            
	echo "4147200" > streaming/mjpeg/m/1080p/dwMaxVideoFrameBufferSize       
	echo "40960000" > streaming/mjpeg/m/1080p/dwMinBitRate                   
	echo "1080" > streaming/mjpeg/m/1080p/wHeight                            
	echo "1920" > streaming/mjpeg/m/1080p/wWidth 
    elif [ $i = 2160p ];then
        mkdir streaming/mjpeg/m/2160p/                                     
	echo "333333" > streaming/mjpeg/m/2160p/dwFrameInterval            
	echo "333333" > streaming/mjpeg/m/2160p/dwDefaultFrameInterval
	echo "61440000" > streaming/mjpeg/m/2160p/dwMaxBitRate             
	echo "16588800" > streaming/mjpeg/m/2160p/dwMaxVideoFrameBufferSize
	echo "61440000" > streaming/mjpeg/m/2160p/dwMinBitRate          
	echo "2160" > streaming/mjpeg/m/2160p/wHeight                   
	echo "3840" > streaming/mjpeg/m/2160p/wWidth
    else
        echo "MJPEG $i is invalid!"
    fi
done

#YUV
mkdir streaming/uncompressed/u/
for i in $YUV
do
    if [ $i = 360p ];then
        mkdir streaming/uncompressed/u/360p/                                     
	echo "333333" > streaming/uncompressed/u/360p/dwFrameInterval           
	echo "333333" > streaming/uncompressed/u/360p/dwDefaultFrameInterval           
	echo "55296000" > streaming/uncompressed/u/360p/dwMaxBitRate            
	echo "460800" > streaming/uncompressed/u/360p/dwMaxVideoFrameBufferSize  
	echo "55296000" > streaming/uncompressed/u/360p/dwMinBitRate     
	echo "360" > streaming/uncompressed/u/360p/wHeight                       
	echo "640" > streaming/uncompressed/u/360p/wWidth
	elif [ $i = 480p ];then
        mkdir streaming/uncompressed/u/480p/                                     
	echo "333333" > streaming/uncompressed/u/480p/dwFrameInterval           
	echo "333333" > streaming/uncompressed/u/480p/dwDefaultFrameInterval           
	echo "55296000" > streaming/uncompressed/u/480p/dwMaxBitRate            
	echo "614400" > streaming/uncompressed/u/480p/dwMaxVideoFrameBufferSize  
	echo "55296000" > streaming/uncompressed/u/480p/dwMinBitRate     
	echo "480" > streaming/uncompressed/u/480p/wHeight                       
	echo "640" > streaming/uncompressed/u/480p/wWidth
    elif [ $i = 720p ];then
        mkdir streaming/uncompressed/u/720p/                                     
	echo "1000000" > streaming/uncompressed/u/720p/dwFrameInterval           
	echo "1000000" > streaming/uncompressed/u/720p/dwDefaultFrameInterval   
	echo "29491200" > streaming/uncompressed/u/720p/dwMaxBitRate             
	echo "1843200" > streaming/uncompressed/u/720p/dwMaxVideoFrameBufferSize
	echo "29491200" > streaming/uncompressed/u/720p/dwMinBitRate             
	echo "720" > streaming/uncompressed/u/720p/wHeight               
	echo "1280" > streaming/uncompressed/u/720p/wWidth
    elif [ $i = 1080p ];then
        mkdir streaming/uncompressed/u/1080p/                                    
	echo "1000000" > streaming/uncompressed/u/1080p/dwFrameInterval           
	echo "1000000" > streaming/uncompressed/u/1080p/dwDefaultFrameInterval
	echo "29491200" > streaming/uncompressed/u/1080p/dwMaxBitRate            
	echo "4147200" > streaming/uncompressed/u/1080p/dwMaxVideoFrameBufferSize
	echo "29491200" > streaming/uncompressed/u/1080p/dwMinBitRate          
	echo "1080" > streaming/uncompressed/u/1080p/wHeight              
	echo "1920" > streaming/uncompressed/u/1080p/wWidth
    else
        echo "YUV $i is invalid!"
    fi
done

#FRAMEBASED
mkdir streaming/framebased/fb/
for i in $H264
do
    if [ $i = 360p ];then
        mkdir streaming/framebased/fb/360p/                                      
	echo "333333" > streaming/framebased/fb/360p/dwFrameInterval     
	echo "333333" > streaming/framebased/fb/360p/dwDefaultFrameInterval
	echo "8192000" > streaming/framebased/fb/360p/dwMaxBitRate               
	echo "8192000" > streaming/framebased/fb/360p/dwMinBitRate               
	echo "360" > streaming/framebased/fb/360p/wHeight                        
	echo "640" > streaming/framebased/fb/360p/wWidth
    elif [ $i = 480p ];then
        mkdir streaming/framebased/fb/480p/                                      
	echo "333333" > streaming/framebased/fb/480p/dwFrameInterval             
	echo "333333" > streaming/framebased/fb/480p/dwDefaultFrameInterval
	echo "8192000" > streaming/framebased/fb/480p/dwMaxBitRate            
	echo "8192000" > streaming/framebased/fb/480p/dwMinBitRate       
	echo "480" > streaming/framebased/fb/480p/wHeight                 
	echo "640" > streaming/framebased/fb/480p/wWidth  
    elif [ $i = 720p ];then
        mkdir streaming/framebased/fb/720p/                                      
	echo "333333" > streaming/framebased/fb/720p/dwFrameInterval             
	echo "333333" > streaming/framebased/fb/720p/dwDefaultFrameInterval
	echo "10240000" > streaming/framebased/fb/720p/dwMaxBitRate            
	echo "10240000" > streaming/framebased/fb/720p/dwMinBitRate       
	echo "720" > streaming/framebased/fb/720p/wHeight                 
	echo "1280" > streaming/framebased/fb/720p/wWidth  
    elif [ $i = 1080p ];then
        mkdir streaming/framebased/fb/1080p/                                
	echo "333333" > streaming/framebased/fb/1080p/dwFrameInterval            
	echo "333333" > streaming/framebased/fb/1080p/dwDefaultFrameInterval
	echo "15360000" > streaming/framebased/fb/1080p/dwMaxBitRate            
	echo "15360000" > streaming/framebased/fb/1080p/dwMinBitRate            
	echo "1080" > streaming/framebased/fb/1080p/wHeight                     
	echo "1920" > streaming/framebased/fb/1080p/wWidth
    elif [ $i = 2160p ];then
        mkdir streaming/framebased/fb/2160p/                               
	echo "333333" > streaming/framebased/fb/2160p/dwFrameInterval      
	echo "333333" > streaming/framebased/fb/2160p/dwDefaultFrameInterval
	echo "30720000" > streaming/framebased/fb/2160p/dwMaxBitRate       
	echo "30720000" > streaming/framebased/fb/2160p/dwMinBitRate            
	echo "2160" > streaming/framebased/fb/2160p/wHeight                     
	echo "3840" > streaming/framebased/fb/2160p/wWidth
    else
        echo "H264 $i is invalid!"
    fi
done
mkdir streaming/header/h/                                                
ln -s streaming/mjpeg/m/ streaming/header/h/                        
ln -s streaming/uncompressed/u/ streaming/header/h/                 
ln -s streaming/framebased/fb/ streaming/header/h/                  
                                                                    
ln -s streaming/header/h/ streaming/class/fs/                     
ln -s streaming/header/h/ streaming/class/hs/                            
ln -s streaming/header/h/ streaming/class/ss/                            
                                                                         
#-Create and setup configuration
cd ../../                                                                

mkdir functions/uac1.usb0                                                       
echo "0x00" > functions/uac1.usb0/c_chmask

mkdir configs/c.1/                                                       
echo "0x01" > configs/c.1/MaxPower                                        
echo "0xc0" > configs/c.1/bmAttributes                                        
mkdir configs/c.1/strings/0x409/                                    
echo "Config 1" > configs/c.1/strings/0x409/configuration           

ln -s functions/uvc.usb0/ configs/c.1/                              
ln -s functions/uac1.usb0/ configs/c.1/

ls /sys/class/udc > UDC  

