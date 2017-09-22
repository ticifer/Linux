#sort版本比较
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }
function version_lt() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" != "$1"; }
#获取当前gcc版本号
gcc_new=`gcc --version | grep gcc | awk -F" " '{print $3}'`
echo -n "The current gcc version number is $gcc_new"
#gcc升级确认
while :;do echo
read -p "Please confirm whether to upgrade [y/n]: " confirm
if [[ ! $confirm =~  ^[y,n]$ ]]
  then
    echo "${CWARNING}input error! Please only input 'y' or 'n'${CEND}"
  else
    if [ "$confirm" == 'y' ]
      then
      #获取升级版本号
      read -p "Please enter the version you want to upgrade (Exmaple:4.9.0): " gcc
      if version_lt $gcc_new $gcc
        then
        echo "Current gcc version $gcc_new < Need to be upgraded gcc version $gcc"
        echo "3 seconds after the start download gcc source package"
        sleep 3
        #下载源码包
        [ ! -e "gcc-${gcc}.tar.bz2" ] && wget --no-check-certificate -c https://ftp.gnu.org/gnu/gcc/gcc-${gcc}/gcc-${gcc}.tar.bz2
        if  [ -e "gcc-${gcc}.tar.bz2" ]
          then
          echo "Download [${CMSG}gcc-${gcc}.tar.bz2${CEND}] Successfully! "
        else
          echo "${CWARNING}gcc version does not exist! ${CEND} "
        fi
        #判断/解压源码包
        if [ -d "./gcc-${gcc}" ]
          then 
          pushd ./gcc-${gcc}
        else [ ! -d "./gcc-${gcc}" ]
          tar -jxvf gcc-${gcc}.tar.bz2
        fi
          ./contrib/download_prerequisites
        if [ ! -d "./gcc-build-${gcc}" ]
          then
          mkdir gcc-build-${gcc}
        else [ -d "./gcc-${gcc}" ]
          pushd gcc-build-${gcc}
          ../configure -enable-checking=release -enable-languages=c,c++ -disable-multilib
          make
          make install
          reboot
        fi
      else
        if version_ge $gcc_new $gcc
          then
          echo "Current gcc version $gcc_new >= Need to be upgraded gcc version $gcc "
          echo "gcc no need to upgrade"
        fi
      fi
    fi
    break
  fi
done