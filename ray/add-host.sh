#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
white='\e[0;37m'
NC='\e[0m'
echo ""
read -rp " Please Input Your Domain/Host : " -e host
echo "$host" > /etc/xray/domain
clear
echo ""
echo -e "\e[0;32m Success Domain/Host $host Has Been Change!"
echo ""
read -sp " Press ENTER to go back"
echo ""
menu-xray