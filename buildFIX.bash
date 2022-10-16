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

cd build_files/build_environment/cmake
sed -i 's+(SQLITE_URI .*)+(SQLITE_URI https://github.com/sqlite/sqlite/archive/refs/tags/version-${SQLITE_VERSION}.zip)+g' versions.cmake
sed -i 's+(SQLITE_HASH .*)+(SQLITE_HASH 4d7a4664898766997c100d5c323f57743be43b3d+g' versions.cmake
sed -i 's+(SQLITE_FILE .*)+(SQLITE_FILE version-${SQLITE_VERSION}.zip)+g' versions.cmake
cd ~/blender-git/blender

dnf install -y gcc-toolset-10
scl enable gcc-toolset-10 bash << 'EOL'

dnf install -y \
autoconf automake bison libtool yasm meson ninja-build
dnf install -y \
patch alsa-lib-devel pulseaudio-libs-devel ncurses-devel flex zlib-devel python3-mako

make deps -n | sed "s+cmake+cmake -DPACKAGE_USE_UPSTREAM_SOURCES=OFF+g" | bash
make deps -k
make update
make
EOL
