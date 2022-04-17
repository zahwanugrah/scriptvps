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
tls="$(cat ~/log-install.txt | grep -w "Vmess TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vmess None TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp " User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo " A client with the specified name was already created, please choose another name."
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
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
sed -i '/#none$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/none.json
cat>/etc/xray/$user-tls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${tls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/praiman",
      "type": "none",
      "host": "bug",
      "tls": "tls"
}
EOF
cat>/etc/xray/$user-none.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${none}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/praiman",
      "type": "none",
      "host": "bug",
      "tls": "none"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmesslink1="vmess://$(base64 -w 0 /etc/xray/$user-tls.json)"
vmesslink2="vmess://$(base64 -w 0 /etc/xray/$user-none.json)"
systemctl restart xray
systemctl restart xray@none
service cron restart
clear
echo -e ""
echo -e "\e[1;31m[*][*][*]==========-Xray/VMESS-==========[*][*][*]"
echo -e "\e[0;37m          AutoScriptVPN-Xray by PR Aiman"
echo -e "\e[0;37m Remarks        : ${user}"
echo -e "\e[0;37m Domain         : ${domain}"
echo -e "\e[0;37m IP Address     : $MYIP"
echo -e "\e[0;37m port TLS       : ${tls}"
echo -e "\e[0;37m port none TLS  : ${none}"
echo -e "\e[0;37m id             : ${uuid}"
echo -e "\e[0;37m alterId        : 0"
echo -e "\e[0;37m Security       : auto"
echo -e "\e[0;37m network        : ws"
echo -e "\e[0;37m path           : /praiman"
echo -e "\e[1;31m[*][*][*]=================================[*][*][*]"
echo -e "\e[0;37m link TLS       : ${vmesslink1}"
echo -e "\e[1;31m[*][*][*]=================================[*][*][*]"
echo -e "\e[0;37m link none TLS  : ${vmesslink2}"
echo -e "\e[1;31m[*][*][*]=================================[*][*][*]"
echo -e "\e[0;37m Expired On     : $exp"
echo ""
read -sp " Press ENTER to go back"
echo ""
menu-xray