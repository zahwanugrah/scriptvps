#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(curl -s ipinfo.io/ip);
echo "Script Sakti Running"
clear
echo start
sleep 0.5
#source /var/lib/premium-script/ipvps.conf
domain=$(cat /etc/xray/domain)
systemctl stop xray
systemctl stop xray@none
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
systemctl start xray
systemctl start xray@none
echo Done
sleep 0.5
clear 
neofetch