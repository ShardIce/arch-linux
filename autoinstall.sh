#!/bin/bash 

set -x

#/dev/sda1 - /boot
#/dev/sda2 - swap 
#/dev/sda3 - /

# Ставим быстрые репы

> /etc/pacman.d/mirrorlist
cat <<EOF>>/etc/pacman.d/mirrorlist

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
#pacman-key --init
#pacman-key --populate archlinux

# только для теста - стирает все разделы
# dd if=/dev/zero of=/dev/sda bs=1G count=10 status=progress

# Разметка диска
printf "g\nw\n" | fdisk /dev/sda # создаём gpt
printf "n\n1\n\n+1G\nt\n4\nw\n" | fdisk /dev/sda # первый раздел 1Гб
printf "n\n2\n\n+10G\nt\n2\n19\nw\n" | fdisk /dev/sda # второй раздел 10Гб
printf "n\n3\n\n\nw\n" | fdisk /dev/sda # третий раздел - остаток
 
# Форматируем в ext 4 наш диск
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3

# Монтируем диск к папке
mount /dev/sda3 /mnt
mountpoint /mnt

# Cоздадим несколько папок
mkdir /mnt/boot /mnt/home /mnt/var

# Подключаем нашу загрузочную папку в загрузочный раздел "bootable"
mount /dev/sda1 /mnt/boot
mountpoint /mnt/boot

# Установка системы Arch Linux ядро + софт который нам нужен сразу
pacstrap /mnt base base-devel linux linux-headers linux-firmware

# Устанавливаем загрузчик
pacstrap /mnt grub-bios

# Прописываем fstab
genfstab -p /mnt >> /mnt/etc/fstab
