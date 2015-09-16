FROM phusion/baseimage:0.9.16
MAINTAINER okachobi<okachobi@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \

add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" && \
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" && \
add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ utopic main restricted" && \
add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ vivid main restricted" && \
apt-get update -q && \

# Install Dependencies - pull Python 2.7.9 from vivid APT repo
apt-get -t vivid install -qy python2.7 python-cheetah && \
apt-get install -qy ca-certificates wget unrar unzip && \

# Install SickRage master
mkdir /opt/sickrage && \
cd /tmp && \
wget https://github.com/SiCKRAGETV/SickRage/archive/master.zip && \
unzip master.zip && \
mv SickRage-master/* /opt/sickrage/ && \
chown -R nobody:users /opt/sickrage && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

EXPOSE 8081

# SickRage Configuration
VOLUME /config

# Downloads directory
VOLUME /downloads

# TV directory
VOLUME /tv

# Add edge.sh to execute during container startup
RUN mkdir -p /etc/my_init.d
ADD edge.sh /etc/my_init.d/edge.sh
RUN chmod +x /etc/my_init.d/edge.sh

# Add SickRage to runit
RUN mkdir /etc/service/sickrage
ADD sickrage.sh /etc/service/sickrage/run
RUN chmod +x /etc/service/sickrage/run
