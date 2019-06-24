#!/usr/bin/env bash
sudo echo "        ens4:
            dhcp4: true
            match:
                macaddress: fa:16:3e:48:06:20
            set-name: ens4" >> /etc/netplan/50-cloud-init.yaml
