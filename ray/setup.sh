#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
white='\e[0;37m'
NC='\e[0m'

# install wget and curl git make
apt -y install wget curl git make

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# Installing some important machine essentials
 apt-get install nano zip unzip tar gzip p7zip-full bc rc openssl cron net-tools dnsutils dos2unix screen bzip2 ccrypt -y

# set time GMT +8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# Set Auto Reboot
 # Daily reboot time of our machine
 # For cron commands, visit https://crontab.guru
 echo "10 0 * * * root clear-log && reboot" >> /etc/crontab

 # Rebooting cron service
 systemctl restart cron
 systemctl enable cron

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=MY
state=Malaysia
locality=Malaysia
organization=PR-Aiman
organizationalunit=PR-Aiman
commonname=PR-Aiman
email=admin@PR-Aiman

# install webserver
apt -y install nginx

cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://github.com/praiman99/AutoScriptVPN-Xray/raw/beginner/Files/Plugins/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://github.com/praiman99/AutoScriptVPN-Xray/raw/beginner/Files/Plugins/vps.conf"
cd /home/vps/public_html
wget "https://github.com/praiman99/AutoScriptVPN-Xray/raw/beginner/Files/Plugins/index.html"
/etc/init.d/nginx restart

# Allow IPv4 Forwarding
sed -i '/net.ipv4.ip_forward.*/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_forward.*/d' /etc/sysctl.d/*.conf
echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/20-openvpn.conf
sysctl --system &> /dev/null

# Enabling IPv4 Forwarding
 echo 1 > /proc/sys/net/ipv4/ip_forward

#mkdir /var/lib/premium-script && echo "IP=$(curl -s ipinfo.io/ip)" >> /var/lib/premium-script/ipvps.conf

#Add Domain / Subdomain
clear
echo ""
echo -e "\e[0;37m Before start please field your domain/subdomain! "
echo ""
sleep 0.5
read -rp " Please input your domain/subdomain : " -e domain
echo "$domain" > /root/domain
clear 
echo ""
echo -e "\e[0;32m Success $domain Has Been Add! "
sleep 0.5

# Installation Toast
clear
echo -e ""
echo -e "\e[0;37m AutoScriptVPN-Xray VPS Installer Version 1.0 Will Begin"
echo -e ""
sleep 0.5
echo -e "\e[0;37m Report Bugs https://t.me/PR_Aiman"
echo -e ""
sleep 0.5
echo -e "\e[0;37m Script installer will be begin now..."
echo -e ""
sleep 0.5

if [ -f "/etc/v2ray/domain" ]; then
echo -e "\e[0;37m Found the Script V2ray is installed in this VPS"
echo ""
echo -e "\e[0;37m Please rebuild the VPS first before installing the Script AutoScriptVPN-Xray!"
rm -f setup.sh
exit 0
fi

if [ -f "/etc/xray/domain" ]; then
echo "Script Already Installed"
rm -f setup.sh
exit 0
fi
#wget https://github.com/praiman99/AutoScriptVPN-Xray/raw/beginner/Files/Xray/cf.sh && chmod +x cf.sh && ./cf.sh
#install xray
wget https://raw.githubusercontent.com/zahwanugrah/scriptvps/main/ray/ins-vt.sh && chmod +x ins-vt.sh && screen -S xray ./ins-vt.sh
#install additional tools
cd /usr/bin
wget -O add-host https://github.com/praiman99/AutoScriptVPN-Xray/raw/beginner/Files/Xray/add-host.sh && chmod +x add-host
wget -O change_timezone https://github.com/praiman99/AutoScriptVPN-Xray/raw/beginner/Files/Plugins/change_timezone.sh && chmod +x change_timezone
wget -O speedtest https://github.com/praiman99/AutoScriptVPN-Xray/raw/beginner/Files/Plugins/speedtest_cli.py && chmod +x speedtest

rm -f /root/ins-vt.sh

# install fail2ban
apt -y install fail2ban

# Install DDOS Deflate
cd
apt-get -y install dnsutils dsniff
wget "https://github.com/praiman99/AutoScriptVPN-Xray/raw/beginner/Files/Plugins/ddos-deflate-master.zip"
unzip ddos-deflate-master.zip
cd ddos-deflate-master
./install.sh
cd
rm -rf ddos-deflate-master.zip

# Blocked Torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service

cat > /etc/systemd/system/rc-local.service <<-END

[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local

systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# Running screenfetch
 wget -O /usr/bin/screenfetch "https://github.com/praiman99/AutoScriptVPN-Xray/raw/beginner/Files/Plugins/screenfetch"
 chmod +x /usr/bin/screenfetch
 echo "clear" >> .profile
 echo "screenfetch" >> .profile

history -c
echo "1.2" > /home/ver
clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "=================================-AutoScriptVPN-Xray-==========================" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "--------------------------------------------------------------------------------" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - Xray Vmess TLS         : 8443"  | tee -a log-install.txt
echo "   - Xray Vmess None TLS    : 80"  | tee -a log-install.txt
echo "   - Xray Vless TLS         : 2083"  | tee -a log-install.txt
echo "   - Xray Vless None TLS    : 8880"  | tee -a log-install.txt
echo "   - Trojan                  : 2087"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Kuala_Lumpur (GMT +8)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Auto Reboot On 00.10 GMT +8" | tee -a log-install.txt
echo "   - White Label" | tee -a log-install.txt
echo "   - Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Credit To"  | tee -a log-install.txt
echo "   - Orignal Base Script     : Horas Marolop Amsal Siregar"  | tee -a log-install.txt
echo "   - Orignal Menu Script     : FordSenpai"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Thanks For Help To"  | tee -a log-install.txt
echo "   - Horas                   : https://t.me/horasss"  | tee -a log-install.txt
echo "   - RasCom                  : https://t.me/myskynblack"  | tee -a log-install.txt
echo "   - Wildy Project           : https://t.me/wildyproject"  | tee -a log-install.txt
echo "   - Syahir                  : Hidden"  | tee -a log-install.txt
echo "   - SweetieSSH              : https://t.me/SweetieSSH"  | tee -a log-install.txt
echo "   - -Mawar X86-             : https://t.me/mawarx86"  | tee -a log-install.txt
echo "   - Zahyyvpnstore           : https://t.me/Zahyy_33"  | tee -a log-install.txt
echo "   - Evil Plankton           : https://t.me/planktoneye"  | tee -a log-install.txt
echo "   - VPNNEO.com              : https://t.me/vpnneo"  | tee -a log-install.txt
echo "   - VPNStunnel.com          : https://t.me/denb4gus"  | tee -a log-install.txt
echo "   - Incorrect               : https://t.me/incorrect_cuy"  | tee -a log-install.txt
echo "   - Khoceng                 : https://t.me/KhocengReal765"  | tee -a log-install.txt
echo "   - ipaan                   : https://t.me/irfanmlnaaysf"  | tee -a log-install.txt
echo "   - Darknet                 : https://t.me/cyberbossz"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "--------------------------Script Remodified By PR Aiman-------------------------" | tee -a log-install.txt
echo ""
echo " Reboot 15 Sec"
sleep 15
rm -f setup.sh
reboot

