#!/bin/bash

set +x

curl -O https://raw.githubusercontent.com/ShardIce/arch-linux/master/install/settings
chmod 0775 setings

. settings
echo "Подтянули настройки для $USERNAME"

echo -e "\e[1;37;1;42m Сохраняем актуальный mirrorlist \e[0m"
# Servers
# Указываем названия серверов
sudo curl -o /etc/pacman.d/mirrorlist https://archlinux.org/mirrorlist/?country=$COUNTRY&protocol=$PROTOCOL&ip_version=$IP_VERSION
sleep 5
sudo sed -i -e "s/#Server\ /Server\ /g" /etc/pacman.d/mirrorlist

