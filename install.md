# Arch-linux
добавляем заеркало \
```text \
#  ls /etc/pacman.d/mirrorlist
```
нажимаем a \
```text
# vim /etc/pacman.d/mirrorlist*
``` 
нажимаем 
**i**

вводим \
**Server = https://mirror.23media.com/archlinux/$repo/os/$arch** \
нажимаем "Esc" \
пишем :wq \
> От слов Write и Quit. (Записать и выйти)
 
Разметка диска \
```text
# cfdisk /dev/sda 
```
Разделы \
> /dev/sda1 выбираем "bootable" из нижнего меню - загрузочный \
> /dev/sda2 выбираем "type" далее строка 82 Linux swap / Solatis - swap раздел \
> /dev/sda3 основной раздел куда будем ставить "system" \ 

Далле заходим в пункт "Write" пишем "yes" и далее "Quit" \

// можно очистить окно командой "Clear" \

Далeе пишем команды для нормальной работы Linux \
```text
# mkfs.ext4 /dev/sda1
# mkswap /dev/sda2
# swapon /dev/sda2**
# mkfs.ext4 /dev/sda3**
```
 \
Теперь монтируем наш основной раздел в папку /mnt \
```text
# mount /dev/sda3 /mnt**
```
Теперь создадим несколько папок \
```text
# mkdir /mnt/boot /mnt/home /mnt/var**
```
>boot - загрузочный раздел

подключаем нашу загрузочную папку в загрузочный раздел "bootable" \ 
```text
# mount /dev/sda1 /mnt/boot
```
далее установка системы Arch Linux \
```text
# pacstrap /mnt base linux linux-firmware
```
так же можно установить сразу визуальную оболочку добавив название визуальной оболочки

устанавливаем загрузчик (посмотреть какой загрузчик есть ещё и почему именно grub) \
```text
# pacstrap /mnt grub-bios
```
Далее \
```text
# genfstab -p /mnt >> /mnt/etc/fstab
```
Начинаем использование системы \
```text
# arch-chroot /mnt
```

не заморачиваемся с настройкой времени и часовых поясов. \
Сделаем это в графическом интерфейсе, просто вводим команду. \
```text
# hwclock --systohc --utc
```
Создаем файл о нашем железе
```text
# mkinitcpio -p linux
```
задаем пароль для Root пользователя
```text
# passwd root
```
>new pass: root
>retype pass: root
>root - ваш пароль от суперюзера.
>> не забудьте сменить после установки!

Заводим пользователя
```text
# useradd -mg users -G wheel -s /bin/bash dzsoft
```
Устанавливаем пароль для пользователя которого завели
```text
# passwd shardice
```
>new pass: 0000
>Retype pass: 0000
> 0000 - ваш пароль \

устанавливаем загрузчик на hdd
```text
# grub-install /dev/sda
```
устанавливаем конфигурационный файл для нашего загрузчика
```text
# grub-mkconfig -o /boot/grub/grub.cfg
```
сделаем хост
hostnamectl set-hostname имя хоста

проверка IP
```text
# ip addr
```
ПОДСТРАХОВКА для дальнейшей работы.
проверяем установлен ли сетевой интерфейс
```text
# pacman -Qs dhcpcd
```
Если нет, то устанавливаем/переустанавливаем сетевой интервейс
pacman -S dhcpcd 
затем нажимаем Y и ввод

выходим из chroot командой 
```text
# exit
```
включаем сетевые интерфейсы для доступа в интернет
```text
# systemctl enable dhcpcd
```
запускаем сетевые интерфейсы
```text
# systemctl start dhcpcd
```
Перезагружаемся
```text
# reboot
```
после перезагрузки вводим логин и пароль Root или созданного пользователя.
далее проводим тест рабюоты сетевого интерфейса



Установка системы закончина без графического интерфейса
