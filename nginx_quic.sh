#!/bin/bash
# Def Resource Path,Modify According To The Situation
data=/data/oneinstack/src
#Def Nginx Path,Modify According To The Situation
ngx_path=/usr/local/nginx
# Close Selinux
setenforce 0
sed -i 's/^SELINUX=.*$/SELINUX=disabled/' /etc/selinux/config
# Installation dependencies
yum install libunwind-devel mercurial psmisc net-tools wget curl build-essential lsb-release git libpcre3-dev zlib1g-dev gcc gcc+ -y
# Downloads Sources
cd $data
if [ -f "$data/nginx-1.19.4.tar.gz" ];then
  echo "Resource Pack Existed"
  else
  wget http://nginx.org/download/nginx-1.19.4.tar.gz
fi
if [ -f "$data/jemalloc-5.2.1.tar.bz2" ];then
  echo "Resource Pack Existed"
  else
  wget -c https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2
fi
if [ -f "$data/go1.13.linux-amd64.tar.gz" ];then
  echo "Resource Pack Existed"
  else
  wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
fi
if [ -f "$data/cmake-3.15.4.tar.gz" ];then
  echo "Resource Pack Existed"
  else
  wget https://github.com/Kitware/CMake/releases/download/v3.15.4/cmake-3.15.4.tar.gz
fi
if [ -f "$data/ngx_cache_purge-2.3.tar.gz" ];then
  echo "Resource Pack Existed"
  else
  wget http://labs.frickle.com/files/ngx_cache_purge-2.3.tar.gz
fi
if [ -f "$data/ngx_slowfs_cache-1.9.tar.gz" ];then
  echo "Resource Pack Existed"
  else
  wget http://labs.frickle.com/files/ngx_slowfs_cache-1.9.tar.gz
fi
if [ -f "$data/pcre-8.44.tar.gz" ];then
  echo "Resource Pack Existed"
  else
  wget http://mirrors.linuxeye.com/oneinstack/src/pcre-8.44.tar.gz
fi
echo "All Resource Pack Existed,Pull Resource Library."
if [ -f "$data/boringssl" ];then
  echo "Resource Library Existed"
  else
  git clone https://boringssl.googlesource.com/boringssl
fi
if [ -f "$data/patch" ];then
  echo "Resource Library Existed"
  else
  git clone --depth=1 https://github.com/kn007/patch.git
fi
if [ -f "$data/ngx_http_google_filter_module" ];then
  echo "Resource Library Existed"
  else
  git clone https://github.com/cuber/ngx_http_google_filter_module
fi
if [ -f "$data/quiche" ];then
  echo "Resource Library Existed"
  else
  git clone --recursive https://github.com/cloudflare/quiche
fi
if [ -f "$data/ngx_http_substitutions_filter_module" ];then
  echo "Resource Library Existed"
  else
  git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module
fi
if [ -f "$data/ngx-fancyindex" ];then
  echo "Resource Library Existed"
  else
  git clone https://github.com/aperezdc/ngx-fancyindex.git ngx-fancyindex
fi
if [ -f "$data/ngx_brotli" ];then
  echo "Resource Library Existed"
  else
  git clone https://github.com/google/ngx_brotli.git
fi
echo "Pull Resource Library Done,Processing Resources."
cd ngx_brotli
git submodule update --init
# Install cmake
cd $data
tar zxf cmake-3.15.4.tar.gz && cd cmake-3.15.4 && ./bootstrap && make && make install
ln -sf /usr/local/bin/cmake /usr/bin/cmake
#Install Jemalloc,Optional Parameters*
cd $data
tar -jvf jemalloc-5.2.1.tar.bz2
cd $data/jemalloc-5.2.1
make && make install
echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf
ldconfig
#Install Go
tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz
# Install Rust
bash <(curl https://sh.rustup.rs -sSf) -y
# Rust System environment variables
source $HOME/.cargo/env
# Go System environment variables
echo 'export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/.cargo/bin
export GOROOT=/usr/local/go
export GOBIN=$GOROOT/bin
export PATH=$PATH:$GOBIN' >> /etc/profile
source /etc/profile
# Unzip Resources
cd $data
tar xzf ngx_cache_purge-2.3.tar.gz
tar xzf ngx_slowfs_cache-1.9.tar.gz
tar xzf pcre-8.44.tar.gz
tar xzf nginx-1.19.4.tar.gz
# Compile SSL
cd boringssl
export CFLAGS="-Wno-error"
mkdir build && cd build && cmake ../ && make && cd ../
mkdir -p .openssl/lib && cd .openssl && ln -s ../include . && cd ../
cp build/crypto/libcrypto.a build/ssl/libssl.a .openssl/lib
# Compile Nginx
cd $data/nginx-1.19.4
patch -p01 < ../patch/nginx_with_quic.patch
#Quic Alternate Patch
#patch -p01 < ../quiche/extras/nginx/nginx-1.16.patch
#Ocsp Patch
#patch -p01 < ../patch/Enable_BoringSSL_OCSP.patch
./configure --prefix=$ngx_path --user=www --group=www --with-http_stub_status_module --with-http_v2_module --with-http_ssl_module --with-http_gzip_static_module --with-http_v3_module --with-http_realip_module --with-http_flv_module --with-http_mp4_module --with-pcre=../pcre-8.44 --with-pcre-jit --with-ld-opt=-ljemalloc --add-module=../ngx_http_substitutions_filter_module --add-module=../ngx_http_google_filter_module --add-module=../ngx_cache_purge-2.3 --add-module=../ngx_slowfs_cache-1.9 --add-module=../ngx-fancyindex --add-module=../ngx_brotli --with-openssl=../quiche/deps/boringssl --with-quiche=../quiche
touch ../boringssl/.openssl/include/openssl/ssl.h
make
# Seamless Upgrade
mv $ngx_path/sbin/nginx{,_`date +%m%d`}
cp objs/nginx $ngx_path/sbin/
nginx -t &>/dev/null
if [ $? -eq 0 ];then
 echo "Upgrade Successful, Br Parameter Write File."
 else
 echo "Upgrade Failed, Please Check For Errors."
fi
Brotli Compression
sed -i '/Brotli Compression/a\  brotli on;\n  brotli_min_length 20;\n  brotli_buffers 16 10k;\n  brotli_window 512k;\n  brotli_comp_level 6;\n  brotli_types\n    text/xml application/xml application/atom+xml application/rss+xml application/xhtml+xml image/svg+xml\n    text/javascript application/javascript application/x-javascript\n    text/x-json application/json application/x-web-app-manifest+json\n    text/css text/plain text/x-component\n    application/x-shockwave-flash application/pdf video/x-flv\n    font/opentype application/x-font-ttf application/vnd.ms-fontobject\n    image/jpeg image/gif image/png image/bmp image/x-icon\n    application/x-httpd-php;\n  brotli_static always;' 1.conf
service nginx restart
echo "Open 443 UDP Port To Support Quic"
iptables -A INPUT -p udp -m state --state NEW -m udp --dport 443 -j ACCEPT
service iptables restart && service iptables save &&service iptables restart
echo "Nginx upgrade is complete, please configure the Quic parameters for the site files yourself!"
