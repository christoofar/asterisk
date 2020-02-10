#!/bin/bash
SIPPASSWORD=$(uuidgen)
IPADDRESS=$(hostname --ip-address)
[ "$(ls -A /etc/asterisk)" ] && echo "etc folder has files, not doing anything" || {
	tar -xvzf /root/configs.tar.gz -C /etc/asterisk;
	sed -i "s/changme/$SIPPASSWORD/g" /etc/asterisk/sip.conf;
	sed -i "s/IPADDRESS/$IPADDRESS/g" /etc/asterisk/sip.conf;
	sed -i "s/TEST123/$SIPPASSWORD/g" /etc/asterisk/iax.conf;
	echo;
	echo Asterisk is setup with a default configuration;
	echo To help you with connectivity tests we have created an;
	echo IAX extension for you to test with: ;
	echo -------------------------;
	echo Protocol: IAX;
	echo 
	echo Extension: TESTUSER;
	echo Password:  $SIPPASSWORD;
	echo Port: 4569 udp;
	echo -------------------------;
	echo Asterisk is running on internal IP $(hostname --ip-address);
	echo Docker Hostname: $(hostname);
	echo -------------------------;
	echo To work on Asterisk config on your host, there are two mounts: ;
	echo /etc/asterisk and /var/lib/asterisk;
	echo;
}
cd /root
/usr/sbin/asterisk -cvvvvv
