#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
white='\e[0;37m'
NC='\e[0m'
MYIP=$(curl -s ipinfo.io/ip);
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo -e "${red} You have no existing clients!"
		echo ""
        read -sp " Press ENTER to go back"
        echo ""
        options-xray
	fi

	clear
	echo ""
	echo -e "${white} Select the existing client you want to remove"
	echo -e "${white} Press CTRL+C to return"
	echo -e "${red}[*][*][*]===============================[*][*][*]"
	echo -e "${white}     No  Expired   User"
	grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^### $user $exp/,/^},{/d" /etc/xray/none.json
rm -f /etc/xray/$user-tls.json /etc/xray/$user-none.json
systemctl restart xray
systemctl restart xray@none
clear
echo -e "${white} Vmess Account Deleted Successfully"
echo -e "${red}[*][*][*]==========================[*][*][*]"
echo -e "${white} Client Name : $user"
echo -e "${white} Expired On  : $exp"
echo -e "${red}[*][*][*]==========================[*][*][*]"
echo ""
read -sp " Press ENTER to go back"
echo ""
options-xray