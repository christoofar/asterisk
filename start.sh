#!/bin/bash
IAXPASSWORD=$(uuidgen)
IPADDRESS=$(hostname --ip-address)
[ "$(ls -A /etc/asterisk)" ] && echo "etc folder has files, not doing anything" || {
	tar -xvzf /root/configs.tar.gz -C /etc/asterisk;
	sed -i "s/changme/$IAXPASSWORD/g" /etc/asterisk/iax.conf
	sed -i "s/MYIPADDRESS/$IPADDRESS/g" /etc/asterisk/iax.conf
	echo;
	echo Asterisk setup with a default configuration;
	echo To help you with connectivity tests we have set up the following;
	echo inbound config: ;
	echo -------------------------;
	echo Protocol: IAX2;
	echo 
	echo Extension: 1234;
	echo Password:  $IAXPASSWORD;
	echo Port: 4569;
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
