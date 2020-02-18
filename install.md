# Подготовка системы для установки Arch-linux
#### Просматриваем зеркала
```text
#  ls /etc/pacman.d/mirrorlist
```
#### Добавляем заеркало
```text
# vim /etc/pacman.d/mirrorlist
``` 
нажимаем  
```text
i
```  
вводим  
```text
Server = https://mirror.23media.com/archlinux/$repo/os/$arch
```  
нажимаем "Esc"  
пишем  
```text
:wq
```
нажимаем "Enter"
> От слов Write и Quit. (Записать и выйти)
   
#### Разметка диска
```text
# cfdisk /dev/sda 
```
#### Создаем разделы 
- [X] /dev/sda1   
выбираем "***bootable***" из нижнего меню - загрузочный  
- [X] /dev/sda2   
выбираем "***type***" далее строка _82 Linux swap / Solatis_ - swap раздел  
- [X] /dev/sda3  
основной раздел куда будем ставить "***system***"  
_Далле заходим в пункт "**Write**" пишем "**yes**" и далее "**Quit**"_  
  
можно очистить окно командой 
```
# Clear
```
  
#### Далeе пишем команды для нормальной работы Linux
```text
# mkfs.ext4 /dev/sda1
# mkswap /dev/sda2
# swapon /dev/sda2
# mkfs.ext4 /dev/sda3
```
  
#### Монтируем наш основной раздел в папку /mnt
```text
# mount /dev/sda3 /mnt
```
#### Cоздадим несколько папок
```text
# mkdir /mnt/boot /mnt/home /mnt/var
```
>boot - загрузочный раздел

#### Подключаем нашу загрузочную папку в загрузочный раздел "bootable"
```text
# mount /dev/sda1 /mnt/boot
```
  \
  \
# Установка системы Arch Linux
```text
# pacstrap /mnt base linux linux-firmware
```
> так же можно установить сразу визуальную оболочку добавив название визуальной оболочки

#### Устанавливаем загрузчик
```text
# pacstrap /mnt grub-bios
```
Далее
```text
# genfstab -p /mnt >> /mnt/etc/fstab
```
  
Начинаем использование системы  
```text
# arch-chroot /mnt
```

#### Настройка времени и часовых поясов.  
Сделаем это в графическом интерфейсе, просто вводим команду.  
```text
# hwclock --systohc --utc
```
Создаем файл о нашем железе
```text
# mkinitcpio -p linux
```
задаем пароль для **Root** пользователя
```text
# passwd root
```
>new pass: root
>retype pass: root
>root - ваш пароль от суперюзера.
***НЕ ЗАБУДЬ СМЕНИТЬ ПАРОЛЬ ОТ СУПЕРПОЛЬЗОВАТЕЛЯ ПОСЛЕ УСТАНОВКИ!**

#### Заводим пользователя
```text
# useradd -mg users -G wheel -s /bin/bash dzsoft
```
### Устанавливаем пароль для пользователя которого завели
```text
# passwd shardice
```
new pass: ******
Retype pass: ******
>****** - ваш пароль \

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
