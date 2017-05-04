class { 'ffnord::params':
  router_id => "10.116.$$$.$$$",  # The id of this router, probably the ipv4 address
                                  # of the mesh device of the providing community
  icvpn_as => "65525",# The as of the providing community
  wan_devices => ['eth0'],        # An array of devices which should be in the wan zone

  wmem_default => 87380,          # Define the default socket send buffer
  wmem_max     => 12582912,       # Define the maximum socket send buffer
  rmem_default => 87380,          # Define the default socket recv buffer
  rmem_max     => 12582912,       # Define the maximum socket recv buffer
  
  gw_control_ips => "217.70.197.1 89.27.152.1 138.201.16.163 8.8.8.8", # Define target to ping against for function check

  max_backlog  => 5000,           # Define the maximum packages in buffer
  include_bird4 => false,
  #maintenance => 1,
  #debian_mirror => "http://repo.myloc.de/mirrors/ftp.de.debian.org/debian/";
  
  batman_version => 14,            # B.A.T.M.A.N. adv version
}

# You can repeat this mesh block for every community you support
ffnord::mesh { 'mesh_ffki':
    mesh_name => "Freifunk Kiel"
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
  , dhcp_ranges => ['10.116.$$$.2 10.116.$$$.254']
  , dns_servers => ['10.116.$$$.$$$']               # should be the same as $router_id
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

#class { 'ffnord::alfred':
#  master => false
#}

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
