#!/bin/bash

dnf upgrade -y && dnf install -y epel-release 'dnf-command(config-manager)' && dnf config-manager --set-enabled crb

dnf install -y \
gcc gcc-c++ git subversion make cmake mesa-libGL-devel libX11-devel libXxf86vm-devel libXi-devel libXcursor-devel libXrandr-devel libXinerama-devel libstdc++-static

dnf install -y \
wayland-devel wayland-protocols-devel mesa-libEGL-devel libxkbcommon-devel dbus-devel kernel-headers

mkdir /blender-git
cd /blender-git
git clone https://git.blender.org/blender.git

cd blender
git checkout blender-v3.2-release

mkdir ../logs ../tar
shopt -s extglob

make deps |& tee ../logs/deps_0.txt
rm -rf ../!("blender"|"logs"|"tar")

dnf install -y \
autoconf automake bison libtool yasm tcl meson ninja-build

make deps -k
make deps |& tee ../logs/deps_1.txt

tar -czf ../tar/deps_1.tar.gz ../build_linux/
rm -rf ../build_linux/deps/!("packages")

EXTRA=( patch perl-FindBin diffutils alsa-lib-devel pulseaudio-libs-devel ncurses-devel flex python3-mako )

function step {
    dnf install -y "$1"

    make deps -k
    make deps |& tee ../logs/deps_"$1".txt
    
    tar -czf ../tar/deps_"$1".tar.gz ../build_linux
    rm -rf ../build_linux/deps/!("packages")
}

for E in ${EXTRA[@]}; do
    step "$E" "$i"
done

cd /
tar -czvf logs.tar.gz /blender-git/logs
tar -czvf blender.tar.gz /blender-git
rm -rf /blender-git
