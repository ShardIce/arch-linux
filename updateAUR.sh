#!/bin/bash
path1=/Desktop/AUR

echo "Идем в директорию"
cd $PWD$path1
echo $PWD
echo -e "\n"

# Указываем названия пакетов с двойными ковычками
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
