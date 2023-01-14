#!/bin/bash 

set -x

mkdir /mnt/opt
mount /mnt/opt

# Делаем скрипт пост инстала:
cat <<EOF>>/mnt/opt/install.sh
#!/bin/bash

# Обновление репозиториев
pacman -Sy

# Создаем файл о нашем железе
mkinitcpio -p linux

sleep 1
passwd 
printf "root"
useradd -mg users -G wheel -s /bin/bash shardice
passwd shardice
printf "shardice"

#it's not beautiful
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

sleep 1
printf "Hostname"
hostnamectl set-hostname ArchPC
printf "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
printf "KEYMAP=ru" >> /etc/vconsole.conf
printf "FONT=cyr-sun16" >> /etc/vconsole.conf
printf 'LANG="ru_RU.UTF-8"' > /etc/locale.conf 
printf "en_US.UTF-8 UTF-8" > /etc/locale.gen
printf 'Обновим текущую локаль системы'
locale-gen
localectl set-locale LANG="ru_RU.UTF-8"

sleep 1
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

######### nano /etc/sudoers.d/sudo
printf "%wheel ALL=(ALL) ALL\n" >> /etc/sudoers.d/sudo

#it's not beautiful
#nano /etc/pacman.conf
printf '[multilib]' >> /etc/pacman.conf
printf 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

# Устанавливаем нужные пакеты
pacman -Sy xorg xorg-server mate mate-extra sddm --noconfirm

# Сеть
pacman -Sy dhcpcd networkmanager networkmanager-openvpn network-manager-applet --noconfirm
pacman -Sy ppp chromium neofetch filezilla sudo git htop blueman fuse --noconfirm 

# Подстрахуемся и включим повторно DHCP
# printf "Install DHCPD"
systemctl enable dhcpcd
systemctl start dhcpcd

# Включаем экран логирования
systemctl enable sddm
stemctl start sddm

exit
EOF

echo '12. Переходим в новое окружение'
cp install.sh /mnt/opt/install.sh

#Начинаем использование системы
arch-chroot /mnt
bash /mnt/opt/install.sh

systemctl enable dhcpcd
systemctl start dhcpcd
systemctl status dhcpcd
