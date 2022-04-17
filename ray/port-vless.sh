#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
white='\e[0;37m'
NC='\e[0m'
MYIP=$(curl -s ipinfo.io/ip);
clear
tls="$(cat ~/log-install.txt | grep -w "Vless TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vless None TLS" | cut -d: -f2|sed 's/ //g')"
echo -e "\e[1;31m[*][*][*]======================================[*][*][*]"
echo -e "\e[0;37m             AutoScriptVPN-Xray by PR Aiman"
echo -e ""
echo -e "\e[0;37m     [1]  Change Port Vless TLS $tls"
echo -e "\e[0;37m     [2]  Change Port Vless None TLS $none"
echo -e "\e[0;37m     [x]  Exit"
echo -e "\e[1;31m[*][*][*]======================================[*][*][*]"
echo -e ""
read -p "     Select From Options [1-2 or x] :  " prot
echo -e ""
case $prot in
1)
read -p "New Port Vless TLS: " tls1
if [ -z $tls1 ]; then
echo -e "\e[0;37m Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $tls1)
if [[ -z $cek ]]; then
sed -i "s/$tls/$tls1/g" /etc/xray/vless.json
sed -i "s/   - xray Vless TLS         : $tls/   - xray Vless TLS         : $tls1/g" /root/log-install.txt
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $tls -j ACCEPT
iptables -D INPUT -m state --state NEW -m udp -p udp --dport $tls -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $tls1 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport $tls1 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save > /dev/null
netfilter-persistent reload > /dev/null
systemctl restart xray@vless > /dev/null
echo -e "${green} Port $tls1 modified successfully "
else
echo -e "\e[1;31m Port $tls1 is used "
fi
;;
2)
read -p "New Port Vless None TLS: " none1
if [ -z $none1 ]; then
echo -e "\e[0;37m Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $none1)
if [[ -z $cek ]]; then
sed -i "s/$none/$none1/g" /etc/xray/vnone.json
sed -i "s/   - xray Vless None TLS    : $none/   - xray Vless None TLS    : $none1/g" /root/log-install.txt
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $none -j ACCEPT
iptables -D INPUT -m state --state NEW -m udp -p udp --dport $none -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $none1 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport $none1 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save > /dev/null
netfilter-persistent reload > /dev/null
systemctl restart xray@vnone > /dev/null
echo -e "${green} Port $none1 modified successfully "
else
echo -e "\e[1;31m Port $none1 is used "
fi
;;
x)
exit
menu
;;
*)
clear
port-vless
;;
esac
echo ""
read -sp " Press ENTER to go back"
echo ""
options-xray