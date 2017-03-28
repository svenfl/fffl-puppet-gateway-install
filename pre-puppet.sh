#!/bin/bash
#https://github.com/ffnord/ffnord-puppet-gateway

NAME="Freifunk Kiel"
OPERATOR="Max"
CHANGELOG="http://issues.freifunk.in-kiel.de/"
HOST_PREFIX="vpn"
MESH_CODE="ffki"
SUBDOMAIN_PREFIX=vpn
VPN_NUMBER=6
DOMAIN="freifunk.in-kiel.de"
SUDOUSERNAME="rubo77"

#backborts einbauen
echo "deb http://http.debian.net/debian wheezy-backports main" >>/etc/apt/sources.list

#sysupgrade
apt-get update && apt-get upgrade && apt-get dist-upgrade

#add users:
useradd -U -G sudo -m $SUDOUSERNAME

#MOTD setzen
rm /etc/motd
echo "*********************************************************" >>/etc/motd
echo " $NAME - Gateway $SUBDOMAIN_PREFIX$VPN_NUMBER $NAME " >>/etc/motd
echo " Hoster: $OPERATOR *" >>/etc/motd
echo "*******************************************************" >>/etc/motd
echo " " >>/etc/motd
echo " Changelog: " >>/etc/motd
echo " $CHANGELOG " >>/etc/motd
echo " *" >>/etc/motd
echo " Happy Hacking! *" >>/etc/motd
echo "**********************************************************" >>/etc/motd

#Hostname setzen
hostname $HOST_PREFIX$VPN_NUMBER
echo "127.0.1.1 $SUBDOMAIN_PREFIX$VPN_NUMBER.$DOMAIN $HOST_PREFIX$VPN_NUMBER" >>/etc/hosts
mv /etc/hostname /var/tmp/hostname-bak
echo "$HOST_PREFIX$VPN_NUMBER" >>/etc/hostname
#benötigte Pakete installieren
apt-get -y install sudo apt-transport-https bash-completion haveged git tcpdump mtr-tiny vim nano unp mlocate screen tmux cmake build-essential libcap-dev pkg-config libgps-dev python3 ethtool lsb-release zip locales-all

#REBOOT on Kernel Panic
echo "kernel.panic = 10" >>/etc/sysctl.conf

#puppet modules install
apt-get -y install --no-install-recommends puppet
puppet module install puppetlabs-stdlib --version 4.15.0 && \
puppet module install puppetlabs-apt --version 1.5.1 && \
puppet module install puppetlabs-vcsrepo --version 1.3.2 && \
puppet module install saz-sudo --version 4.1.0 && \
puppet module install torrancew-account --version 0.1.0
cd /etc/puppet/modules
git clone https://github.com/ffnord/ffnord-puppet-gateway ffnord

#check-services script install
cd /usr/local/bin
wget --no-check-certificate https://raw.githubusercontent.com/Tarnatos/check-service/master/check-services
chmod +x check-services
chown root:root check-services
sed -i s/=ffnord/=$MESH_CODE/g /usr/local/bin/check-services
sed -i s/=nord-gw/=$MESH_CODE-$HOST_PREFIX/g /usr/local/bin/check-services

#zurück zu root
cd /root
git clone https://github.com/Freifunk-Nord/nord-watchdog
chmod +x /root/nord-watchdog/usr/local/bin/vpn-watchdog
#add this in crontab:
cat > /etc/cron.d/vpn-watchdog <<EOF
# VPN Watchdog that checks if openvpn is still running correctly
*/5 * * * * root /root/nord-watchdog/usr/local/bin/vpn-watchdog
EOF

#USER TODO:
#manifest.pp, $keys, mesh_peerings.yaml nach root legen


# add aliases
cat <<-EOF>> /root/.bashrc
  export LS_OPTIONS='--color=auto'
  eval" \`dircolors\`"
  alias ls='ls \$LS_OPTIONS'
  alias ll='ls \$LS_OPTIONS -lah'
  alias l='ls \$LS_OPTIONS -lA'
  alias grep="grep --color=auto"
  alias ..="cd .."
EOF


# back in /root
cd /root

#USER TODO:
echo 'now copy the files manifest.pp and mesh_peerings.yaml to /root and make sure /root/fastd_secret.key exists'
echo '####################################################################################'
echo '########### don´t run the following scripts without screen sesssion!!! #############'
echo '####################################################################################'
cd -
cat $(dirname $0 )/README.md
