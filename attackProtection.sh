#! /bin/bash
#
# attackProtection.sh
# Script sets up iptables in order to prevent UPD flooing and SYN packet flooding


# #########################
# Outbound UDP Flood protection in a user defined chain.
iptables -N udp-flood
iptables -A OUTPUT -p udp -j udp-flood
iptables -A udp-flood -p udp -m limit --limit 200/s -j RETURN
iptables -A udp-flood -j LOG --log-level 4 --log-prefix 'UDP-flood attempt: '
iptables -A udp-flood -j DROP
#  
# #########################
# SYN-Flood protection in a user defined chain
iptables -N syn-flood
iptables -A INPUT -p tcp --syn -j syn-flood
iptables -A syn-flood -m limit --limit 30/s --limit-burst 60 -j RETURN
iptables -A syn-flood -j LOG --log-level 4 --log-prefix 'SYN-flood attempt: '
iptables -A syn-flood -j DROP

