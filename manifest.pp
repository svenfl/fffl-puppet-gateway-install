class { 'ffnord::params':
  router_id => "10.116.184.1",
  icvpn_as => "65525",
  wan_devices => ['eth0'],
  include_bird4 => false,
  #maintenance => 1,
# debian_mirror => "http://mirror.in-kiel.de/debian/";
}

# You can repeat this mesh block for every community you support
ffnord::mesh { 'mesh_ffki':
      , mesh_name => "Freifunk Kiel"
      , mesh_code => "ffki"
      , mesh_as => "65525"
      , mesh_mac  => "de:ad:be:ef:ff:06"
      , vpn_mac   => "de:ad:be:ff:ff:06"
      , mesh_ipv6 => "fda1:384a:74de:4242::ff06/64"
      , mesh_ipv4  => "10.116.184.1/17"
      , range_ipv4 => "10.116.0.0/16"
      , mesh_mtu     => "1280"
      , mesh_peerings    => "/root/mesh_peerings.yaml"

      , fastd_secret => "/root/fastd_secret.key"
      , fastd_port   => 11235
      , fastd_peers_git => 'git://git.freifunk.in-kiel.de/fastd-peer-keys.git'

      , dhcp_ranges => ['10.116.184.12 10.116.184.244'
                       ,'10.116.185.11 10.116.185.244'
                       ,'10.116.186.11 10.116.186.244'
                       ,'10.116.187.11 10.116.187.244'
                       ,'10.116.188.11 10.116.188.244'
                       ,'10.116.189.11 10.116.189.244'
                       ,'10.116.190.11 10.116.190.244'
                       ,'10.116.191.11 10.116.191.244']
      , dns_servers => ['10.116.136.1'
                       ,'10.116.144.1'
                       ,'10.116.152.1'
                       ,'10.116.160.1']
      }

class {
  'ffnord::vpn::provider::hideio':
  openvpn_server => "frankfurt.hide.me",
  openvpn_port   => 3478,
  openvpn_user   => "xxxxxxxxxx",
  openvpn_password => "xxxxxxxxx";
}

ffnord::named::zone {
  "ffki": zone_git => "git://git.freifunk.in-kiel.de/ffki-zone.git", exclude_meta => 'kiel';
}

class { 'ffnord::alfred':
  master => false
}

#ffnord::bird6::icvpn { 'kiel0':
#  icvpn_as           => 65525,
#  icvpn_ipv4_address => "10.207.0.52",
#  icvpn_ipv6_address => "fec0::a:cf:0:34",
#  icvpn_exclude_peerings => [kiel],
#  tinc_keyfile       => "/root/ffki-vpn0-icvpn-rsa_key.priv"
#}

#class {
#  'ffnord::monitor::nrpe':
#     allowed_hosts => "138.201.16.163";
#}

class {
  'ffnord::rsyslog':
}

class {
  'ffnord::etckeeper':
}

# Useful packages
package {
  ['vim','tcpdump','dnsutils','realpath','screen','htop','mlocate','tig','tmux',]:
     ensure => installed;
}
