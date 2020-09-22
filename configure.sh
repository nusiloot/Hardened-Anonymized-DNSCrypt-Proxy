#!/bin/bash

echo
echo -e '+=======================================================================+'
echo -e '+                     Anonymized-DNSCrypt-Proxy-Linux                   +'
echo -e '+      Automatically Configure/Deconfigure Anonymized-DNSCrypt-Proxy    +'
echo -e '+                          Coder : BL4CKH47H4CK3R                       +'
echo -e '+=======================================================================+'
echo

echo -e 'Installing DNSCrypt-Proxy ...\n'
if ! [ -z `which pacman 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Arch
then pacman -Sy dnscrypt-proxy --noconfirm
fi
if ! [ -z `which apt-get 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Debian
then apt install dnscrypt-proxy -y
fi
if ! [ -z `which dnf 2> /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Gentoo
then emerge dnscrypt-proxy -av
fi

echo -e '\nDisabling SystemD-Resolved ...'
systemctl disable --now systemd-resolved -f

echo -e 'Applying DNSCrypt-Proxy configurations ...'
rm -rf /etc/NetworkManager/NetworkManager.conf
rm -rf /etc/resolv.conf
rm -rf /etc/dnscrypt-proxy/dnscrypt-proxy.toml
cp dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
echo -e '[device]\nwifi.scan-rand-mac-address=yes\nethernet.cloned-mac-address=random\nwifi.cloned-mac-address=stable\n\n[main]\ndns=none' >/etc/NetworkManager/NetworkManager.conf
echo -e 'nameserver ::1\nnameserver 127.0.0.1\noptions edns0 single-request-reopen' > /etc/resolv.conf

echo -e 'Initializing  DNSCrypt-Proxy ...\n'
systemctl enable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f

echo -e '\nChecking DNSCrypt-Proxy Service Status . . .\n'
dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -service restart
dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -check

echo -e '\nApplying IPTables/Firewall Ruleset . . .'
iptables -t nat -A OUTPUT -p tcp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination 127.0.0.1:5354
iptables -t nat -A OUTPUT -p udp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination 127.0.0.1:5354
ip6tables -A OUTPUT -p tcp -j DROP
ip6tables -A OUTPUT -p udp -j DROP

echo -e 'Restarting NetworkManager . . .'
systemctl restart --now NetworkManager -f

echo -e '\nAnonymized DNSCrypt-Proxy-Linux Successfully Configured\nEnjoy Anonymity & Show Middle Fingers To Snoopers !\n'
