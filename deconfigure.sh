#!/bin/bash

echo
echo -e '+=======================================================================+'
echo -e '+                     Anonymized-DNSCrypt-Proxy-Linux                   +'
echo -e '+      Automatically Configure/Deconfigure Anonymized-DNSCrypt-Proxy    +'
echo -e '+                          Coder : BL4CKH47H4CK3R                       +'
echo -e '+=======================================================================+'
echo

echo -e 'Hold Your Horses !\nReverting All Settings To Default State . . .\n'
echo -e 'Killing NetworkManager ...'
systemctl stop --now NetworkManager -f

echo -e 'Disabling DNSCrypt-Proxy ...'
systemctl disable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f

echo -e '\nUninstalling DNSCrypt-Proxy ...\n'
if ! [ -z `which pacman 2 > /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Arch
then pacman -Rcnsu dnscrypt-proxy --noconfirm
fi
if ! [ -z `which apt 2 > /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Debian
then apt purge -y dnscrypt-proxy
fi
if ! [ -z `which emerge 2 > /dev/null` ] && [ `nmcli networking` = "enabled" ]; # Gentoo
then emerge dnscrypt-proxy -Cv
fi

echo -e 'Reverting DNSCrypt-Proxy Configurations ...'
rm -rf /etc/NetworkManager/NetworkManager.conf
rm -rf /etc/resolv.conf
rm -rf /etc/dnscrypt-proxy/dnscrypt-proxy.toml
echo -e '[device]\nwifi.scan-rand-mac-address=yes\nethernet.cloned-mac-address=random\nwifi.cloned-mac-address=stable' > /etc/NetworkManager/NetworkManager.conf

echo 'Restarting SystemD-Resolved ...'
systemctl enable --now systemd-resolved -f

echo -e 'Restarting NetworkManager ...'
systemctl restart --now NetworkManager -f

echo -e '\nAnonymized DNSCrypt-Proxy-Linux Successfully Deconfigured\nLet Snoopers Show You Their Middle Fingers\nPlease Reboot Your System To Take Effect !\n'
