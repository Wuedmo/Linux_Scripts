#!/usr/bin/env bash

IMAGE="kali-xfce-local"

echo "[+] Checking image..."

if [[ "$(docker images -q $IMAGE 2> /dev/null)" == "" ]]; then
  echo "[+] Building Kali XFCE image..."

  docker build --network=host -t $IMAGE - <<EOF
FROM kalilinux/kali-rolling

RUN apt update && \
    apt install -y kali-linux-large kali-desktop-xfce dbus-x11 xfce4-terminal sudo && \
    apt clean

CMD startxfce4
EOF

fi

echo "[+] Starting Kali container on host network..."

x11docker \
  --desktop \
  --gpu \
  --pulseaudio \
  --clipboard \
  --home \
  --size=1280x720 \
  --network=host \
  $IMAGE