# Организация удаленного подключения по ssh
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
