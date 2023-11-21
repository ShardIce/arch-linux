Если возникла ошибка Failed to set DNS configuration: Could not activate remote peer
```text
sudo systemctl enable --now systemd-resolved
```

Перед включением интерфейса wg0, разрешим серверу пересылать пакеты вперед.
Создадим и напишем в настройках sysctl /etc/sysctl.d/99-custom.conf или по адресу /etc/sysctl.conf
```text
# Включить IPv4-перенаправление
net.ipv4.ip_forward = 1

# Включить IPv6-перенаправление
net.ipv6.conf.all.forwarding = 1
Возможно после этих настроек сервер нужно будет перезагрузить, если не будет пинговаться ip wireguard.
```
