# Arch-linux
первым делом добавляем заеркало \
ls /etc/pacman.d/mirrorlist 
нажимаем a \
 *vim /etc/pacman.d/mirrorlist*
 
нажимаем 
**i**

вводим \
**Server = https://mirror.23media.com/archlinux/$repo/os/$arch** \
нажимаем "Esc" \
пишем :wq \
> От слов Write и Quit. (Записать и выйти)
 
Разметка диска \
# cfdisk /dev/sda 

Разделы \
# /dev/sda1 выбираем "bootable" из нижнего меню - загрузочный \
# /dev/sda2 выбираем "type" далее строка 82 Linux swap / Solatis - swap раздел \
# /dev/sda3 основной раздел куда будем ставить "system" \ 
Далле заходим в пункт "Write" пишем "yes" и далее "Quit" \

// можно очистить окно командой "Clear" \

Далeе пишем команды для нормальной работы Linux \
**mkfs.ext4 /dev/sda1**
**mkswap /dev/sda2**
**swapon /dev/sda2**
**mkfs.ext4 /dev/sda3**

Теперь монтируем наш основной раздел в папку /mnt \
**mount /dev/sda3 /mnt**

Теперь создадим несколько папок \
**mkdir /mnt/boot /mnt/home /mnt/var**
boot - загрузочный раздел

подключаем нашу загрузочную папку в загрузочный раздел "bootable" \ 
# mount /dev/sda1 /mnt/boot

далее установка системы Arch Linux \
# pacstrap /mnt base linux linux-firmware

так же можно установить сразу визуальную оболочку добавив название визуальной оболочки

устанавливаем загрузчик (посмотреть какой загрузчик есть ещё и почему именно grub) \
pacstrap /mnt grub-bios

Далее \
genfstab -p /mnt >> /mnt/etc/fstab

Начинаем использование системы \
arch-chroot /mnt


не заморачиваемся с настройкой времени и часовых поясов. \
Сделаем это в графическом интерфейсе, просто вводим команду. \
hwclock --systohc --utc

Создаем файл о нашем железе
mkinitcpio -p linux
 

задаем пароль для Root пользователя
passwd root
new pass: root
retype pass: root

Заводим пользователя
useradd -mg users -G wheel -s /bin/bash dzsoft

Устанавливаем пароль для пользователя которого завели
passwd shardice
new pass: 1002
Retype pass: 1002

устанавливаем загрузчик на hdd
grub-install /dev/sda

устанавливаем конфигурационный файл для нашего загрузчика
grub-mkconfig -o /boot/grub/grub.cfg

сделаем хост
hostnamectl set-hostname имя хоста

проверка IP
ip addr

ПОДСТРАХОВКА для дальнейшей работы.
проверяем установлен ли сетевой интерфейс
pacman -Qs dhcpcd

Если нет, то устанавливаем/переустанавливаем сетевой интервейс
pacman -S dhcpcd 
затем нажимаем Y и ввод

выходим из chroot командой 
exit

включаем сетевые интерфейсы для доступа в интернет
systemctl enable dhcpcd

запускаем сетевые интерфейсы
systemctl start dhcpcd

Перезагружаемся
reboot

после перезагрузки вводим логин и пароль Root или созданного пользователя.
далее проводим тест рабюоты сетевого интерфейса



Установка системы закончина без графического интерфейса
