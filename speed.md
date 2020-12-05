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
