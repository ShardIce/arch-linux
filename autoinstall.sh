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
cfdisk /dev/sda

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


#Установка системы Arch Linux ядро + софт который нам нужен сразу
pacstrap /mnt base base-devel linux linux-headers dhcpcd  which inetutils netctl wget networkmanager network-manager-applet mkinitcpio git dkms grub efibootmgr nano vi linux-firmware wpa_supplicant dialog

# Устанавливаем загрузчик
pacstrap /mnt grub-bios

# Прописываем fstab
genfstab -p /mnt >> /mnt/etc/fstab

#Начинаем использование системы
arch-chroot /mnt

#Прокидываем правильные быстрые репы внутрь
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist


# Делаем скрипт пост инстала:
cat <<EOF >> /mnt/opt/install.sh
#!/bin/bash

#Обновим ключики на всякий пожарный
pacman-key --init
pacman-key --populate archlinux

# Создаем файл о нашем железе
mkinitcpio -p linux

sleep 1
echo "password for root user:"
passwd root
echo 'root'
echo "add new user"
useradd -mg users -G wheel -s /bin/bash shardice
echo "paaswd for new user"
passwd shardice
echo 'shardice'
#it's not beautiful
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

sleep 1
echo "Hostname"
hostnamectl set-hostname ArchPC

echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
echo "KEYMAP=ru" >> /etc/vconsole.conf
echo "FONT=cyr-sun16" >> /etc/vconsole.conf
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf 
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo 'Обновим текущую локаль системы'
locale-gen
localectl set-locale LANG="ru_RU.UTF-8"

sleep 1
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

#########
nano /etc/sudoers
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

#it's not beautiful
nano /etc/pacman.conf
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

# Устанавливаем нужные пакеты
pacman -Sy xorg xorg-server mate mate-extra sddm

# Сеть
pacman -Sy dhcpcd networkmanager networkmanager-openvpn network-manager-applet

pacman -Sy ppp chromium neofetch filezilla sudo git htop blueman fuse --noconfirm

# Включаем экран логирования
systemctl enable sddm
stemctl start sddm

# Подстрахуемся и включим повторно DHCP
echo "Install DHCPD"
systemctl enable dhcpcd
systemctl start dhcpcd

# Включаем сетевой менеджер
systemctl enable NetworkManager

exit
EOF

arch-chroot /mnt /bin/bash  /opt/install.sh

reboot
