#!/bin/bash

usage() { echo "Usage: $0 -a [address of this host] -g [gateway for this host] -i [interface to modify]" 1>&2; exit 1; }

while getopts ":a:g:i:" o; do
    case "${o}" in
        g)
            GATEWAY=${OPTARG}
            ;;
        i)
            INTERFACE=${OPTARG}
            ;;
        a)
            ADDRESS=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

# Networking nonsense
ifconfig $INTERFACE $ADDRESS netmask 255.255.255.0
echo "nameserver 8.8.8.8" > /etc/resolv.conf
route add default gw $GATEWAY
iptables -F
iptables -X
iptables --table nat --flush
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A PREROUTING -p tcp --dport  80 -j REDIRECT --to-ports 8080

# OK now we are ready to start the proxy here
