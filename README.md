This is a Dockerfile setup for sickrage forked from needo37/sickrage - https://www.sickrage.tv/forums/

It is different from the original in that the python 2.7.6 from the base image is patched to 2.7.9 to fix an openssl/pyopenssl issue.  This is a HACK (I apologize).  When I have time I'll refactor the dockerfile to use a Ubuntu 15 or debian 8 which is distributed with python 2.7.9.  Right now I just want to build something that works so when I reboot my NAS the image works.

To run:

```
docker run -d --name="sickrage" -v /path/to/sickrage/data:/config -v /path/to/downloads:/downloads -v /path/to/tv:/tv -v /etc/localtime:/etc/localtime:ro -p 8081:8081 okachobi/sickrage
```

This fork always uses the master branch. 

