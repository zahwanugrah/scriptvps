#!/bin/bash
#Script by : PR Aiman

red='\e[1;31m'
green='\e[0;32m'
white='\e[0;37m'
NC='\e[0m'
clear
echo -e "\e[0;32m              AutoScriptVPN-Xray Installer Version 1.0"
echo -e "\e[0m                                                   "
echo -e "\e[1;31m     [*][*][*]======================================[*][*][*]"
echo -e "\e[0m                                                   "
echo -e "\e[0;37m                  AutoScriptVPN-Xray by PR Aiman"
echo -e "\e[0m                                                   "
echo -e "\e[0;37m                    [1] Create Account Vmess"
echo -e "\e[0;37m                    [2] Create Account Vless"
echo -e "\e[0;37m                    [3] Create Account Trojan"
echo -e "\e[0;37m                    [4] Change VPS Password"
echo -e "\e[0;37m                    [5] Change Timezone"
echo -e "\e[0;37m                    [6] Change Domain"
echo -e "\e[0;37m                    [7] Speedtest VPS"
echo -e "\e[0;37m                    [8] More Options"
echo -e "\e[0;37m                    [x] Exit"
echo -e "\e[0m                                                   "
read -p "              Select From Options [1-8 or x] :  " menu_xray
echo -e "\e[0m                                                   "
echo -e "\e[1;31m     [*][*][*]======================================[*][*][*]"
clear
case $menu_xray in
		1)
		clear
		add-ws
		exit
		;;
		2)
		clear
		add-vless
		exit
		;;
		3)
		clear
		add-tr
		exit
		;;
		4)
		clear
		passwd
		echo ""
        read -sp " Press ENTER to go back"
        echo ""
        menu-xray
		;;
		5)
		clear
		change_timezone
		exit
		;;
        6)
		clear
		add-host
		exit
		;;
		7)
		clear
		speedtest
		echo ""
        read -sp " Press ENTER to go back"
        echo ""
        menu-xray
		;;
        8)
		clear
		options-xray
		exit
		;;
		x)
		clear
		exit
		;;
		*)
        menu-xray
		;;
	esac
