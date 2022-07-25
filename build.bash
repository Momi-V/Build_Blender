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

mkdir ../logs
shopt -s extglob

make deps |& tee ../logs/deps_-1.txt

dnf install -y \
autoconf automake bison libtool yasm tcl meson ninja-build

make deps -k
sleep 10
make deps |& tee ../logs/deps_0.txt

EXTRA=( patch perl-FindBin diffutils alsa-lib-devel pulseaudio-libs-devel ncurses-devel flex python3-mako )

function step {
    sleep 10
    cd ../build_linux/deps
    rm -rfv !("packages")
    cd ../../blender

    dnf install -y "$1"

    sleep 10
    make deps -k
    sleep 10
    make deps |& tee ../logs/deps_"$2".txt
}

i=1
for E in ${EXTRA[@]}; do
    step "$E" "$i"
    let "i+=1"
done
