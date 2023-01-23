#!/bin/bash

set +x

curl -O https://raw.githubusercontent.com/ShardIce/arch-linux/master/install/settings

./settings
echo "Подтянули настройки для $USERNAME"

# Servers
# Указываем названия серверов
for var in "$SERVER"
do
echo -e "\e[1;37;1;42m Заходим на сервер $var \e[0m"
git clone https://$var/archlinux/\$repo/os/\$arch
echo "Показываем на каком мы сервере $var\n1"
echo -e "\n2"
done
