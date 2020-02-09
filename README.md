# Asterisk PBX for Docker

This is a working STABLE and usable Asterisk PBX Server, in Docker, using Debian-lite.

As of right now the LTS is 16.8.0.

Standard codecs and options are setup and installed on this image.   It's highly recommended you provide your own ``/etc/asterisk`` folder as a mount to a running container.  If you don't provide one, you're going to get a standard configuration that has no SIP extensions configured, but it does have a pre-configured PBX trunk set up that can dial USA/Canada toll-free numbers.

Also consider mounting ``/var/lib/asterisk/sounds`` if you are going to be adding to the default EN-US sound packs that are installed, and also a mount point for SSL certificates if you plan on configuring TCP/TLS, ARI, and other services that use encrypted sockets.

# How do I configure this thing?

Mount ``/etc/asterisk`` inside the container to point to a folder on your host.   You can use the sample configuration files here in this repo as a starting template or roll your own.  Most people start by editing ``sip.conf`` and creating a SIP extension and then connecting a SIP client like XLite to the server instance.   From there they start writing dialplan programs in ``extensions.conf``, and so on.

# Does this image have FreePBX in it?

No.  There's probably a few FreePBX docker images out there with a companion Asterisk instance available; but FreePBX is actually a hinderance to advanced telephony developers.   Maybe it might sense to make a new Docker image based on this one with FreePBX on it.

# Running in Docker

A barebones server can be started this way:

``docker run --name asterisk christoofar/asterisk``

# Building the Service

If you prefer to build your own image locally and run it:

``
git clone github.com/christoofar/asterisk/
cd asterisk
docker build -t asterisk .
docker run --name asterisk asterisk
``
