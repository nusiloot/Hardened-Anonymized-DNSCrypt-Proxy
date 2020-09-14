#!/bin/bash

echo
echo -e '+=============================================================+'
echo -e '+               Anonymized-DNSCrypt-Proxy-Linux               +'
echo -e '+      Automatically Configure Anonymized-DNSCrypt-Proxy      +'
echo -e '+                   Coder : BL4CKH47H4CK3R                    +'
echo -e '+=============================================================+'
echo

# Enabling DNSCrypt-Proxy [Startup]
echo -e 'Enabling DNSCrypt-Proxy On System Boot . . .'
systemctl enable --now dnscrypt-proxy.socket dnscrypt-proxy.service -f

# Applying DNSCrypt-Proxy configurations
rm -rf /etc/NetworkManager/NetworkManager.conf
rm -rf /etc/resolv.conf
rm -rf /etc/dnscrypt-proxy/dnscrypt-proxy.toml
echo -e '[device]\nwifi.scan-rand-mac-address=yes\nethernet.cloned-mac-address=random\nwifi.cloned-mac-address=stable\n\n[main]\ndns=none' >/etc/NetworkManager/NetworkManager.conf
echo -e 'nameserver ::1\nnameserver 127.0.0.1\noptions edns0 single-request-reopen' > /etc/resolv.conf
cp dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
echo -e 'Setting DNS Resolver ---> 127.0.0.1 [Permanently] [There Is No Place Like 127.0.0.1]\n'

# Configuring DNSCrypt-Proxy
systemctl stop --now systemd-resolved -f
systemctl disable --now systemd-resolved -f
systemctl start --now dnscrypt-proxy.socket dnscrypt-proxy.service -f

# Restart & Check DNSCrypt-Proxy
echo -e 'Checking DNSCrypt-Proxy Service Status . . .'
dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -service restart
dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -check

# Applying IPTables/Firewall Ruleset
echo -e '\nApplying IPTables/Firewall Ruleset . . .'
iptables -t nat -A OUTPUT -p tcp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination 127.0.0.1:5354
iptables -t nat -A OUTPUT -p udp ! -d 91.239.100.100 --dport 53 -j DNAT --to-destination 127.0.0.1:5354
ip6tables -A OUTPUT -p tcp -j DROP
ip6tables -A OUTPUT -p udp -j DROP

# Restarting NetworkManager
echo -e 'Restarting NetworkManager . . .'
systemctl restart --now NetworkManager -f

# Termination Message
echo -e '\nAnonymized DNSCrypt-Proxy-Linux Successfully Configured !\nEnjoy Anonymity & Show Your Middle Fingers ---> Snoopers !\n'
