#!/bin/bash

echo "Usage: ./start_transproxy.sh -a localaddress -g gateway -i interface";

for i in "$@"
do
case $i in
    -a=*|--address=*)
    EXTENSION="${i#*=}"
    shift # past argument=value
    ;;
    -g=*|--gateway=*)
    SEARCHPATH="${i#*=}"
    shift # past argument=value
    ;;
    -i=*|--interface=*)
    LIBPATH="${i#*=}"
    shift # past argument=value
    ;;
    *)
            # unknown option
    ;;
esac
done
# Networking nonsense
ifconfig ${INTERFACE} ${ADDRESS} netmask 255.255.255.0
echo "nameserver 8.8.8.8" > /etc/resolv.conf
route add default gw ${GATEWAY}
iptables -F
iptables -X
iptables --table nat --flush
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A PREROUTING -p tcp --dport  80 -j REDIRECT --to-ports 8080

# OK now we are ready to start the proxy here
