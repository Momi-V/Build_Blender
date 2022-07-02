FROM almalinux:9

RUN dnf install -y wget && wget https://raw.githubusercontent.com/HPPinata/Build_Blender/main/build.bash

RUN bash build.bash
