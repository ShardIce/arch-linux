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
    



    

 
