#!/bin/bash

clear
echo -e "\n#########################################################################"
echo -e "#                    Anonymized-DNSCrypt-Proxy-Linux                    #"
echo -e "#              Hardened Anonymized-DNSCrypt-Proxy For Linux             #"
echo -e "#                         Coder : BL4CKH47H4CK3R                        #"
echo -e "#########################################################################\n"

if [[ ${UID} != 0 ]]
then
	echo -e "Run The Script As Root, Are Your Drunk Dude ?"
else
	echo -e "[1] Configure"
	echo -e "[2] Deconfigure"
	read -p "[*] Enter Choice [1 or 2]: " input

	if [[ ${input} == 1 ]]
	then
		echo -e "\n[*] Installing DNSCrypt-Proxy ...\n"
		if ! [ -z `which pacman 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Arch
		then
			pacman -Syy dnscrypt-proxy --needed --noconfirm
		elif ! [ -z `which apt 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Debian
		then
			echo "deb https://deb.debian.org/debian/ testing main" | sudo tee /etc/apt/sources.list.d/testing.list && apt update && apt install -y -t testing dnscrypt-proxy
		elif ! [ -z `which emerge 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Gentoo
		then
			emerge dnscrypt-proxy -av
		elif ! [ -z `which apk 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Alpine
		then
			sh -c 'echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories' && apk add --upgrade dnscrypt-proxy
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
		
		echo -e "\n[*] Disabling SystemD-Resolved ..."
		systemctl disable --now systemd-resolved -f
		
		echo -e "[*] Applying DNSCrypt-Proxy configurations ..."
		rm -rf /etc/dnscrypt-proxy/dnscrypt-proxy.toml
		cp dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
		
		echo -e "[*] Initializing  DNSCrypt-Proxy ...\n"
		systemctl enable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f
		echo -e "\n[*] Checking DNSCrypt-Proxy Service Status . . .\n"
		dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -service restart
		dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -check
		
		echo -e "\n[*] Applying IPTables/Firewall Ruleset . . ."
		iptables -t nat -A OUTPUT -p tcp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination 127.0.0.1:5354
		iptables -t nat -A OUTPUT -p udp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination 127.0.0.1:5354
		# ip6tables -t nat -A OUTPUT -p udp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination [::1]:5354
		# ip6tables -t nat -A OUTPUT -p tcp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination [::1]:5354					
		
		echo -e "[*] Configuring & Restarting NetworkManager . . ."
		rm -rf /etc/NetworkManager/NetworkManager.conf
		rm -rf /etc/resolv.conf
		echo -e "[device]\nwifi.scan-rand-mac-address=yes\nethernet.cloned-mac-address=random\nwifi.cloned-mac-address=stable\n\n[main]\ndns=none" > /etc/NetworkManager/NetworkManager.conf
		echo -e "nameserver ::1\nnameserver 127.0.0.1\noptions edns0 single-request-reopen" > /etc/resolv.conf
		systemctl restart --now NetworkManager -f
		
		echo -e "\n[*] Anonymized DNSCrypt-Proxy-Linux Successfully Configured\n[*] Enjoy Anonymity & Show Middle Fingers To Snoopers !\n[*] Please Reboot Your System To Take Effect !\n"	
	
	elif [[ ${input} == 2 ]]
	then
		echo -e "[*] Hold Your Horses !\nReverting All Settings To Default State . . .\n"
		echo -e "[*] Killing NetworkManager ..."
		systemctl stop --now NetworkManager -f
		echo -e "[*] Disabling DNSCrypt-Proxy ..."
		systemctl disable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f
		
		echo -e "\n[*] Uninstalling DNSCrypt-Proxy ...\n"
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

		echo -e "[*] Reverting DNSCrypt-Proxy Configurations ..."
		rm -rf /etc/NetworkManager/NetworkManager.conf
		rm -rf /etc/resolv.conf
		rm -rf /etc/dnscrypt-proxy/dnscrypt-proxy.toml
		echo -e '[device]\nwifi.scan-rand-mac-address=yes\nethernet.cloned-mac-address=random\nwifi.cloned-mac-address=stable' > /etc/NetworkManager/NetworkManager.conf
		
		echo -e "[*] Restarting SystemD-Resolved ..."
		systemctl enable --now systemd-resolved -f
		
		echo -e "[*] Restarting NetworkManager ..."
		systemctl restart --now NetworkManager -f
		
		echo -e "\n[*] Anonymized DNSCrypt-Proxy-Linux Successfully Deconfigured\n[*] Let Snoopers Show You Their Middle Fingers\n[*] Please Reboot Your System To Take Effect !\n"
	fi
fi
