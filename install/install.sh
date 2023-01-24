#!/bin/bash

set +x

curl -O https://raw.githubusercontent.com/ShardIce/arch-linux/master/install/settings
chmod 0775 setings

. settings
echo "Подтянули настройки для $USERNAME"

# Servers
# Указываем названия серверов
for var in "$SERVER"
do
echo -e "\e[1;37;1;42m Заходим на сервер $var \e[0m"
echo "https://$var/archlinux/\$repo/os/\$arch"
echo "Показываем на каком мы сервере $var\n1"
echo -e "\n2"
done
