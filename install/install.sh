#!/bin/bash

set +x

curl -O https://raw.githubusercontent.com/ShardIce/arch-linux/master/install/settings

./settings
echo "Подтянули настройки для $USERNAME"

# Указываем названия пакетов с двойными ковычками
for var in "mirror.surf mirror.nw-sys.ru mirrors.powernet.com.ru mirror.rol.ru mirror.truenetwork.ru mirror.yandex.ru mirror.23media.com"

do
echo -e "\e[1;37;1;42m Заходим на сервер $var \e[0m"
git clone https://$var/archlinux/\$repo/os/\$arch
echo "Показываем на каком мы сервере $var\n"
