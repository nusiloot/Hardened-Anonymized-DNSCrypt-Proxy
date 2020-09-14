<h1 align=center>Anonymized-DNSCrypt-Proxy-Linux</h1>
<p align=center>Automatically Configure & Deconfigure Anonymized-DNSCrypt-Proxy</p>

- #### Why This Project ?
> There Are Automated DNSCrypt-Proxy Client For Both [Windows](https://github.com/bitbeans/SimpleDnsCrypt) & [Android](https://git.nixnet.xyz/quindecim/dnscrypt-proxy-android) <br/>
> But For Linux, People Find It Hard To Configure DNSCrypt-Proxy Manually. But I Wanted To Keep It Simple, So It's Here !

- #### Differences Between Default DNSCrypt-Proxy Project [dnscrypt-proxy.toml]

- ✅ `DNSSEC` required
- ✅ Enabled `dnscrypt_ephemeral_keys` feature (create a new, unique key for every single DNS query)
- ✅ Enabled `anonymized_dns` feature (each resolver has 2 relays)
- ✅ Enabled `skip_incompatible` option (ignore resolvers incompatible with Anonymized DNS instead of using them without a relay)
- ✅ Enabled `blocked-names.txt` and `allowed-names.txt` files (as placeholder, use them as you wish for filter your content)
- ⛔️ Disabled `DoH`
- ⛔️ Disabled `IPv6`
- ⛔️ Disabled `direct_cert_fallback` option (prevent direct connections through the resolvers for failed certificate retrieved via relay)
- ℹ️ Set`refused` response to blocked queries
- ℹ️ Set DNS query max. response time from `5000` to `1500`, in ms.
- ℹ️ Use [UncensoredDNS](https://blog.uncensoreddns.org/) as fallback resolver instead [CloudFlare](https://iscloudflaresafeyet.com/)
- ℹ️ Use `acsacsar-ams-ipv4` (NL), `dnscrypt.eu-dk` (DK), `dnscrypt.eu-nl` (NL), `dnscrypt.uk-ipv4` (UK), `meganerd` (NL), `publicarray-au` (AUS), `scaleway-ams` (NL), `scaleway-fr` (FR), `v.dnscrypt.uk-ipv4` (UK) and `yofiji-se-ipv4` (SE)

- #### Configure [Copy-Paste]
```
git clone https://github.com/BL4CKH47H4CK3R/Anonymized-DNSCrypt-Proxy-Linux.git && cd Anonymized-DNSCrypt-Proxy-Linux && chmod +x configure.sh && sudo ./configure.sh
```
- #### Deconfigure [Copy-Paste]
```
git clone https://github.com/BL4CKH47H4CK3R/Anonymized-DNSCrypt-Proxy-Linux.git && cd Anonymized-DNSCrypt-Proxy-Linux && chmod +x deconfigure.sh && sudo ./deconfigure.sh
```
- #### Original Credit Goes To [Frank Denis](https://github.com/jedisct1) For His Awesome [Project](https://github.com/DNSCrypt/dnscrypt-proxy) !
