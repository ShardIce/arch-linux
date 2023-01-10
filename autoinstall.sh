#!/bin/bash

#/dev/sda1 - /boot
#/dev/sda2 - swap 
#/dev/sda3 - /



# Ставим быстрые репы

> /etc/pacman.d/mirrorlist
cat <<EOF >>/etc/pacman.d/mirrorlist

##
## Arch Linux repository mirrorlist
## Generated on 2020-01-02
##

## Russia
#Server = http://mirror.surf/archlinux/$repo/os/$arch
#Server = https://mirror.surf/archlinux/$repo/os/$arch
#Server = http://mirror.nw-sys.ru/archlinux/$repo/os/$arch
#Server = https://mirror.nw-sys.ru/archlinux/$repo/os/$arch
#Server = http://mirrors.powernet.com.ru/archlinux/$repo/os/$arch
#Server = http://mirror.rol.ru/archlinux/$repo/os/$arch
#Server = https://mirror.rol.ru/archlinux/$repo/os/$arch
#Server = http://mirror.truenetwork.ru/archlinux/$repo/os/$arch
#Server = https://mirror.truenetwork.ru/archlinux/$repo/os/$arch
#Server = http://mirror.yandex.ru/archlinux/$repo/os/$arch
#Server = http://archlinux.zepto.cloud/$repo/os/$arch
Server = https://mirror.yandex.ru/archlinux/\$repo/os/\$arch
Server = https://mirror.23media.com/archlinux/\$repo/os/\$arch
EOF

# Активируем новые репы
pacman-key --init
pacman-key --populate archlinux
pacman -Sy

# Разметка диска
 echo -e "g\nw\n" | fdisk /dev/sda # создаём gpt
 echo -e "n\n1\n\n+1G\nw\n" | fdisk /dev/sda # первый раздел 1Гб
 echo -e "n\n2\n\n+10G\nw\n" | fdisk /dev/sda # второй раздел 10Гб
 echo -e "n\n3\n\n\nw\n" | fdisk /dev/sda # третий раздел - остаток

#Форматируем в ext 4 наш диск
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3

# Монтируем диск к папке
mount /dev/sda3 /mnt

# Cоздадим несколько папок
mkdir /mnt/boot /mnt/home /mnt/var

# Подключаем нашу загрузочную папку в загрузочный раздел "bootable"
mount /dev/sda1 /mnt/boot


