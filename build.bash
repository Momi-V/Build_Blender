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

mkdir ../log ../tar
shopt -s extglob

make deps |& tee ../log/deps_0.txt
rm -rf ../!("blender"|"log"|"tar")

dnf install -y \
autoconf automake bison libtool yasm tcl meson ninja-build

make deps -k
make deps |& tee ../log/deps_1.txt

#tar -czf ../tar/deps_1.tar.gz ../build_linux/deps/!("packages")
rm -rf ../build_linux/deps/!("packages") ../lib

EXTRA=( patch perl-FindBin diffutils alsa-lib-devel pulseaudio-libs-devel ncurses-devel flex python3-mako )

function step {
    dnf install -y "$1"

    make deps -k
    make deps |& tee ../log/deps_"$1".txt

#    tar -czf ../tar/deps_"$1".tar.gz ../build_linux/deps/!("packages")
    rm -rf ../build_linux/deps/!("packages") ../lib
}

for E in ${EXTRA[@]}; do
    step "$E"
done

#tar -czvf log.tar.gz ~/blender-git/log
#tar -czvf blender.tar.gz ~/blender-git
#rm -rf ~/blender-git
