#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
white='\e[0;37m'
NC='\e[0m'
MYIP=$(curl -s ipinfo.io/ip);
clear
uuid=$(cat /etc/trojan/uuid.txt)
#source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
tr="$(cat ~/log-install.txt | grep -i Trojan | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp " Password: " -e user
		user_EXISTS=$(grep -w $user /etc/trojan/akun.conf | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo " A client with the specified name was already created, please choose another name."
			echo ""
			read -sp " Press ENTER to go back"
            echo ""
            menu-xray
		fi
	done
read -p " Expired (days): " masaaktif
sed -i '/"'""$uuid""'"$/a\,"'""$user""'"' /etc/trojan/config.json
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo -e "### $user $exp" >> /etc/trojan/akun.conf
systemctl restart trojan
trojanlink="trojan://${user}@${domain}:${tr}"
clear
echo -e ""
echo -e "\e[1;31m[*][*][*]=============-Trojan-============[*][*][*]"
echo -e "\e[0;37m          AutoScriptVPN-Xray by PR Aiman"
echo -e "\e[0;37m Remarks        : ${user}"
echo -e "\e[0;37m Domain         : ${domain}"
echo -e "\e[0;37m IP Address     : $MYIP"
echo -e "\e[0;37m port           : ${tr}"
echo -e "\e[0;37m Key            : ${user}"
echo -e "\e[0;37m link           : ${trojanlink}"
echo -e "\e[1;31m[*][*][*]=================================[*][*][*]"
echo -e "\e[0;37m Expired On     : $exp"
echo ""
read -sp " Press ENTER to go back"
echo ""
menu-xray