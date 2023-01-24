#!/bin/bash

set +x

echo "Вводите все ответы без скобок ()"
read -e -p "Введите имя: " USERNAME
echo "Было введено имя: " $USERNAME
read -e -p "Введите локаль в формате (RU),(US): " COUNTRY
echo "Вы выбрали страну реп: " $COUNTRY
read -e -p "Введите версию IP протокола (4) или (6): " IP_VERSION
echo "Ваша версия IP протокола: " $IP_VERSION
read -e -p "Введите протокол (http) или (https): " PROTOCOL
echo "Ваша версия протокола:" $PROTOCOL


cat <<SET>./settings
#!/bin/bash

USERNAME=$USERNAME

# Актуальне зеркала
COUNTRY=$COUNTRY
IP_VERSION=$IP_VERSION
PROTOCOL=$PROTOCOL
SET

#curl -O https://raw.githubusercontent.com/ShardIce/arch-linux/master/install/settings

. settings
echo "Подтянули настройки для $USERNAME"

echo -e "\e[1;37;1;42m Сохраняем актуальный mirrorlist \e[0m"
# Servers
# Указываем названия серверов
sudo curl -o /etc/pacman.d/mirrorlist https://archlinux.org/mirrorlist/?country=$COUNTRY&protocol=$PROTOCOL&ip_version=$IP_VERSION
sleep 5
sudo sed -i -e "s/#Server\ /Server\ /g" /etc/pacman.d/mirrorlist
