# Ускоряем загрузку  
#### Отключаем загрузку GRUB  
```text
# sudo nano /boot/grub/grub.cfg
```
Ищем строку 
`### END /etc/grub.d/00_header ###` 
и чуть выше строки
```set timeout=5```
меняем на 
```set timeout=0```

#### Убираем зависание загрузки SDDM
Удалить файл `.Xauthority`
> Не перезагружаясь выйти из сеанса и опять авторизоваться.

# Ускоряем систему
#### Вводим команду
```text
# sudo su
```

#### Ограничиваем систему в записи логов
```text
# journalctl --vacuum-size=30M
# journalctl --veryfy
```

#### Ограничиваем систему в записи логов
```text
# nano /etc/systemd/journald.conf
```
#### Редактируем строки и удаляем символ решётки
```text
# SystemMaxUse=30M
# SystemMaxFileSize=20M
```
#### Ускоряем выгрузку програм из оперативной памяти
```text
# sysctl -w vm.vfs_cache_pressure=1000
# echo "vm.vfs_cache_pressure=1000" >> /etc/sysctl.d/99-sysctl.conf
```
> 
#### Перезагружаемся
```text
# reboot
```
   
# Удаление старых пакетов из кэша
#### Удалит кеш пакетов, оставив последние версии
```text
# pacman -Scc
```
#### Удалит кеш всех пакетов
```text
# pacman -Sc
```
#### Автоматизация процесса чистки
Устанавливаем Cron и добавляем юнит
```text
# sudo pacman -S cronie
# sudo systemctl enable cronie.service
```
#### Редактируем Cron
```text
# sudo EDITOR=nano crontab -e
```
#### Добавляем правило
```text
10 10 * * sun /sbin/rm /var/cache/pacman/pkg/*
```
> Нажимаем Ctrl+o, Enter,Ctrl+x.

# Удаление не используюемых пакетов
```text
sudo pacman -Rsn $(pacman -Qdtq)
```
> удаляет пакеты-сироты (которые не используются ни одной программой)

