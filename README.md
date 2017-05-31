# Install scripts for a Freifunk Kiel Gateway


### 1. copy this file to the root home folder:

    cp mesh_peerings.yaml /root/

### 2. create the file with the fastd private key

    echo 'secret "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";' > /root/fastd_secret.key

### 3. copy this file to the root home folder:

    cp manifest.pp /root/gateway.pp
and adapt all needed settings to the new gateway

#### 4. start the pre, puppet and post script

    ./pre-puppet.sh

follow instructions at the end of the script. **make sure you are in a screen session**

    screen
    puppet apply --verbose /root/gateway.pp
    # start puppet again in case something went wrong:
    puppet apply --verbose /root/gateway.pp
    build-firewall
    bash post-puppet.sh

#### local exit without VPN

    We do the following steps for ivp4 only, ipv6 is not forwarded locally.
    First is the runtime change and after that instructions to change the startup
    configuration.

    Enable maintenance mode,

    > maintenance on
    
    after DHCPLEASETIME read and execute the script `localexit.sh`

#### 5. weitere sudo user anlegen

    adduser newuser
    adduser newuser sudo
