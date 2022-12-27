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
