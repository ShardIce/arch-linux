#!/bin/bash
USERNAME="shardice"
echo "Пользователь будет $USERNAME"

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

#echo "Активируем новые репы"
#pacman-key --init
#pacman-key --populate archlinux

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

cat <<EOF>>/mnt/var/tmp/install.sh
#!/bin/bash

echo "Обновление репозиториев"
pacman -Sy

echo "Обновим ключики на всякий пожарный и установим важные пакеты"
pacman -Sy archlinux-keyring dhcpcd xorg xorg-server mate mate-extra sddm openssh --noconfirm

echo "Создаем файл о нашем железе"
mkinitcpio -p linux

printf 'root\nroot\n' | passwd

useradd -mg users -G wheel -s /bin/bash $USERNAME
printf '1002\n1002\n' | passwd $USERNAME

echo "it not beautiful"
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo "Добавим SUDO"
printf "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/$USERNAME

echo "Включаем экран логирования"
systemctl enable sddm

echo "Запускаем BASH Additional Settings"
sudo chmod +x /var/tmp/additional_settings.sh
systemctl enable additional_settings

exit
EOF

echo "Создаём файл Additional Settings"
cat <<ADST>>/mnt/var/tmp/additional_settings.sh
#!/bin/bash

echo  "Hostname"
hostnamectl set-hostname Arch

echo "Подстрахуемся и включим повторно DHCP"
systemctl enable dhcpcd
systemctl start dhcpcd

echo "Обновим текущую локаль системы"
locale-gen
localectl set-locale LANG="ru_RU.UTF-8"
localectl set-locale LANG="en_US.UTF-8"

printf "KEYMAP=ru\n" >> /etc/vconsole.conf
printf "FONT=cyr-sun16\n" >> /etc/vconsole.conf
printf "LANG=ru_RU.UTF-8\n" > /etc/locale.conf

ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

sudo chmod +x /var/tmp/additional_software.sh
systemctl enable additional_software
ADST

echo "Создаём файл Unit install additional_settings.sh"
cat <<UADS>>/mnt/etc/systemd/system/additional_settings.service
[Unit]
Description=Additional Settings
After=systemd-user-sessions.service

[Service]
ExecStart=/bin/bash '/var/tmp/additional_settings.sh'
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target reboot.target poweroff.target
UADS

echo "Создаём файл Additional software"
cat <<ADSF>>/mnt/var/tmp/additional_software.sh
#!/bin/bash

echo "Устанавливаем дополнительные пакеты"
pacman -S chromium sudo git htop fuse nano --noconfirm
ADSF

echo "Создаём файл Unit install additional_software.sh"
cat <<UADST>>/mnt/etc/systemd/system/additional_software.service
[Unit]
Description=Additional software
After=systemd-user-sessions.service

[Service]
ExecStart=/bin/bash '/var/tmp/additional_software.sh'
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target reboot.target poweroff.target
UADST

echo "Переход в новое окружение"
chmod +x /mnt/var/tmp/install.sh
arch-chroot /mnt /var/tmp/install.sh

reboot
