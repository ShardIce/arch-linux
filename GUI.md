# Подготовка к установки GUI на Arch-linux
__Установки xorg-server__ `(download: 32.34MiB, total size: 56.06 MiB)`
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
__SDDM__ `(download: 21.50MiB, total size: 91.96 MiB)`
```text
# pacman -S sddm
```  
Я так и не смог выбрать и по этому прыгаю с одной на другую как надоедает.  
  
### Проверяем экранный менеджер на работоспасобность  
```text
# systemctl start sddm.service
```  
!Если установили обо для просмотра то просто ___lxdm___ заменить на ___sddm___ и посмотреть.  

Если сработало, то запускаем на _автоматическом режиме_
```text
# systemctl enable sddm.service
```
  
  
## Памятка
#### Установка `GUI` - Графический интерфейс
см. [GUI.md](GUI.md)
#### Локализация `GUI` - русификация графического интерфейса
см. [locale.md](locale.md)
#### Создаём `users` - заводим-пользователя
см. [install.md](install.md)
