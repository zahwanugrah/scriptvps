#!/bin/bash
#Script by : PR Aiman

red='\e[1;31m'
green='\e[0;32m'
white='\e[0;37m'
NC='\e[0m'
clear
echo -e "\e[0m                                                   "
echo -e "\e[1;31m     [*][*][*]======================================[*][*][*]"
echo -e "\e[0m                                                   "
echo -e "\e[0;37m                  AutoScriptVPN-Xray by PR Aiman"
echo -e "\e[0m                                                   "
echo -e "\e[0;37m                    [1] Renew Account Vmess"
echo -e "\e[0;37m                    [2] Renew Account Vless"
echo -e "\e[0;37m                    [3] Renew Account Trojan"
echo -e "\e[0;37m                    [4] Delete Account Vmess"
echo -e "\e[0;37m                    [5] Delete Account Vless"
echo -e "\e[0;37m                    [6] Delete Account Trojan"
echo -e "\e[0;37m                    [7] Change Port Vmess"
echo -e "\e[0;37m                    [8] Change Port Vless"
echo -e "\e[0;37m                    [9] Change Port Trojan"
echo -e "\e[0;37m                    [10] Check Account Vmess Login"
echo -e "\e[0;37m                    [11] Check Account Vless Login"
echo -e "\e[0;37m                    [12] Check Account Trojan Login"
echo -e "\e[0;37m                    [13] Back"
echo -e "\e[0;37m                    [x] Exit"
echo -e "\e[0m                                                   "
read -p "              Select From Options [1-13 or x] :  " options_xray
echo -e "\e[0m                                                   "
echo -e "\e[1;31m     [*][*][*]======================================[*][*][*]"
clear
case $options_xray in
		1)
		clear
		renew-ws
		exit
		;;
		2)
		clear
		renew-vless
		exit
		;;
		3)
		clear
		renew-tr
		exit
		;;
		4)
		clear
		del-ws
		exit
		;;
		5)
		clear
		del-vless
		exit
		;;
		6)
		clear
		del-tr
		exit
		;;
		7)
		clear
		port-ws
		exit
		;;
		8)
		clear
		port-vless
		exit
		;;
		9)
		clear
		port-tr
		exit
		;;
		10)
		clear
		cek-ws
		exit
		;;
		11)
		clear
		cek-vless
		exit
		;;
		12)
		clear
		cek-tr
		exit
		;;
		13)
		clear
		menu-xray
		exit
		;;
		x)
		clear
		exit
		;;
		*)
        options-xray
		;;
	esac
