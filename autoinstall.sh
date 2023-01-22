#!/bin/bash 

set -x

#/dev/sda1 - /boot
#/dev/sda2 - swap 
#/dev/sda3 - /

# Ставим быстрые репы

cat <<AML>>/etc/pacman.d/mirrorlist

##
## Arch Linux repository mirrorlist
## Generated on 2020-01-02
##

## Russia
Server = http://mirror.surf/archlinux/\$repo/os/\$arch
Server = https://mirror.surf/archlinux/\$repo/os/\$arch
Server = http://mirror.nw-sys.ru/archlinux/\$repo/os/\$arch
Server = https://mirror.nw-sys.ru/archlinux/\$repo/os/\$arch
Server = http://mirrors.powernet.com.ru/archlinux/\$repo/os/\$arch
Server = http://mirror.rol.ru/archlinux/\$repo/os/\$arch
Server = https://mirror.rol.ru/archlinux/\$repo/os/\$arch
Server = http://mirror.truenetwork.ru/archlinux/\$repo/os/\$arch
Server = https://mirror.truenetwork.ru/archlinux/\$repo/os/\$arch
Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch
Server = http://archlinux.zepto.cloud/\$repo/os/\$arch
Server = https://mirror.yandex.ru/archlinux/\$repo/os/\$arch
Server = https://mirror.23media.com/archlinux/\$repo/os/\$arch
AML

# только для теста - стирает все разделы
# dd if=/dev/zero of=/dev/sda bs=1G count=10 status=progress

echo "Активируем новые репы"
pacman-key --init
pacman-key --populate archlinux

echo "Разметка диска"
printf 'size=1G  bootable, type=L\n size=10G, type=S\n size=+\n' | sfdisk /dev/sda
 
echo "Форматируем в ext 4 наш диск"
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3

echo "Монтируем диск к папке"
mount /dev/sda3 /mnt
mountpoint /mnt

echo "Cоздадим несколько папок"
mkdir /mnt/boot /mnt/home /mnt/var

echo "Подключаем нашу загрузочную папку в загрузочный раздел bootable"
mount /dev/sda1 /mnt/boot
mountpoint /mnt/boot

echo "Установка системы Arch Linux ядро + софт который нам нужен сразу"
pacstrap -K /mnt base linux linux-firmware linux-headers base-devel

echo "Устанавливаем загрузчик"
pacstrap /mnt grub-bios

echo "Прописываем fstab"
genfstab -p /mnt >> /mnt/etc/fstab

cat <<EOF>>/var/tmp/install.sh
#!/bin/bash

echo "Обновление репозиториев"
pacman -Sy

echo "Обновим ключики на всякий пожарный и установим важные пакеты"
pacman -Sу archlinux-keyring dhcpcd xorg xorg-server mate mate-extra sddm --noconfirm

echo "Устанавливаем дополнительные пакеты"
pacman -Sy chromium sudo git htop fuse nano --noconfirm 

echo "Создаем файл о нашем железе"
mkinitcpio -p linux

printf 'root\nroot\n' | passwd

useradd -mg users -G wheel -s /bin/bash shardice
printf '1002\n1002\n' | passwd shardice

echo "it not beautiful"
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo "Добавим SUDO"
echo "%wheel ALL=(ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/sudo

echo "Обновим текущую локаль системы"
locale-gen
localectl set-locale LANG="ru_RU.UTF-8"
localectl set-locale LANG="en_US.UTF-8"

printf "KEYMAP=ru\n" >> /etc/vconsole.conf
printf "FONT=cyr-sun16\n" >> /etc/vconsole.conf
printf "LANG=ru_RU.UTF-8\n" > /etc/locale.conf 

ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

echo "Включаем экран логирования"
systemctl enable sddm

exit
EOF

cat <<NCR>>/var/tmp/install2.sh
#!/bin/bash

echo  "Hostname"
hostnamectl set-hostname Arch

echo "Подстрахуемся и включим повторно DHCP"
systemctl enable dhcpcd
systemctl start dhcpcd
NCR

echo "Переход в новое окружение"
arch-chroot /mnt /usr/bin/bash -c /var/tmp/install.sh
