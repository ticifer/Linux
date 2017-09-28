#!/bin/sh
#=============================================#
#	System Required: CentOS                   #
#	Description: Aria2                        #
#	Version: 1.0                              #
#	Author: MoYoo                             #
#	Blog: https://www.moyoo.net               #
#   Github: https://www.github/ticifer/Linux  #
#=============================================#
#安装组件
yum -y install wget screen curl python lrzsz
yum install epel-release
yum clean all
#获取当前gcc版本号
gcc_new=`gcc --version | grep gcc | awk -F" " '{print $3}'`
#定义最低要求gcc版本号
gcc_old="4.8.3"
#sort版本比较
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }
function version_lt() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" != "$1"; }
if version_ge $gcc_new $gcc_old
then
   echo "当前gcc版本$gcc_new >= 最低要求gcc版本$gcc_old"
   echo "3秒后开始安装Aria2"
   sleep 3
#变量
aria2c="/usr/local/bin/aria2c"
#安装依赖
yum install -y bison libssh2-devel gcc-c++ expat-devel gmp-devel nettle-devel libuv-devel libssh2-devel zlib-devel c-ares-devel cppunit-devel gnutls-devel libgcrypt-devel libxml2-devel sqlite-devel gettext lzma-devel xz-devel gperftools gperftools-devel gperftools-libs jemalloc-devel libuv libuv-devel jemalloc libxml2-dev libgcrypt-dev libssl-dev bzip2
#下载Aria2包
wget --no-check-certificate N "https://github.com/aria2/aria2/releases/download/release-1.32.0/aria2-1.32.0.tar.gz"
#解压Aria2
tar xzf aria2-1.32.0.tar.gz
#进入Aria2解压Aria2目录
cd aria2-1.32.0
#编译Aria2
./configure --enable-static=yes --enable-shared=no --with-libuv --with-jemalloc ARIA2_STATIC=yes
make
make install
check_installed_status(){
	[[ ! -e ${aria2c} ]] && echo -e "${Error} Aria2 没有安装，请检查 !" && exit 1
}
#创建Aria2配置目录
	if [ ! -d "/etc/aria2" ]
		then
		mkdir -p /etc/aria2
	else
		echo "目录已存在"
	fi
#创建Aria2配置文件
echo "#aria2 config
dir=/data/wwwroot/down/data
disable-ipv6=true
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
rpc-listen-port=6800
continue=true
input-file=/etc/aria2/aria2.session
#rpc-user=admin
#rpc-passwd=lucifer
enable-rpc=true
#rcp-secrent=lucifer
check-certificate=false
save-session=/etc/aria2/aria2.session
save-session-interval=7200
max-concurrent-downloads=20
log=/etc/aria2/aria2.log

# Complete delete .aria2 files
on-download-complete=/etc/aria2/delete_aria2

max-overall-upload-limit=5K
max-upload-limit=5K
follow-torrent=true
#BT
bt-request-peer-speed-limit=200K

#PT download
bt-max-peers=48
listen-port=26834
enable-dht=false
bt-enable-lpd=false
enable-peer-exchange=false
user-agent=uTorrent/341(109279400)(30888)
peer-id-prefix=-UT341-
seed-ratio=0
force-save=true
bt-hash-check-seed=true
bt-seed-unverified=true
bt-save-metadata=true" > /etc/aria2/aria2.conf
#创建Aria2记录
echo "" > /etc/aria2/aria2c.session
#创建Aria2日志文件
echo "" > /etc/aria2/aria2.log
#创建Aria2脚本
echo "#!/bin/sh
### BEGIN INIT INFO
# Provides:          aria2
# Required-Start:    $remote_fs $network
# Required-Stop:     $remote_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Aria2 Downloader
### END INIT INFO

prog="aria2c"
ARIA2_CONF_FILE="/etc/aria2/aria2.conf"

start() {
    echo -n $"Starting $prog: "
    $prog --conf-path=$ARIA2_CONF_FILE -D
	ps -lef |pgrep $prog &> /dev/null
    if [ $? -eq 0 ]
    then 
        echo "$prog Has Started. Aria2已启动..."
    else
        echo "$prog Not Started. Aria2未启动..."
    fi
}

stop() {
    echo -n $"Stopping $prog: "
	ps aux|grep $prog|grep -Ev 'grep|service|init.d'|awk '{print $2}'|xargs kill -9
	if [ $? -eq 0 ]
    then 
        echo "$prog Is Stopped. Aria2已停止..."
    else
        echo "$prog Not Stopped. Aria2未停止..."
    fi
}

restart() {
    stop
	sleep 1
    start
}
status() {
        ps -lef |pgrep $prog &> /dev/null
        if [ $? -eq 0 ]
        then 
            echo "$prog Is Running. Aria2已运行..."
        else
            echo "$prog Not Running. Aria2未运行..."
        fi
}

case "$1" in
start)
	start
;;
stop)
	stop
;;
restart)
	restart
;;
status)
	status
;;
*)
    echo 'Usage:' `basename $0` '[option]'
    echo 'Available option:'
    for option in start stop restart status
    do
    echo '  -' $option
    done
;;
esac" > /etc/init.d/aria2c
#赋予Aria2脚本执行权限
chmod +x /etc/init.d/aria2c
#设置Aria2开机启动
chkconfig aria2c on
#启动aria2
service aria2c restart
#完成Aria2安装
echo "Aria2安装配置完成.并成功启动运行!"}
else
	if version_lt $gcc_new $gcc_old
		then
		echo "当前gcc版本$gcc_new < gcc最低要求$gcc_old"
		echo "请将gcc升级至最低4.8.3再运行本脚本"
		exit 1
    fi
fi
