# Asterisk PBX for Docker

This is a working STABLE and usable Asterisk PBX Server, in Docker, using Debian-lite.

We can't use Alpine due to changes in Asterisk since 14 that make it unhappy with the glibc that's in that distro.  So instead we use debian-slim, compile from scratch, then wipe off (most) unnecessary kits.   The full image is less than 200MB, which isn't really a burden on the smallest of cloud instances.

As of right now the LTS is 16.8.0.

Standard codecs and options are setup and installed on this image.   It's highly recommended you provide your own ``/etc/asterisk`` folder as a mount to a running container.  If you don't provide one, you're going to get a standard configuration that has no SIP extensions configured, but it does have a pre-configured PBX trunk set up that can dial USA/Canada toll-free numbers.

Also consider mounting ``/var/lib/asterisk/sounds`` if you are going to be adding to the default EN-US sound packs that are installed, and also a mount point for SSL certificates if you plan on configuring TCP/TLS, ARI, and other services that use encrypted sockets.

# How do I configure this thing?

Mount ``/etc/asterisk`` inside the container to point to a folder on your host.   You can use the sample configuration files here in this repo as a starting template or roll your own.  Most people start by editing ``sip.conf`` and creating a SIP extension and then connecting a SIP client like XLite to the server instance.   From there they start writing dialplan programs in ``extensions.conf``, and so on.

# Does this image have FreePBX in it?

No.  There's probably a few FreePBX docker images out there with a companion Asterisk instance available; but FreePBX is actually a hinderance to advanced telephony developers.   Maybe it might sense to make a new Docker image based on this one with FreePBX on it.

# Running in Docker

A barebones server can be started this way:

``docker run -p 5060:5060/udp -p 4569:4569/udp --name asterisk christoofar/asterisk``

You probably also want to setup your Asterisk instance rather than using the basic config that's inside the container.   For that, create a local mount from ``~\asteriskconfig`` (or wherever you want) to the ``/etc/asterisk`` volume like this:

``docker run -p 5060:5060/udp -p 4569:4569/udp -v ~/asteriskconfig:/etc/asterisk --name asterisk christoofar/asterisk``

Obviously if you're going to base your own config, it makes sense to setup your own Docker image and then add a COPY step in your Dockerfile to port in whatever config files you need into ``/etc/asterisk`` and sound files and certificates into ``/var/lib/asterisk/*``

# Building the Service

If you prefer to build your own image locally and run it:

```
git clone https://github.com/christoofar/asterisk/
cd asterisk
docker build -t asterisk .
docker run --name asterisk asterisk
```

Mount ``/etc/asterisk`` inside the container to point to a folder on your host.   You can use the sample configuration files here in this repo as a starting template or roll your own.  Most people start by editing ``sip.conf`` and creating a SIP extension and then connecting a SIP client like XLite to the server instance.   From there they start writing dialplan programs in ``extensions.conf``, and so on.
