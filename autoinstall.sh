#!/bin/bash
USERNAME="shardice"

# Актуальне зеркала
COUNTRY=RU
IP_VERSION=4
PROTOCOL=https

echo -en "\033[37;1;41m Пользователь будет $USERNAME \033[0m\n"

set -x

#/dev/sda1 - /boot
#/dev/sda2 - swap
#/dev/sda3 - /

# Ставим быстрые репы

echo -en "\033[37;1;41m Сохраняем актуальный mirrorlist по IPv$IP_VERSION \033[0m\n"
# Servers
# Указываем названия серверов
curl -o /etc/pacman.d/mirrorlist "https://archlinux.org/mirrorlist/?country=$COUNTRY&protocol=$PROTOCOL&ip_version=$IP_VERSION"
sleep 5
echo -en "\033[37;1;41m Отредактировали mirrorlist по IPv$IP_VERSION \033[0m\n"
sed -i -e "s/#Server\ /Server\ /g" /etc/pacman.d/mirrorlist

# только для теста - стирает все разделы
# dd if=/dev/zero of=/dev/sda bs=1G count=10 status=progress

#echo -en "\033[37;1;41m Активируем новые репы"
#pacman-key --init
#pacman-key --populate archlinux

echo -e "\033[37;1;41m Разметка диска \033[0m\n"
printf 'size=1G  bootable, type=L\n size=10G, type=S\n size=+\n' | sfdisk /dev/sda

echo -en "\033[37;1;41m Форматируем в ext 4 наш диск \033[0m\n"
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3

echo -en "\033[37;1;41m Монтируем диск к папке \033[0m\n"
mount /dev/sda3 /mnt
mountpoint /mnt

echo -en "\033[37;1;41m Cоздадим несколько папок \033[0m\n"
mkdir /mnt/boot /mnt/home /mnt/var

echo -en "\033[37;1;41m Подключаем нашу загрузочную папку в загрузочный раздел bootable \033[0m\n"
mount /dev/sda1 /mnt/boot
mountpoint /mnt/boot

echo -en "\033[37;1;41m Установка системы Arch Linux ядро + софт который нам нужен сразу \033[0m\n"
pacstrap -K /mnt base linux linux-firmware linux-headers base-devel

echo -en "\033[37;1;41m Устанавливаем загрузчик \033[0m\n"
pacstrap /mnt grub-bios

echo -en "\033[37;1;41m Прописываем fstab \033[0m\n"
genfstab -p /mnt >> /mnt/etc/fstab

echo -en "\033[37;1;41m Создаем Install.sh \033[0m\n"
cat <<EOF>>/mnt/var/tmp/install.sh
#!/bin/bash

echo "Обновление репозиториев "
pacman -Sy

echo "Обновим ключики на всякий пожарный и установим важные пакеты "
pacman -Sy archlinux-keyring xorg xorg-server mate mate-extra sddm openssh --noconfirm

echo "Создаем файл о нашем железе "
mkinitcpio -p linux

printf 'root\nroot\n' | passwd

useradd -mg users -G wheel -s /bin/bash $USERNAME
printf '1002\n1002\n' | passwd $USERNAME

echo "it not beautiful "
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo "Добавим SUDO "
printf "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/$USERNAME

echo "Включаем экран логирования "
systemctl enable sddm

echo "Запускаем BASH Additional Settings "
sudo chmod +x /var/tmp/additional_settings.sh
systemctl enable additional_settings

echo "Запускаем BASH Additional Software "
sudo chmod +x /var/tmp/additional_software.sh
systemctl enable additional_software

echo "Запускаем BASH AUR "
sudo chmod +x /var/tmp/AUR.sh
systemctl enable aur

echo "Запускаем SSH "
systemctl enable sshd

echo "Создаем папку для AUR"
mkdir /var/tmp/AUR
chmod 0777 /var/tmp/AUR

exit
EOF

echo -en "\033[37;1;41m Создаём файл с сетевыми настройками \033[0m\n"
cat <<LAN>>/mnt/etc/systemd/network/static.network
[Match]
Name=enp*

[Network]
DHCP=yes
MulticastDNS=false

#DNS=192.168.1.1
#Address=192.168.1.3/24
#Gateway=192.168.1.1
PrimarySlave=true
LAN

echo -en "\033[37;1;41m Создаём файл Additional Settings \033[0m\n"
cat <<ADST>>/mnt/var/tmp/additional_settings.sh
#!/bin/bash

echo "Hostname"
hostnamectl set-hostname plex

echo "Подстрахуемся и включим повторно systemd-networkd"
systemctl enable systemd-networkd
systemctl start systemd-networkd

echo "Подстрахуемся и включим повторно systemd-resolved"
systemctl enable systemd-resolved
systemctl start systemd-resolved

echo "Обновим текущую локаль системы"
locale-gen
localectl set-locale LANG="ru_RU.UTF-8"
localectl set-locale LANG="en_US.UTF-8"

printf "KEYMAP=ru\n" >> /etc/vconsole.conf
printf "FONT=cyr-sun16\n" >> /etc/vconsole.conf
printf "LANG=ru_RU.UTF-8\n" > /etc/locale.conf

echo "Добавим подсветку синтаксиса в NANO"
printf 'include "/usr/share/nano/*.nanorc"' > ~/.nanorc

ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
ADST

echo -en "\033[37;1;41m Создаём файл Unit install additional_settings.sh \033[0m\n"
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

echo -en "\033[37;1;41m Создаём файл Additional software \033[0m\n"
cat <<ADSF>>/mnt/var/tmp/additional_software.sh
#!/bin/bash

echo "Устанавливаем дополнительные пакеты"
sudo pacman -S chromium git htop fuse nano --noconfirm
ADSF

echo -en "\033[37;1;41m Создаём файл Unit install additional_software.sh \033[0m\n"
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

echo -en "\033[37;1;41m Создаем файл с ПО из AUR и устанавливаем \033[0m\n"
cat <<AUR>>/mnt/var/tmp/AUR.sh
#!/bin/bash
path1=/var/tmp/AUR

echo "Идем в директорию"
cd "\$path1"
echo "\$path1"
echo -e "\n"

# Указываем названия пакетов с двойными ковычками
for var in "plex-media-server" "qbittorrent-nox" "tautulli" 
do
echo "Скачиваем $var"
git clone https://aur.archlinux.org/\$var.git
echo "Заходим в папку \$var"
cd "\$path1/\$var"
echo "Устанавливаем \$var"
yes | makepkg -sri
echo "Выходим из папки \$var"
cd ../
echo "Проверяем наше местоположение"
echo "\$path1"
echo -e "\n"

done
AUR

echo -en "\033[37;1;41m Создаём файл Unit install для AUR.sh \033[0m\n"
cat <<UAUR>>/mnt/etc/systemd/system/aur.service
[Unit]
Description=Start AUR
After=systemd-user-sessions.service

[Service]
ExecStart=/bin/bash '/var/tmp/AUR.sh'
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target reboot.target poweroff.target
UAUR

echo "Создаём файл Unit Plex Media Server"
cat <<PMS>>/mnt/etc/systemd/system/plex-media-server.service
[Unit]
Description=Plex Media Server
After=network.target

[Service]
EnvironmentFile=/etc/conf.d/plexmediaserver
ExecStart='/usr/lib/plexmediaserver/Plex\x20Media\x20Server'
Type=simple
User=root
Restart=on-failure
RestartSec=5
StartLimitInterval=60s
StartLimitBurst=3

[Install]
WantedBy=multi-user.target
PMS

echo "Создаём файл Unit qbittorrent-nox"
cat <<QBN>>/mnt/etc/systemd/system/qbittorrent-nox.service
[Unit]
Description=qBittorrent Daemon Service
After=network.target

[Service]
User=shardice
ExecStart=/usr/bin/qbittorrent-nox
ExecStop=/usr/bin/killall -w qbittorrent-nox

[Install]
WantedBy=multi-user.target
QBN

echo "Создаём файл Unit x11vnc"
cat <<QBN>>/mnt/etc/systemd/system/x11vnc.service
[Unit]
Description = 'VNC Server for X11'
Requires = display-manager.service
After = network-online.target
Wants = network-online.target
 
[Service]
ExecStart = /bin/bash -c "/usr/bin/x11vnc -auth /home/shardice/.Xauthority -display :0 -forever -loop -noxdamage -repeat -rfbport 5908 -rfbauth /home/$USERNAME/.vnc/passwd -shared"
ExecStop = /usr/bin/x11vnc -R stop
Restart = on-failure
RestartSec = 3 
 
[Install]
WantedBy = multi-user.target
QBN

echo -en "\033[37;1;41m Переход в новое окружение \033[0m\n"
chmod +x /mnt/var/tmp/install.sh
arch-chroot /mnt /var/tmp/install.sh

reboot
