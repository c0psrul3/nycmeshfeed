#!/bin/sh

#rev 0

mkdir -p /etc/tinc/nycmesh/hosts

#tinc conf
mac=$(ip link show eth0 | awk '/ether/ {print $2}' | sed s/://g)

cat >/etc/tinc/nycmesh/tinc.conf << EOL
Name = $mac
AddressFamily = any
Interface = tap0
Mode = switch
ConnectTo = tunnelnycmesh
EOL

#generate key
tincd -K2048 -n nycmesh </dev/null

#tinc tinc-up script
cat <<"TAGTEXTFILE" > /etc/tinc/nycmesh/tinc-up
#/bin/sh
ip link set dev $INTERFACE up
ip link set mtu 1350 dev $INTERFACE
iptables -A FORWARD -p tcp -o $INTERFACE -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
bmx6 -c -i $INTERFACE
TAGTEXTFILE
chmod +x /etc/tinc/nycmesh/tinc-up

sed -i -e '$i \tincd -n nycmesh' /etc/rc.local

echo "/etc/tinc" >> /etc/sysupgrade.conf
