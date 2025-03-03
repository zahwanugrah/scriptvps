#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
white='\e[0;37m'
NC='\e[0m'
MYIP=$(curl -s ipinfo.io/ip);
clear
#source /var/lib/premium-script/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
tls="$(cat ~/log-install.txt | grep -w "Vless TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vless None TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp " User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/vless.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
			read -sp " Press ENTER to go back"
            echo ""
            menu-xray
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p " Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/vless.json
sed -i '/#none$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/vnone.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=/praiman&security=tls&encryption=none&type=ws#${user}"
vlesslink2="vless://${uuid}@${domain}:$none?path=/praiman&encryption=none&type=ws#${user}"
systemctl restart xray@vless
systemctl restart xray@vnone
clear
echo -e ""
echo -e "\e[1;31m[*][*][*]==========-Xray/VLESS-==========[*][*][*]"
echo -e "\e[0;37m          AutoScriptVPN-Xray by PR Aiman"
echo -e "\e[0;37m Remarks        : ${user}"
echo -e "\e[0;37m Domain         : ${domain}"
echo -e "\e[0;37m IP Address     : $MYIP"
echo -e "\e[0;37m port TLS       : $tls"
echo -e "\e[0;37m port none TLS  : $none"
echo -e "\e[0;37m id             : ${uuid}"
echo -e "\e[0;37m Encryption     : none"
echo -e "\e[0;37m network        : ws"
echo -e "\e[0;37m path           : /praiman"
echo -e "\e[1;31m[*][*][*]=================================[*][*][*]"
echo -e "\e[0;37m link TLS       : ${vlesslink1}"
echo -e "\e[1;31m[*][*][*]=================================[*][*][*]"
echo -e "\e[0;37m link none TLS  : ${vlesslink2}"
echo -e "\e[1;31m[*][*][*]=================================[*][*][*]"
echo -e "\e[0;37m Expired On     : $exp"
echo ""
read -sp " Press ENTER to go back"
echo ""
menu-xray