#!/bin/bash
export IFS=";"
iptables -F
iptables -X
iptables -Z
iptables -L
#关闭所有端口
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
#只允许特定ip访问
if [ "${INIP}" = "" ]
then
  echo "INIP is not set"
  iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
  iptables -A OUTPUT -p tcp --sport 8080 -j ACCEPT
  iptables -A INPUT -p tcp --dport 8888 -j ACCEPT
  iptables -A OUTPUT -p tcp --sport 8888 -j ACCEPT
else
  echo "INIP is set"
  #iptables -I INPUT -p tcp --dport 8080 -j DROP
  #iptables -I INPUT -p TCP --dport 8888 -j DROP
  for I_INIP in ${INIP}; do
    echo "iptables -I INPUT -s ${I_INIP} -p tcp --dport 8080 -j ACCEPT"
    iptables -A INPUT -s ${I_INIP} -p tcp --dport 8080 -j ACCEPT
    iptables -A OUTPUT -d ${I_INIP} -p tcp --sport 8080 -j ACCEPT
    echo "iptables -I INPUT -s ${I_INIP} -p tcp --dport 8888 -j ACCEPT"
    iptables -A INPUT -s ${I_INIP} -p tcp --dport 8888 -j ACCEPT
    iptables -A OUTPUT -d ${I_INIP} -p tcp --sport 8888 -j ACCEPT
  done
fi
#允许ping
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
#开启对指定网站的访问
if [ "${LANIP}" = "" ]
then
  echo "LANIP is not set"
else
  echo "LANIP is set"
  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  #iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp -d 172.17.0.1/24 -j ACCEPT
  #iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp -d ${LANIP}/24 -j ACCEPT
  for I_LANIP in ${LANIP}; do
    echo "iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp -d ${I_LANIP} -j ACCEPT"
    iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -p tcp -d ${I_LANIP} -j ACCEPT
  done
fi
#允许环回
iptables -A INPUT -i lo -p all -j ACCEPT
iptables -A OUTPUT -o lo -p all -j ACCEPT
#输出
iptables -nv -L
