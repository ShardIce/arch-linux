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
dd if=/dev/zero of=/dev/sda bs=1G count=10 status=progress

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

#Установка системы Arch Linux ядро + софт который нам нужен сразу
pacstrap /mnt base base-devel linux linux-headers linux-firmware dhcpcd

# Устанавливаем загрузчик
pacstrap /mnt grub-bios

# Прописываем fstab
genfstab -p /mnt >> /mnt/etc/fstab


echo '14. Переход в новое окружение'
# chmod 0777 /mnt/opt/install.sh
arch-chroot /mnt /bin/bash -c /opt/install.sh

# Делаем скрипт пост инстала:
cat <<EOF>>/opt/install.sh
#!/bin/bash

#Обновим ключики на всякий пожарный
pacman -S archlinux-keyring --noconfirm

# Обновление репозиториев
pacman -Sy

# Создаем файл о нашем железе
mkinitcpio -p linux

sleep 1
#echo root:root | chpasswd
printf "root\nroot\n" | passwd

useradd -mg users -G wheel -s /bin/bash shardice
printf "1002\n1002\n | passwd shardice

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
#printf '[multilib]' >> /etc/pacman.conf
#printf 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
sed -i '93c[multilib]' /mnt/etc/pacman.conf ; sed -i '94cInclude = /etc/pacman.d/mirrorlist' /mnt/etc/pacman.conf

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
systemctl start sddm

exit
EOF



# Вариант 2
# chroot /mnt/opt /bin/bash

#Начинаем использование системы
#arch-chroot /mnt
#arch-chroot /mnt bash /mnt/opt/install.sh

systemctl enable dhcpcd
systemctl start dhcpcd
systemctl status dhcpcd
