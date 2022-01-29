1. mount /dev/sda3 /mnt # монтируем корень системы
2. mount /dev/sda1 /mnt/boot # монтируем boot раздел.
3. arch-chroot /mnt # чрутимся в образ
4. pacman -Syu linux # обновить систему и переустановить ядро
5. exit # выйти из чрута
6. umount /mnt/boot # отмонтировать бут раздел.
7. umount /mnt # отмонтировать основной раздел
