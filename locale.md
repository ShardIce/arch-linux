# Руссифицируем (Локализация) Arch-linux GUI
Запускаем консоль

Открываем файл `/etc/locale.gen`
```text
#  nano /etc/locale.gen
```      
Раскомментируем строку      
```text
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
```
> Нажми `CTRL+O` далее `Enter`, далее `CTRL+X`   

Генерируем локали
```text
# locale-gen  
```      
> Нажимаем `Enter`
      
Создаём файл `locale.conf`
```text
# nano /etc/locale.conf
```
Вводим
```text
LANG=ru_RU.UTF-8
```
> Нажми `CTRL+O` далее `Enter`, далее `CTRL+X`

Изменяем раскладку клавиатуры вводя в консоле
```text
#  nano /etc/vconsole.conf
```
Вводим
```
KEYMAP=ru
FONT=cyr-sun16
```
> Нажми `CTRL+O` далее `Enter`, далее `CTRL+X`   

делаем `reboot` системы и всё готово.
