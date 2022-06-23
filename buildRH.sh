#!/bin/sh

dnf upgrade -y && dnf install -y epel-release 'dnf-command(config-manager)' && dnf config-manager --set-enabled crb

dnf install -y \
gcc gcc-c++ git subversion make cmake mesa-libGL-devel libX11-devel libXxf86vm-devel libXi-devel libXcursor-devel libXrandr-devel libXinerama-devel libstdc++-static

dnf install -y \
wayland-devel wayland-protocols-devel mesa-libEGL-devel libxkbcommon-devel dbus-devel kernel-headers

mkdir ~/blender-git
cd ~/blender-git
git clone https://git.blender.org/blender.git

cd blender
git pull origin master

dnf install -y \
autoconf automake bison libtool yasm tcl meson ninja-build patch perl-FindBin alsa-lib-devel pulseaudio-libs-devel ncurses-devel diffutils python3-mako
# flex

make deps
