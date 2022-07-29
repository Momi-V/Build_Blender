#!/bin/bash

dnf upgrade -y && dnf install -y epel-release 'dnf-command(config-manager)' && dnf config-manager --set-enabled crb

dnf install -y \
gcc gcc-c++ git subversion make cmake mesa-libGL-devel libX11-devel libXxf86vm-devel libXi-devel libXcursor-devel libXrandr-devel libXinerama-devel libstdc++-static

dnf install -y \
wayland-devel wayland-protocols-devel mesa-libEGL-devel libxkbcommon-devel dbus-devel kernel-headers

mkdir ~/blender-git
cd ~/blender-git
git clone https://git.blender.org/blender.git

cd blender
git checkout blender-v3.2-release

dnf install -y \
autoconf automake bison libtool yasm tcl meson ninja-build patch perl-FindBin diffutils alsa-lib-devel pulseaudio-libs-devel ncurses-devel flex python3-mako

make deps -n | sed "s+cmake+cmake -DWITH_STATIC_LIBS=on+g" | bash
