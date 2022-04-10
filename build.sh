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
