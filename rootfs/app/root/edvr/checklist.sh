#! /bin/sh

# 该脚本主要用于版本发布核对md5值, 由于有些命令在linux和arm里面显示不同，
# 故该脚本一般只能用在ipc, 若要用在linux下面, 则需要修改对应的命令脚本

if [ $# -eq 1 ]; then
    if [ ! -d "$1" ]; then
        if [ "$1" != "all" ]; then
            echo "Usage: $0 <dir | all>"
            exit;
        fi
    fi
else
    echo "Usage: $0 <dir | all>"
    exit;
fi

# 需要忽略以下目录
DEV_DIR="/dev"
PROC_DIR="/proc"
SYS_DIR="/sys"
TMP_DIR="/tmp"
VAR_DIR="/var"
MNT_DIR="/mnt"
DAT_DIR="/dat"
DOWN_DIR="/home/http/download"

calc_dir_md5()
{
    # ls -A表示显示除了"."和".."之外的所有文件
    for file in `ls -A $1`
    do
        if [ -d "$1/$file" ]
        then
            files=`ls $1/$file`
            if [ "$1/$file"x = "$DEV_DIR"x -o "$1/$file"x = "$PROC_DIR"x -o \
                 "$1/$file"x = "$TMP_DIR"x -o "$1/$file"x = "$VAR_DIR"x  -o \
                 "$1/$file"x = "$MNT_DIR"x -o "$1/$file"x = "$DAT_DIR"x  -o \
                 "$1/$file"x = "$SYS_DIR"x -o "$1/$file"x = "$DOWN_DIR"x ]
            then
                echo "Skip $1/$file"
            elif [ -z "$files" ]
            then
                echo -e "\n******notice: dir $1/$file is empty******\n"
            else
                calc_dir_md5 $1/$file
            fi
        else
            md5sum $1/$file | awk '{printf "%s\t",$1}'  # 显示文件的md5值, awk表示去掉后面的\n以便打印
            ls -lh $1/$file | awk 'BEGIN{FS=""}{printf("%c\t",$1)}' # 显示文件的属性, awk表示显示文件信息的第一个字符, 即属性
            ls -lh $1/$file | awk 'BEGIN{FS=" "}{printf("%s\t%s\n",$5,$9)}' # 显示文件的大小和名字
            # 如果需要知道文件其他信息，可以直接在awk后面进行添加 ...
        fi
    done
}

if [ "$1" = "all" ];then
    echo "--------------------------start check all dir files md5sum------------------------";
    cd /;
    DIR=;
    calc_dir_md5 $DIR;
    echo "--------------------------check all dir files md5sum over--------------------------";
else
    echo "--------------------------start check $1 dir files md5sum--------------------------";
    calc_dir_md5 $1;
    echo "--------------------------check $DIR dir files md5sum over--------------------------";
fi

echo "---------------------Pay attention that you need to delete .svn dir if exist----------------------";
echo "-----if .svn dir is exist, please use: \"find . -type d -name \".svn\" | xargs rm -fr\" to delete-----";
echo "---------------------------------------------------------------------------------------------------";
