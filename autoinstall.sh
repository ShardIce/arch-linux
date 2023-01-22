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

# только для теста - стирает все разделы
# dd if=/dev/zero of=/dev/sda bs=1G count=10 status=progress

echo "Активируем новые репы"
pacman-key --init
pacman-key --populate archlinux

echo "Разметка диска"
echo -e 'size=1G  bootable, type=L\n size=10G, type=S\n size=+\n' | sfdisk /dev/sda
 
echo "Форматируем в ext 4 наш диск"
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3

echo "Монтируем диск к папке"
mount /dev/sda3 /mnt
mountpoint /mnt

echo "Cоздадим несколько папок"
mkdir /mnt/boot /mnt/home /mnt/var /mnt/opt

echo "Подключаем нашу загрузочную папку в загрузочный раздел bootable"
mount /dev/sda1 /mnt/boot
mountpoint /mnt/boot

echo "Установка системы Arch Linux ядро + софт который нам нужен сразу"
pacstrap -K /mnt base linux linux-firmware linux-headers base-devel

echo "Устанавливаем загрузчик"
pacstrap /mnt grub-bios

echo "Прописываем fstab"
genfstab -p /mnt >> /mnt/etc/fstab

echo "Устанавливаем дополнительные пакеты"
pacman -Sy dhcpcd xorg xorg-server mate mate-extra sddm chromium sudo git htop fuse nano --noconfirm 

cat <<EOF>>/mnt/opt/install.sh
#!/bin/bash

echo "Обновление репозиториев"
pacman -Sy

echo "Обновим ключики на всякий пожарный"
pacman -S archlinux-keyring dhcpcd --noconfirm

echo "Создаем файл о нашем железе"
mkinitcpio -p linux

sleep 1
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
printf "LANG="ru_RU.UTF-8\n" > /etc/locale.conf 

sleep 1
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

echo "Включаем экран логирования"
systemctl enable sddm
systemctl start sddm

exit
EOF

sleep 1
echo  "Hostname"
hostnamectl set-hostname 'Arch'

echo "Переход в новое окружение"
chmod 0777 /mnt/opt/install.sh
arch-chroot /mnt /usr/bin/bash -c /opt/install.sh

echo "Подстрахуемся и включим повторно DHCP"
systemctl enable dhcpcd
systemctl start dhcpcd
