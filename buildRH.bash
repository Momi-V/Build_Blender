#!/bin/bash

dnf upgrade -y && dnf install -y epel-release 'dnf-command(config-manager)' && dnf config-manager --set-enabled powertools

dnf install -y \
gcc gcc-c++ git subversion make cmake mesa-libGL-devel mesa-libEGL-devel libX11-devel libXxf86vm-devel libXi-devel libXcursor-devel libXrandr-devel libXinerama-devel libstdc++-static

dnf install -y \
wayland-devel wayland-protocols-devel libxkbcommon-devel dbus-devel kernel-headers

mkdir ~/blender-git
cd ~/blender-git
git clone https://git.blender.org/blender.git
cd blender
git checkout blender-v3.2-release

dnf install -y gcc-toolset-10
scl enable gcc-toolset-10 bash << 'EOL'

dnf install -y \
autoconf automake bison libtool tcl yasm meson ninja-build
dnf install -y \
patch alsa-lib-devel pulseaudio-libs-devel ncurses-devel zlib-devel flex python3-mako

make deps -k && make deps -k
make update
make
EOL
