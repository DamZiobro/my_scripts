#!/usr/bin/python

# module for getting the lan ip address of the computer

import os
from time import sleep
import socket
import commands

if os.name != "nt":

    import fcntl

    import struct

    def get_interface_ip(ifname):

    	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    	return socket.inet_ntoa(fcntl.ioctl(

    			s.fileno(),

    			0x8915,  # SIOCGIFADDR

    			struct.pack('256s', ifname[:15])

    		)[20:24])



def get_lan_ip():

    ip = socket.gethostbyname(socket.gethostname())

    if os.name != "nt":

    	interfaces = ["eth0"]

    	for ifname in interfaces:

    		try:

    			ip = get_interface_ip(ifname)
			if(ip.startswith("192.168")):
				return ip

    			break;

    		except IOError:

    			pass

    return ip

while(True):
	ip = get_lan_ip()
	if(not ip.startswith("192.168")):
		print "Assigning IP address..."
		os.system("sudo ifconfig eth0 192.168.1.15 netmask 255.255.255.0 up");
	else:
		print "IP: " + ip
	sleep(3);


