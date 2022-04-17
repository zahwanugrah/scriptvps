#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
white='\e[0;37m'
NC='\e[0m'
MYIP=$(curl -s ipinfo.io/ip);
echo -n > /tmp/other.txt
data=( `cat /etc/xray/vless.json | grep '^###' | cut -d ' ' -f 2`);
echo -e "\e[1;31m-------------------------------";
echo -e "\e[0;37m-----=[ Vless User Login ]=-----";
echo -e "\e[1;31m-------------------------------";
for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi
echo -n > /tmp/ipvless.txt
data2=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep xray | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /var/log/xray/access2.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipvless.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipvless.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done
jum=$(cat /tmp/ipvless.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipvless.txt | nl)
echo -e "\e[0;37m user : $akun";
echo -e "\e[0;37m $jum2";
echo -e "\e[1;31m-------------------------------"
fi
rm -rf /tmp/ipvmess.txt
done
oth=$(cat /tmp/other.txt | sort | uniq | nl)
echo -e "\e[0;37m other";
echo -e "\e[0;37m $oth";
echo -e "\e[1;31m-------------------------------"
rm -rf /tmp/other.txt
echo ""
read -sp " Press ENTER to go back"
echo ""
options-xray