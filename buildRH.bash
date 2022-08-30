#!/bin/bash

dnf upgrade -y && dnf install -y epel-release 'dnf-command(config-manager)' && dnf config-manager --set-enabled crb

dnf install -y xorg-x11-drivers

dnf install -y \
gcc gcc-c++ git subversion make cmake mesa-libGL-devel mesa-libEGL-devel libX11-devel libXxf86vm-devel libXi-devel libXcursor-devel libXrandr-devel libXinerama-devel libstdc++-static

dnf install -y \
wayland-devel wayland-protocols-devel libxkbcommon-devel dbus-devel kernel-headers

mkdir ~/blender-git
cd ~/blender-git
git clone https://git.blender.org/blender.git
cd blender
git checkout blender-v3.2-release

dnf install -y \
autoconf automake bison libtool yasm tcl meson ninja-build patch perl-FindBin diffutils alsa-lib-devel pulseaudio-libs-devel ncurses-devel flex python3-mako

make deps -n | grep cmake | bash
cd ../build_linux/deps/packages
sed -i.bak  -e 's/.if !defined.ARCH_OS_WINDOWS./#if 0/' -e 's/.if defined.ARCH_COMPILER_GCC.*/#if 0/' -e 's/defined.ARCH_COMPILER_CLANG.//' -e 's/.if defined.ARCH_OS_LINUX./#if 0/' -e 's/.if !defined.ARCH_OS_LINUX./#if 1/' pxr/base/arch/mallocHook.cpp
cd ..
make -j 8
