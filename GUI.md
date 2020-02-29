# Подготовка к установки GUI на Arch-linux
#### Установки xorg-server
```text
#  pacman -S xorg xorg-server
```

# Установка GUI на Arch-linux
Список интерфейсов можно посмотреть тут - https://wiki.archlinux.org/index.php/Desktop_environment  
Бегло рассмотрел эти  
  
__MATE__ `(download: 284.78MiB, total size: 975.86 MiB)`  
```text
# pacman -S mate mate-extra 
```  
__GNOME__ `(download: 257.45MiB, total size: 1365.03 MiB, New Upgrade Size: 1357.87 MiB)`
```text
# pacman -S gnome  
```  
__XFCE4__ `(download: 7.71MiB, total size: 44.89 MiB) - шустрая`
```text
# pacman -S xfce4 
```  


я выбрал __МАТЕ__ для последующего изучения, ибо там для начала есть всё необходимое.

#### Устанавливаем графичиский вход, спомощью него мы будем логиниться 
```text
# pacman -S lxdm 
``` 
`(download: 11.73MiB, total size: 69.04 MiB)`
или
```text
# pacman -S sddm 
```
`(download: 24.17MiB, total size: 104.74 MiB)`

Я так и не смог выбрать и по этому прыгаю с одной на другую как надоедает.

#### проверяем на работоспасобность окошко логирования
```text
# systemctl start lxdm.service
```
Если сработало, то запускаем на автоматическом режиме

```text
# systemctl enable lxdm.service
```
! ___lxdm___ можно заменить на ___sddm___ (если установили) и посмотреть.
