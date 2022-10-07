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

mkdir ../log ../tar

dnf install -y gcc-toolset-10
scl enable gcc-toolset-10 bash << 'EOL'
shopt -s extglob

make deps |& tee ../log/0_deps.txt
rm -rf ../!("blender"|"log"|"tar")

dnf install -y \
autoconf automake bison libtool tcl yasm meson ninja-build

make deps -k && make deps -k
make deps |& tee ../log/1_deps.txt

#tar -czf ../tar/1_deps.tar.gz ../build_linux/deps/!("packages")
rm -rf ../build_linux/deps/!("packages") ../lib

EXTRA=( patch alsa-lib-devel pulseaudio-libs-devel ncurses-devel zlib-devel flex python3-mako )
i=2

for E in ${EXTRA[@]}; do
    dnf install -y "$E"

    make deps -k && make deps -k
    make deps |& tee ../log/"$i"_deps_"$E".txt

#    tar -czf ../tar/"$i"_deps_"$E".tar.gz ../build_linux/deps/!("packages")
    rm -rf ../build_linux/deps/!("packages") ../lib
    ((i++))
done

make deps
#tar -czvf log.tar.gz ~/blender-git/log
#tar -czvf blender.tar.gz ~/blender-git && rm -rf ~/blender-git
EOL
