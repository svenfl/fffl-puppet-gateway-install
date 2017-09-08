class { 'ffnord::params':
  router_id => "10.129.$$$.$$$",  # The id of this router, probably the ipv4 address
                                  # of the mesh device of the providing community
  icvpn_as => "65526",            # The as of the providing community
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
  
  batman_version => 15,            # B.A.T.M.A.N. adv version
}

# You can repeat this mesh block for every community you support
ffnord::mesh { 'mesh_fffl':
    mesh_name => "Freifunk Flensburg"
  , mesh_code => "fffl"
  , mesh_as => "65525"
  , mesh_mac  => "de:ad:be:ef:ff:0$"
  , vpn_mac   => "de:ad:be:ff:ff:0$"
  , mesh_ipv6 => "fddf:bf7:10:1::ff0$/64"
  , mesh_ipv4  => "10.129.5.1/17" # 10.129.0.1 localnode, 1.x: alle alten gateways, 2.x: feste IPS, 3.x: hackerspace, ab 5.x: ip-range des ersten gw
  , range_ipv4 => "10.129.0.0/16"
  , mesh_mtu     => "1312"
  , mesh_peerings    => "/root/mesh_peerings.yaml"
  
  , fastd_secret => "/root/fastd_secret.key"
  , fastd_port   => 11235
  , fastd_peers_git => 'https://github.com/freifunk-flensburg/fffl-fastd-peers'
  , fastd_verify=> 'true'                               # set this to 'true' to accept all fastd keys without verification
  
  , dhcp_ranges => ['10.129.$$$.2 10.129.$$$.254']
  , dns_servers => ['10.129.$$$.$$$']               # should be the same as $router_id
}

class {
  'ffnord::vpn::provider::hideio':
  openvpn_server => "frankfurt.hide.me",
  openvpn_port   => 3478,
  openvpn_user   => "xxxxxxxxxx",
  openvpn_password => "xxxxxxxxx";
}

ffnord::named::zone {
  "fffl": zone_git => "https://github.com/freifunk-flensburg/dns_fffl", exclude_meta => 'flensburg';
}

#class { 'ffnord::alfred':
#  master => false
#}

#ffnord::bird6::icvpn { 'flensburg0':
#  icvpn_as           => 65525,
#  icvpn_ipv4_address => "10.207.0.52",
#  icvpn_ipv6_address => "fec0::a:cf:0:34",
#  icvpn_exclude_peerings => [flensburg],
#  tinc_keyfile       => "/root/fffl-vpn0-icvpn-rsa_key.priv"
#}

#class {
#  'ffnord::monitor::nrpe':
#     allowed_hosts => "138.201.16.163";
#}

class {
  ['ffnord::etckeeper','ffnord::rsyslog','ffnord::mosh']:
}

# Useful packages
package {
  ['vim','tcpdump','dnsutils','realpath','screen','htop','mlocate','tig','unattended-upgrades','tmux','sshguard']:
     ensure => installed;
}
