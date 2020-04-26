modprobe af_key
docker run \
    --name ipsec-vpn-server \
    -e VPN_USER=k2 \
    -e VPN_IPSEC_PSK=woyaovpn \
    -e VPN_PASSWORD=K2data1234 \
    --restart=always \
    -p 500:500/udp \
    -p 4500:4500/udp \
		-p 1701:1701/udp \
    -v /lib/modules:/lib/modules:ro \
    -d --privileged \
    hwdsl2/ipsec-vpn-server
		
#  Add-VpnConnection -Name 'My IPsec VPN' -ServerAddress '1.2.2.3' -L2tpPsk 'woyaovpn' -TunnelType L2tp -EncryptionLevel Required -AuthenticationMethod Chap,MSChapv2 -Force -RememberCredential -PassThru