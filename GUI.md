# Подготовка к установки графичиского интерфейсф на Arch-linux
#### Установки xorg-server
```text
#  pacman -S xorg xorg-server
```

# Установка графичиского интерфейса на Arch-linux
Список интерфейсов можно посмотреть тут - `https://wiki.archlinux.org/index.php/Desktop_environment_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)`

```text
# pacman -S mate mate-extra (download: 0.0MiB, total size: 745.66 MiB)
# pacman -S gnome  (download: 257.45MiB, total size: 1365.03 MiB, New Upgrade Size: 1357.87 MiB)

# pacman -S nautilus (download: 0.0MiB, total size: 58.66 MiB) - выяснить что за херня

# pacman -S mate mate-extra (download: 284.78MiB, total size: 975.86 MiB)

# pacman -S xfce4 `(download: 7.71MiB, total size: 44.89 MiB) - шустрая и прикольная`
```
`я выбрал МАТЕ`

#### Добавляем заеркало
```text
# vim /etc/pacman.d/mirrorlist
``` 
