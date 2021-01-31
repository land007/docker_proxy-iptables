#!/bin/bash
export IFS=";"
iptables -F
iptables -X
iptables -Z
iptables -L
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
#开启SSH 22端口
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 8888 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 8888 -j ACCEPT
#允许ping
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
#开启对指定网站的访问
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp -d 172.17.0.1/24 -j ACCEPT
#iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp -d ${LANIP}/24 -j ACCEPT
for I_LANIP in ${LANIP}; do
  echo "iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp -d ${I_LANIP}/24 -j ACCEPT"
  iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp -d ${I_LANIP}/24 -j ACCEPT
done
#允许环回
iptables -A INPUT -i lo -p all -j ACCEPT
iptables -A OUTPUT -o lo -p all -j ACCEPT

