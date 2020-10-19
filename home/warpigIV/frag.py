#!/usr/bin/env python

from scapy.all import *
import sys
import subprocess

# Send fragmented packet timeout alerts to Eric's host
dst_ip="109.0.9.30"

# Access point IP address -
# AP - lou2-guest
# ? (192.168.33.1) at c8:b3:73:26:69:79 [ether] on wlan0
ap_ip_addr="192.168.33.1"

data="Fragments from OPEN AP"

i=0
fake_ttl=2

# ORIGINAL (linode tests) -
#  src_prt=14989
#  dst_prt=80

# Eric Test -
src_prt=80
dst_prt=14989

#D=256
D=20
while D > 0:

    D = D - 1
    i = i + 1
    newdata = "Packet:" + str(i) + " TTL:" + str(fake_ttl) + " D:" + str(D) + " " + data
    packet_a = IP(src=dst_ip, dst=ap_ip_addr, ttl=fake_ttl, flags='MF', frag=i, id=D)/TCP(dport=dst_prt, sport=src_prt)/newdata
    packet_b = IP(src=dst_ip, dst=ap_ip_addr, ttl=fake_ttl, flags='MF', frag=i, id=D)/TCP(dport=src_prt, sport=dst_prt)/newdata
    print("Sending this: ")
    packet_a.show()
    send(packet_a) 
    print("Sending this: ")
    packet_b.show()
    send(packet_b) 

quit()


