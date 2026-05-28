#!/bin/sh

ip=$(sh ~/git/qwegjx/ipaddr/get_ip.sh decode 2>/dev/null | grep 'inet6 .*/128.*dynamic' | grep -E '\w+:.+:\w+' -o)

sed "s/remote .*/remote $ip 1194 udp6/" ~/deck.ovpn -i

