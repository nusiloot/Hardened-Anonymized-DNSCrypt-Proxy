#!/bin/bash

echo
echo -e '+=============================================================+'
echo -e '+               Anonymized-DNSCrypt-Proxy-Linux               +'
echo -e '+      Automatically Configure Anonymized-DNSCrypt-Proxy      +'
echo -e '+                   Coder : BL4CKH47H4CK3R                    +'
echo -e '+=============================================================+'
echo

# Enable DNSCrypt-Proxy [Startup]
systemctl enable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f

# Applying DNSCrypt-Proxy configurations
rm -rf /etc/NetworkManager/NetworkManager.conf
rm -rf /etc/resolv.conf
rm -rf /etc/dnscrypt-proxy/dnscrypt-proxy.toml
echo -e '[device]\nwifi.scan-rand-mac-address=yes\nethernet.cloned-mac-address=random\nwifi.cloned-mac-address=stable\n\n[main]\ndns=none' >/etc/NetworkManager/NetworkManager.conf
echo -e 'nameserver 127.0.0.1\noptions edns0' > /etc/resolv.conf
cp dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
echo -e 'Set DNS Resolver ---> 127.0.0.1 [Permanently] [There Is No Place Like 127.0.0.1]\n'

# Configure DNSCrypt-Proxy
systemctl stop systemd-resolved -f
systemctl disable systemd-resolved -f
systemctl start dnscrypt-proxy.socket dnscrypt-proxy.service -f
dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -service restart
dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -check

# Restart NetworkManager
systemctl restart NetworkManager -f

# Apply iptables ruleset
iptables -t nat -A OUTPUT -p tcp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination 127.0.0.1:5354
iptables -t nat -A OUTPUT -p udp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination 127.0.0.1:5354
ip6tables -A OUTPUT -p tcp -j DROP
ip6tables -A OUTPUT -p udp -j DROP

# Termination Message
echo -e '\nAnonymized DNSCrypt-Proxy Successfully Configured !\nEnjoy Anonymity & Show Middle Fingers ---> Snoopers/Spoofers !\n'
