# Автоматическое монтирование диска
Просмотрим что у нас примонтировано и узнаем UUID диска. 
Вводим любую команду:
```text
lsblk -f
```
или
```text
sudo blkid
```

#### Указываем UUID в системе, для монтирования после перезапуска системы
```text
sudo nano /etc/fstab
```
Вводим строку
```text
UUID=8efc5d95-54b9-4bad-a33a-ae0b8*******               /home/media/         ext4            rw,relatime     0 3
```
> UUID - это ID вашего диска.
> /home/media/ - это путь к папки куда монтируется </br>
> ext4 - файловая система
> rw - read/write.
> relatime - обновляет время доступа
> 0 - 
> 3 - порядок проверки файловой системы во время загрузки

нажимаем "**CTRL**"+"**O**", затем "**Enter**" и выйти "**CTRL**"+"**X**"

# Автоматическое монтирование сетевого диска через systemd

Вводим:
```text
nano /etc/systemd/system/mnt-scratch.automount
```

Вставляем:
```text
[Unit]
Description=Automount Scratch

[Automount]
Where=/mnt/scratchПерезапус

[Install]
WantedBy=multi-user.target
```

Создаем второй файл:
```text
cat /etc/systemd/system/mnt-scratch.mount
```
Вставляем:
```text
[Unit]
Description=Scratch

[Mount]
What=nfs.example.com:/export/scratch
Where=/mnt/scratch
Type=nfs

[Install]
WantedBy=multi-user.target
```

Перезапускаем службы:
```text
systemctl deamon-reload
```
