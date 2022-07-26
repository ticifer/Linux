# Linux
Some Base On Centos6.X|Centos7.X Shell Bash<br>
一些基于Centos6.X|Centos7.X|Ubutun18.04+|Debian10+的脚本<br>
## aria2c<br>
Aria2 Service Bash<br>
Aria2服务脚本<br>
File storage directory<br>
文件存放目录<br>
<pre>
/etc/init.d/
</pre>
Support Start、Stop、Status、Restart<br>
支持启动、停止、状态、重启<br>
Usage<br>
用法：<br>
<pre>
service aria2c start
</pre>
Please Execute Before Use：<br>
使用前请执行：<br>
<pre>
chmod +x aria2c
</pre>

## gcc.sh<br>
gcc update auto install bash<br>
gcc升级自动编译安装脚本<br>
Please Execute Before Use：<br>
使用前请执行：<br>
<pre>
chmod +x gcc.sh
</pre>
Usage<br>
用法：<br>
<pre>
./gcc.sh
</pre>

## Aria.sh<br>
Aria2 Install Bash<br>
Aria2 安装脚本<br>
Please Execute Before Use：<br>
使用前请执行：<br>
<pre>
chmod +x gcc.sh
</pre>
Usage<br>
用法：<br>
<pre>
./Aria.sh
</pre>

## nginx_quic.sh<br>
Nginx Quic Automatic compilation and installation<br>
Nginx Quic 一键安装脚本<br>
Please Execute Before Use：<br>
使用前请执行：<br>
<pre>
chmod +x nginx_quic.sh
</pre>
Usage<br>
用法：<br>
<pre>
./nginx-quic.sh
</pre>
注意事项：<br>
Precautions:<br>
运行脚本前，自行修改资源路径及nginx安装路径<br>
Before running the script, modify the resource path and nginx installation path by yourself

# mtr_trace
检测VPS回程国内三网路由，用法：
<pre>
curl https://raw.githubusercontent.com/ticifer/Linux/main/mtr_trace.sh|bash
</pre>
支持的线路为：电信CN2 GT，电信CN2 GIA，联通169，电信163，联通9929，联通4837，移动CMI
<pre>
电信目标IP：

#深圳电信：
./besttrace 58.60.188.222

mtr -c 100 --report 58.60.188.222

#上海电信：
./besttrace 202.96.209.133

mtr -c 100 --report 202.96.209.133

#北京电信：
./besttrace 219.141.136.12

mtr -c 100 --report 219.141.136.12

#重庆电信：
./besttrace 61.128.128.68

mtr -c 100 --report 61.128.128.68

联通目标IP：

#深圳联通：
./besttrace 210.21.196.6

mtr -c 100 --report 210.21.196.6

#上海联通：
./besttrace 210.22.97.1

mtr -c 100 --report 210.22.97.1

#北京联通：
./besttrace 202.106.50.1

mtr -c 100 --report 202.106.50.1

#重庆联通
./besttrace 221.7.92.98
mtr -c 100 --report 221.7.92.98

移动目标IP：

#深圳移动：
./besttrace 120.196.165.24

mtr -c 100 --report 120.196.165.24

#上海移动：
./besttrace 211.136.112.200

mtr -c 100 --report 211.136.112.200

#北京移动：
./besttrace 221.179.155.161

mtr -c 100 --report 221.179.155.161

#重庆移动
./besttrace 221.7.92.98
mtr -c 100 --report 218.201.4.3
</pre>

## Superspeed.sh
- Description: Test your server's network with Speedtest to China
 
<pre>
Usage:
| No.      | Bash Command                    
|----------|---------------------------------
| 1        | wget https://raw.githubusercontent.com/ticifer/Linux/master/3net.sh      
| 2        | chmod +x 3net.sh
| 3        | ./3net.sh
</pre>