# Организация удаленного подключения по ssh по паролю
Установка пакета openssh
```text
#  pacman -S openssh
```     
Запуск демона openssh
```text
#  systemctl start sshd.service
```
Проверка состояния демона openssh
```text
#  systemctl status sshd.service
```
Настройка автозапуска демона openssh
```text
#  systemctl enable sshd.service
```
#### Доступ из под Root'a
Теперь открываем настройки SSH:
```text
# nano /etc/ssh/sshd_config
```
Теперь открываем настройки SSH:
```text
# PermitRootLogin yes
```
Перезапускаем демона openssh
```text
#  systemctl restart sshd.service
```


# Организация удаленного подключения по ssh по ключу
#### Обновить ключи 
```text
# pacman -S archlinux-keyring
```
#### Обновить систему
```text
# pacman -Syu
```

#### Создал файл **`authorized_keys`** папке `~/.ssh/ `
```text
# nano ~/.ssh/authorized_keys
```
> Сгенерировать публичный ключ для ssh
> У каждой OS свои ПО и способы генерации ключей.

Поместил ключи в `authorized_keys` и сохранил файл
затем нажимаем ```Ctrl+O``` затем ```Enter```
Выходим из блокнота
```Ctrl+X```

Linux
Для локальной машины:
```text
# chmod 700 ~/.ssh
# chmod 600 ~/.ssh/ `keys`
```
Для удаленной машины:
```text
# chmod 700 ~/.ssh
# chmod 600 ~/.ssh/authorized_keys
```

>Windows - **Указал права. (Для форточки по умолчанию на чтение стоит)**

где `authorized_keys` - название файла c публичными ключами в данном случаи
ssh-ed25519 AAAAC3NzaC1lZDI1N-------------------DyIDT+/vi3BfS+LLsmFOBKBRV shardice

Перезапускаем демона openssh
```text
#  systemctl restart sshd
```
Включаем юнит
```text
# systemctl  enable sshd
```
Проверил логирование ssh
```text
# journalctl -f -u sshd
```
