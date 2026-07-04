#!/bin/bash

# ===== المتغيرات مباشرة هنا =====
USERNAME="admin"
PASSWORD="admin123"
MACHINE_NAME="myvps"
NGROK_TOKEN="3G3Tk6nVhtJAwnFXKx3eQYy9LzO_5J9vdkaKf9pbCSMMSVKW"
# ================================

# إنشاء المستخدم وإعداد النظام
sudo useradd -m $USERNAME
sudo adduser $USERNAME sudo
echo "$USERNAME:$PASSWORD" | sudo chpasswd
sudo hostname $MACHINE_NAME

# تثبيت ngrok
echo "### Installing ngrok ###"
wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip
unzip -o ngrok-stable-linux-386.zip
chmod +x ./ngrok

# تشغيل ngrok
echo "### Starting ngrok tunnel for SSH ###"
./ngrok authtoken "$NGROK_TOKEN"
./ngrok tcp 22 --log ".ngrok.log" &

sleep 10

# عرض بيانات الاتصال
if [[ -z "$(grep 'command failed' .ngrok.log)" ]]; then
  echo ""
  echo "=========================================="
  echo "✅ SSH Connection Details:"
  grep -o -E "tcp://(.+)" .ngrok.log | sed "s/tcp:\/\//ssh $USERNAME@/" | sed "s/:/ -p /"
  echo "   Password: $PASSWORD"
  echo "=========================================="
else
  echo "❌ ngrok failed. Log:"
  cat .ngrok.log
  exit 4
fi

# إبقاء الجهاز يعمل
sleep 6h
