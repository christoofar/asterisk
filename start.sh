#!/bin/bash
SIPPASSWORD=$(uuidgen)
IPADDRESS=$(hostname --ip-address)
[ "$(ls -A /etc/asterisk)" ] && echo "etc folder has files, not doing anything" || {
	tar -xvzf /root/configs.tar.gz -C /etc/asterisk;
	sed -i "s/changme/$SIPPASSWORD/g" /etc/asterisk/sip.conf
	sed -i "s/IPADDRESS/$IPADDRESS/g" /etc/asterisk/sip.conf
	echo;
	echo Asterisk setup with a default configuration;
	echo To help you with connectivity tests we have set up the following;
	echo inbound config: ;
	echo -------------------------;
	echo Protocol: SIP;
	echo 
	echo Extension: testuser;
	echo Password:  $SIPPASSWORD;
	echo Port: 5060 tcp or udp;
	echo -------------------------;
	echo Asterisk is running on $(hostname --ip-address);
	echo Hostname: $(hostname);
	echo -------------------------;
	echo To work on Asterisk config on your host, there are two mounts: ;
	echo /etc/asterisk and /var/lib/asterisk;
	echo;
}
cd /root
/usr/sbin/asterisk -f
