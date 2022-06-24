FROM almalinux:9

RUN dnf install -y wget && wget https://raw.githubusercontent.com/HPPinata/Build_Blender/main/build.sh

RUN bash build.sh
