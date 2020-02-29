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
  
  
## Устанавливаем экранный менеджер, с помощью него мы будем логиниться  
__LXDM__ `(download: 11.73MiB, total size: 69.04 MiB)`
```text
# pacman -S lxdm 
``` 
или
__SDDM__ `(download: 24.17MiB, total size: 104.74 MiB)`
```text
# pacman -S sddm
```  
Я так и не смог выбрать и по этому прыгаю с одной на другую как надоедает.  
  
### Проверяем экранный менеджер на работоспасобность  
```text
# systemctl start lxdm.service
```  
!Если установили обо для просмотра то просто ___lxdm___ заменить на ___sddm___ и посмотреть.  

Если сработало, то запускаем на _автоматическом режиме_
```text
# systemctl enable lxdm.service
```

#### Создать `users`
см. [install.md#заводим-пользователя](заводим-пользователя)
