#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
white='\e[0;37m'
NC='\e[0m'
MYIP=$(curl -s ipinfo.io/ip);
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/vless.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		clear
		echo ""
		echo -e "\e[1;31m You have no existing clients!"
		echo ""
        read -sp " Press ENTER to go back"
        echo ""
        options-xray
	fi

	clear
	echo ""
	echo -e "\e[0;37m Select the existing client you want to renew"
	echo -e "\e[0;37m Press CTRL+C to return"
	echo -e "\e[1;31m[*][*][*]===============================[*][*][*]"
	grep -E "^### " "/etc/xray/vless.json" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
read -p "Expired (days): " masaaktif
user=$(grep -E "^### " "/etc/xray/vless.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/xray/vless.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "s/### $user $exp/### $user $exp4/g" /etc/xray/vless.json
sed -i "s/### $user $exp/### $user $exp4/g" /etc/xray/vnone.json
service cron restart
clear
echo ""
echo -e "\e[0;37m VLESS Account Was Successfully Renewed"
echo -e "\e[1;31m[*][*][*]==========================[*][*][*]"
echo -e "\e[0;37m Client Name : $user"
echo -e "\e[0;37m Expired On  : $exp4"
echo -e "\e[1;31m[*][*][*]==========================[*][*][*]"
echo ""
read -sp " Press ENTER to go back"
echo ""
options-xray