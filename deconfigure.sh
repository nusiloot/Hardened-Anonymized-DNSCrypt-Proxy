#!/bin/bash

echo
echo -e '+=======================================================================+'
echo -e '+                     Anonymized-DNSCrypt-Proxy-Linux                   +'
echo -e '+      Automatically Configure/Deconfigure Anonymized-DNSCrypt-Proxy      +'
echo -e '+                          Coder : BL4CKH47H4CK3R                       +'
echo -e '+=======================================================================+'
echo

echo -e 'Hold Your Horses !\nReverting All Settings To Default State . . .'

# Disabling DNSCrypt-Proxy [Startup]
systemctl disable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f
systemctl stop --now dnscrypt-proxy.socket dnscrypt-proxy.service -f

# Reverting DNSCrypt-Proxy Configurations
rm -rf /etc/NetworkManager/NetworkManager.conf
rm -rf /etc/resolv.conf
rm -rf /etc/dnscrypt-proxy/dnscrypt-proxy.toml
echo -e '[device]\nwifi.scan-rand-mac-address=yes\nethernet.cloned-mac-address=random\nwifi.cloned-mac-address=stable' > /etc/NetworkManager/NetworkManager.conf

# Restarting SystemD-Resolved
systemctl enable --now systemd-resolved -f
systemctl restart --now systemd-resolved -f

# Restart NetworkManager
systemctl restart --now NetworkManager -f

# Termination Message
echo -e '\nAnonymized DNSCrypt-Proxy-Linux Successfully Deconfigured !\nLet Snoopers --> Show You Their Middle Fingers !\n'
