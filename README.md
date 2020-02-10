# Asterisk PBX for Docker

This is a working STABLE and usable Asterisk PBX Server, in Docker, using Debian-lite.

We can't use Alpine due to changes in Asterisk since 14 that make it unhappy with the glibc that's in that distro.  So instead we use debian-slim, compile from scratch, then wipe off (most) unnecessary kits.   The full image is less than 200MB, which isn't really a burden on the smallest of cloud instances.

As of right now the LTS is 16.8.0.

Standard codecs and options are setup and installed on this image.   It's highly recommended you provide your own ``/etc/asterisk`` folder as a mount to a running container.  If you don't provide one, you're going to get a standard configuration that has no SIP extensions configured, but it does have a pre-configured PBX trunk set up that can dial USA/Canada toll-free numbers.

Also consider mounting ``/var/lib/asterisk/sounds`` if you are going to be adding to the default EN-US sound packs that are installed, and also a mount point for SSL certificates if you plan on configuring TCP/TLS, ARI, and other services that use encrypted sockets.

# What can I do with this image?

The base SIP and IAX channel drivers are configured and turned on.  There is also a default outbound trunk setup to place calls to USA/CAN toll-free numbers; so if you successfully attach a VOIP client to this instance you should be able to place outbound telephone calls over the PSTN network with minimal fuss.

When you start this container interactively you will be given a login/password to a default IAX2 extension that you can use Zoiper or another IAX client to connect and place calls to the PSTN.

This Docker image is also available for ARM64,ARMv6,ARMv7 so you can quickly load a working Asterisk instance to any number of edge-type devices, including the Raspberry PI.

# How do I configure this thing?

Mount ``/etc/asterisk`` inside the container to point to a folder on your host.   You can use the sample configuration files here in this repo as a starting template or roll your own.  Most people start by editing ``sip.conf`` and creating a SIP extension and then connecting a SIP client like XLite to the server instance.   From there they start writing dialplan programs in ``extensions.conf``, and so on.

# Does this image have FreePBX in it?

No.  There's probably a few FreePBX docker images out there with a companion Asterisk instance available; but FreePBX is actually a hinderance to advanced telephony developers.   Maybe it might sense to make a new Docker image based on this one with FreePBX on it.

# Running in Docker (no need to build this image)

A barebones server can be started this way by grabbing the latest image straight from Docker Hub (the first time you run this, do not use the -d option):

``docker run -p 5060:5060/udp -p 4569:4569/udp --name asterisk christoofar/asterisk``

You probably also want to setup your Asterisk instance rather than using the basic config that's inside the container.   For that, create a local mount from ``~\asteriskconfig`` (or wherever you want) to the ``/etc/asterisk`` volume like this:

``docker run -p 5060:5060/udp -p 4569:4569/udp -v ~/asteriskconfig:/etc/asterisk --name asterisk christoofar/asterisk``

Obviously if you're going to base your own config, it makes sense to setup your own Docker image and then add a COPY step in your Dockerfile to port in whatever config files you need into ``/etc/asterisk`` and sound files and certificates into ``/var/lib/asterisk/*``

# Connecting to Asterisk CLI

```
docker exec -it asterisk /bin/bash
asterisk -rvvvvv
```

# Asterisk configs

Two mounts are available at ``/etc/asterisk`` and ``/var/lib/asterisk`` inside the machine.  Once you start the container you can mount these volumes somewhere on your host to edit the asterisk configs.

You can have the configurations take effect with ``docker stop`` and ``docker start``, or you can issue ``core restart now`` inside the Asterisk CLI.

# Testing Asterisk

If you start Asterisk with the ``-d`` option to run it in the background, you can get the password to the test IAX extension with ``docker exec`` and then looking at the contents of ``/etc/asterisk/iax.conf``.   If you have the asterisk configuration folder mounted, you can look for the iax.conf file there.

![console output](https://github.com/christoofar/asterisk/blob/master/images/startup.png?raw=true)

Using Zoiper you can connect starting with entering your username as ``TESTUSER`` and use the password that is showing up in the container console when you first started up the container:

![enter credentials into zoiper](https://github.com/christoofar/asterisk/blob/master/images/zoiper1.png?raw=true)

Next, provide the public-facing IP address of the host.  In our case, we set this Docker image up on a Raspberry PI and that is its IP address.

![enter IP address of container host](https://github.com/christoofar/asterisk/blob/master/images/zoiper2.png?raw=true)

Zoiper will then attempt to connect to Asterisk.  The test extension is configured as an IAX2 extension and is listening on UDP port 4569.

![test connection](https://github.com/christoofar/asterisk/blob/master/images/zoiper3.png?raw=true)

Finally, you can test placing a toll-free call to ``1 (800) 444-4444`` which is a free test number.   The trunk that comes with the test configuration is capable of dialing any USA or Canadian toll-free number.

![dialing out](https://github.com/christoofar/asterisk/blob/master/images/zoiper4.png?raw=true)


# RTP ports and Docker

Docker cannot deal with a wide range of UDP ports being forwarded.  One way to get around this is to run the container on a machine that is not using 10000-20000 UDP and start the container with ``--network=host``.

You will need to talk to your admins about it since this gives the container full access to the host network and is considered insecure; even though this Docker image only has one running service beyond the ``debian-lite`` base image, Asterisk.

# Building the Service

If you prefer to build your own image locally and run it:

```
git clone https://github.com/christoofar/asterisk/
cd asterisk
docker build -t asterisk .
docker run -p 5060:5060/udp -p 4569:4569/udp -v ~/asteriskconfig:/etc/asterisk --name asterisk asterisk
```

Mount ``/etc/asterisk`` inside the container to point to a folder on your host.   You can use the sample configuration files here in this repo as a starting template or roll your own.  Most people start by editing ``sip.conf`` and creating a SIP extension and then connecting a SIP client like XLite to the server instance.   From there they start writing dialplan programs in ``extensions.conf``, and so on.
