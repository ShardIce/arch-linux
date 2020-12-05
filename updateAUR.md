#!/bin/bash
path1=/Desktop/AUR

echo -e "\e[1;37;1;42m СТАРТ \e[0m"
echo -e "\e[1;Устанавливаем основные пакеты\e[0m"
#sudo pacman -S samba ktorrent chromium filezilla htop nftables qbittorrent telegram-desktop transmission-cli wine-gecko wine-mono ttf-dejavu

echo "Идем в директорию"
cd $PWD$path1
echo $PWD
echo -e "\n"

for var in "qtox-git" "plex-media-server" "tautulli" "anydesk-bin" "rclone-browser" "timeshift"
do
echo -e "\e[1;37;1;42m Скачиваем $var \e[0m"
git clone https://aur.archlinux.org/$var.git
echo "Заходим в папку $var"
cd $PWD/$var
echo "Устанавливаем $var"
#yes | makepkg -sri
echo "Выходим из папки $var"
cd ../
echo "Проверяем наше местоположение"
echo $PWD
echo -e "\n"
done
