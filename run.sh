#!/bin/bash

if [[ ${UID} != 0 ]]
then
	echo -e "============================"
	echo -e "|  Run The Script As Root  |"
	echo -e "============================"
else
	clear
	echo -e "============================================"
	echo -e "|    Hardened-Anonymized-DNSCrypt-Proxy    |"
	echo -e "|    Wipe Snoopers Out Of Your Networks    |"
	echo -e "|          Coder : BL4CKH47H4CK3R          |"
	echo -e "============================================"
	echo -e "|   [1] Configure     |"
	echo -e "|   [2] Deconfigure   |"
	echo -e "======================="
	read -p "[*] Enter Choice [1 or 2]: " input

	if [[ ${input} == 1 ]]
	then	
		echo -e "==================================="
		echo -e "|  Installing DNSCrypt-Proxy ...  |"
		echo -e "==================================="
		if ! [ -z `which pacman 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Arch
		then
			pacman -S dnscrypt-proxy --needed --noconfirm
		
		elif ! [ -z `which apt 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Debian
		then
			curl -O http://ftp.br.debian.org/debian/pool/main/d/dnscrypt-proxy/dnscrypt-proxy_2.0.44+ds1-3_amd64.deb
			apt install -y dnscrypt-proxy_2.0.44+ds1-3_amd64.deb && rm dnscrypt-proxy_2.0.44+ds1-3_amd64.deb
		
		elif ! [ -z `which emerge 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Gentoo
		then
			emerge dnscrypt-proxy -av
		
		elif ! [ -z `which apk 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Alpine
		then
			sh -c 'echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories'
			apk add --upgrade dnscrypt-proxy
		
		elif ! [ -z `which dnf 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Fedora
		then
			dnf install dnscrypt-proxy
		
		elif ! [ -z `which urpmi 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Mageia
		then
			urpmi.update -a && urpmi dnscrypt-proxy
		
		elif ! [ -z `which zypper 2> /dev/null` ] && [ `nmcli networking` = "enabled"]; # OpenSUSE
		then
			zypper install dnscrypt-proxy
		
		elif ! [ -z `which upgradepkg 2> /dev/null` ] && [ `nmcli networking` = "enabled"]; # Slackware 14.2
		then
			upgradepkg --install-new dnscrypt-proxy-2.0.42-x86_64-1_slonly.txz
		
		elif ! [ -z `which eopkg 2> /dev/null` ] && [ `nmcli networking` = "enabled"]; # Solus
		then
			eopkg install dnscrypt-proxy
		fi

		echo -e "======================================"
		echo -e "|    Disabling SystemD-Resolved ...  |"
		echo -e "======================================"
		systemctl disable --now systemd-resolved -f

		echo -e "================================================="
		echo -e "|   Applying DNSCrypt-Proxy configurations ...  |"
		echo -e "================================================="
		rm -rf /etc/dnscrypt-proxy/dnscrypt-proxy.toml
		cp dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml

		echo -e "========================================"
		echo -e "|   Initializing  DNSCrypt-Proxy ...   |"
		echo -e "========================================"
		systemctl enable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f
		
		echo -e "===================================================="
		echo -e "|   Checking DNSCrypt-Proxy Service Status . . .   |"
		echo -e "===================================================="
		dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -service restart
		dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -check

		echo -e "================================================"
		echo -e "|   Applying IPTables/Firewall Ruleset . . .   |"
		echo -e "================================================"
		iptables -t nat -A OUTPUT -p tcp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination 127.0.0.1:5354
		iptables -t nat -A OUTPUT -p udp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination 127.0.0.1:5354
		# ip6tables -t nat -A OUTPUT -p udp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination [::1]:5354
		# ip6tables -t nat -A OUTPUT -p tcp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination [::1]:5354

		echo -e "===================================================="
		echo -e "|   Configuring & Restarting NetworkManager . . .  |"
		echo -e "===================================================="
		rm -rf /etc/NetworkManager/NetworkManager.conf
		rm -rf /etc/resolv.conf
		echo -e "[device]\nwifi.scan-rand-mac-address=yes" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "ethernet.cloned-mac-address=random" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "wifi.cloned-mac-address=stable\n" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "[main]\ndns=none" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "nameserver ::1\nnameserver 127.0.0.1\noptions edns0 single-request-reopen" > /etc/resolv.conf
		systemctl restart --now NetworkManager -f
		
		echo -e "===================================="
		echo -e "|  Reboot System To Take Effect !  |"
		echo -e "===================================="
	
	elif [[ ${input} == 2 ]]
	then
		echo -e "==================================================="
		echo -e "|  Reverting All Settings To Default State . . .  |"
		echo -e "==================================================="
		echo -e "|  Killing NetworkManager ...  |"
		echo -e "================================"
		systemctl stop --now NetworkManager -f

		echo -e "=================================="
		echo -e "|  Disabling DNSCrypt-Proxy ...  |"
		echo -e "=================================="
		systemctl disable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f
		
		echo -e "====================================="
		echo -e "|  Uninstalling DNSCrypt-Proxy ...  |"
		echo -e "====================================="
		if ! [ -z `which pacman 2 > /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Arch
		then
			pacman -Rcnsu dnscrypt-proxy --noconfirm
		elif ! [ -z `which apt 2 > /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Debian
		then
			apt purge -y dnscrypt-proxy
		elif ! [ -z `which emerge 2 > /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Gentoo
		then
			emerge dnscrypt-proxy -Cv
		fi

		echo -e "================================================="
		echo -e "|  Reverting DNSCrypt-Proxy Configurations ...  |"
		echo -e "================================================="
		rm -rf /etc/NetworkManager/NetworkManager.conf
		rm -rf /etc/resolv.conf
		rm -rf /etc/dnscrypt-proxy/dnscrypt-proxy.toml
		echo -e "[device]\nwifi.scan-rand-mac-address=yes\n" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "ethernet.cloned-mac-address=random\n" >> /etc/NetworkManager/NetworkManager.conf
		echo -e "wifi.cloned-mac-address=stable" >> /etc/NetworkManager/NetworkManager.conf
		
		echo -e "====================================="
		echo -e "|  Restarting SystemD-Resolved ...  |"
		echo -e "====================================="
		systemctl enable --now systemd-resolved -f

		echo -e "==================================="
		echo -e "|  Restarting NetworkManager ...  |"
		echo -e "==================================="
		systemctl restart --now NetworkManager -f
		
		echo -e "===================================="
		echo -e "|  Reboot System To Take Effect !  |"
		echo -e "===================================="
	fi
fi
