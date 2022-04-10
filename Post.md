I have been trying for a while to compile a portable aarch64 version of Blender (headless is good enough) on Ubuntu 20.04.  
I know this is not a supported usecase but here are my findings, they might be useful.  
The install_deps.sh script is not an option due to the portability being a core requirement (otherwise I´d use the package manager).

The system i am using is an Ampere A1 compute instance in the Oracle Cloud free tier
(  
    4 CPUs  
    24 GB Ram  
    5.13.0-1025-oracle #30~20.04.1-Ubuntu SMP Fri Apr 1 06:09:46 UTC 2022 aarch64 aarch64 aarch64 GNU/Linux  
).  
I will include the ssh key and IP-Adress for you to take a look at the System and I will try to keep them updated. If you want a clean slate instead of the system after I executed the script please comment and I will reset the system, but you can also register for free [cloud.oracle.com](https://cloud.oracle.com) and try it out yourself.

Current IP: 130.61.115.168  
Key: https://cloudnextcloud.dynv6.net/s/b6oz7BK4rbRkKq5 (can not be uploaded here)  
Log files: will be added as soon as current run finishes (est. 2h)

Based on this [wiki entry](https://wiki.blender.org/wiki/Building_Blender/Linux/Ubuntu) i arrived at these steps:

run with sudo:
```
#!/bin/sh

apt update && apt full-upgrade -y && apt autopurge -y

apt install -y build-essential git subversion cmake libx11-dev libxxf86vm-dev libxcursor-dev libxi-dev libxrandr-dev libxinerama-dev libglew-dev
apt install -y libwayland-dev wayland-protocols libegl-dev libxkbcommon-dev libdbus-1-dev linux-libc-dev

mkdir ~/blender-git
cd ~/blender-git
git clone https://git.blender.org/blender.git

mkdir log
cd blender
git pull origin master

make update | tee ../log/update_1.log

#apt install -y python3    #already installed in cloud instance
#make update | tee ../log/update_2.log

make deps | tee ../log/deps_1.log

apt install -y autoconf automake bison libtool tcl yasm meson ninja-build

make deps | tee ../log/deps_2.log
make deps -k | tee ../log/deps_3.log
make deps -k | tee ../log/deps_4.log
make deps | tee ../log/deps_5.log
```

The files are in /root (due to the script being run with sudo)

The wayland dependencies no longer seem to be optional as they are enabled by default and the make deps command will fail if they are not present unless configured otherwise manually.  
A lot of the dependencies seem to compile, but there are some issues which I am unable to resolve as I am not a developer and do not understand what I am doing.

I hope this might be useful information or at least didn´t waste too much of your time.
