#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway

VPN_NUMBER=0
DOMAIN="freifunk-flensburg.de"
TLD=fffl
IP6PREFIX=fddf:bf7:10:1

#NGINX, if needed to serve the firmware for the auto-updater
#apt-get install -y nginx

#mkdir /opt/www
#sed s~"usr/share/nginx/www;"~"opt/www;"~g -i /etc/nginx/sites-enabled/default

#DNS Server
# Dies Knallte bei OVH:
# sed -i .bak "/eth0 inet static/a \  dns-search vpn$VPN_NUMBER.$DOMAIN" /etc/network/interfaces

#rm /etc/resolv.conf
#cat >> /etc/resolv.conf <<-EOF
#  domain $TLD
#  search $TLD
#  nameserver 127.0.0.1
#  nameserver 62.141.32.5
#  nameserver 62.141.32.4
#  nameserver 62.141.32.3
#  nameserver 8.8.8.8
#EOF

# check if everything is running:
service fastd restart
service isc-dhcp-server restart
check-services
