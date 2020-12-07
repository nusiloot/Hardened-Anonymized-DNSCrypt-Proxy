<h1 align=center>Anonymized-DNSCrypt-Proxy-Linux</h1>
<p align=center>Hardened Anonymized-DNSCrypt-Proxy For Linux</p>

- #### Why This Project ?
> There Are Automated DNSCrypt-Proxy Client For Both [Windows](https://github.com/bitbeans/SimpleDnsCrypt) & [Android (Magisk Module)](https://git.nixnet.xyz/quindecim/dnscrypt-proxy-android) <br/>
> But For Linux, People Find It Hard To Configure DNSCrypt-Proxy Manually. But I Wanted To Keep It Simple, So It's Here !

- #### Supported Linux Distributions

> - `Alpine`
> - `Arch Based Linux`
> - `Debian Based Linux`
> - `Fedora`
> - `Gentoo`
> - `Mageia`
> - `OpenSUSE`
> - `Solus`
> - `Slackware 14.2`

- #### Differences from the main dnscrypt-proxy project

> - `server_names` = `acsacsar-ams-ipv4` [NLD], `arvind-io` [IND], `bcn-dnscrypt` [ESP], `d0wn-tz-ns1` [TZA], `dnscrypt.be` [BEL], `dnscrypt.ca-1` [CAN], `dnscrypt.ca-2` [CAN], `dnscrypt.eu-dk` [DNK], `dnscrypt.eu-nl` [NLD], `dnscrypt.one` [DEU], `dnscrypt.pl` [POL], `dnscrypt.uk-ipv4` [GBR], `ev-to` [CAN], `ev-va` [CAN], `faelix-ch-ipv4` [CHE], `faelix-uk-ipv4` [GBR], `ffmuc.net` [DEU], `jp.tiar.app` [JPN], `meganerd` [NLD], `plan9-dns` [USA], `publicarray-au` [AUS], `sarpel-dns-istanbul` [TUR], `scaleway-ams` [NLD], `scaleway-fr` [FRA], `serbica` [NLD], `skyfighter-dns` [NLD], `v.dnscrypt.uk-ipv4` [GBR], `ventricle.us` [USA] are the resolvers in use.

> - `doh_servers` = `false` (disable servers implementing the `DNS-over-HTTPS` protocol)

> - `require_dnssec` = `true` (server must support `DNSSEC` security extension)

> - `timeout` = `1000` (set the max. response time of a single DNS query from `5000` to `1000` ms.)

> - `blocked_query_response` = `'refused'` (set `refused` response to blocked queries)

> - `dnscrypt_ephemeral_keys` = `true` (create a new, unique key for every single DNS query)

> - `fallback_resolvers` = `['91.239.100.100:53']` (use [UncensoredDNS](https://blog.uncensoreddns.org/) instead [CloudFlare](https://iscloudflaresafeyet.com/))

> - `netprobe_address` = `'91.239.100.100:53'` (use [UncensoredDNS](https://blog.uncensoreddns.org/) instead [CloudFlare](https://iscloudflaresafeyet.com/))

> - `block_ipv6` = `true` (immediately respond to IPv6-related queries with an empty response)

> - `blocked_names_file`, `blocked_ips_file`, `allowed_names_file` and `allowed_ips_file` options enabled. (you can use the related files, created in `/sdcard/dnscrypt-proxy/`, or `/data/media/0/dnscrypt-proxy/` to filter the web content)

> - `anonymized_dns` feature enabled. (`routes` are indirect ways to reach DNSCrypt servers, each resolver has 2 relays assigned)

> - `skip_incompatible` = `true` (skip resolvers incompatible with anonymization instead of using them directly)

> - `direct_cert_fallback` = `false` (prevent direct connections through the resolvers for failed certificate retrieved via relay)

- #### Configure/Deconfigure [Copy-Paste]
```
git clone https://github.com/BL4CKH47H4CK3R/Anonymized-DNSCrypt-Proxy-Linux.git && cd Anonymized-DNSCrypt-Proxy-Linux && chmod +x run.sh && sudo ./run.sh
```

- #### DNS Leak Testing [Websites]
> - [BrowserLeaks](https://anon.to/?http://browserleaks.com/dns)
> - [IPLeak](https://anon.to/?http://ipleak.net)
> - [DNSLeakTest](https://anon.to/?https://www.dnsleaktest.com)

- #### All Credit Goes To -
> [Frank Denis](https://github.com/jedisct1)
> For His Awesome [Project](https://github.com/DNSCrypt/dnscrypt-proxy) !
