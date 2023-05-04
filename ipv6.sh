#!/bin/sh
echo > /etc/sysctl.conf
##
tee -a /etc/sysctl.conf <<EOF
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.all.disable_ipv6 = 0
EOF
##
sysctl -p
IPC=$(curl -4 -s icanhazip.com | cut -d"." -f3)
IPD=$(curl -4 -s icanhazip.com | cut -d"." -f4)
##
if [ $IPC == 4 ]
then
   tee -a /etc/sysconfig/network-scripts/ifcfg-eth0 <<-EOF
	IPV6INIT=yes
	IPV6_AUTOCONF=no
	IPV6_DEFROUTE=yes
	IPV6_FAILURE_FATAL=no
	IPV6_ADDR_GEN_MODE=stable-privacy
	IPV6ADDR=2001:df7:c600:14:f816:40:$IPD:7f63/64
	IPV6_DEFAULTGW=2001:df7:c600:14::1
	EOF
elif [ $IPC == 5 ]
then
   tee -a /etc/sysconfig/network-scripts/ifcfg-eth0 <<-EOF
	IPV6INIT=yes
	IPV6_AUTOCONF=no
	IPV6_DEFROUTE=yes
	IPV6_FAILURE_FATAL=no
	IPV6_ADDR_GEN_MODE=stable-privacy
	IPV6ADDR=2001:df7:c600:14:f816:41:$IPD:7f63/64
	IPV6_DEFAULTGW=2001:df7:c600:15::1
	EOF
else
	tee -a /etc/sysconfig/network-scripts/ifcfg-eth0 <<-EOF
	IPV6INIT=yes
	IPV6_AUTOCONF=no
	IPV6_DEFROUTE=yes
	IPV6_FAILURE_FATAL=no
	IPV6_ADDR_GEN_MODE=stable-privacy
	IPV6ADDR=2001:df7:c600:14:f816:$IPD:$IPD:7f63/64
	IPV6_DEFAULTGW=2001:df7:c600:$IPC::1
	EOF
fi

service network restart

rm -rf ipv6.sh
