# Ускоряем загрузку  
#### Отключаем загрузку GRUB  
```text
# sudo nano /boot/grub/grub.cfg
```
Ищем строку 
`### END /etc/grub.d/00_header ###` 
и чуть выше строка
```set timeout=5```
меняем на 
```set timeout=0```

```text
# sudo pacman -S lightdm
```
 
Total Download Size:   0.20 MiB
Total Installed Size:  1.91 MiB
