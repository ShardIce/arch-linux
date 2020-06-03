# Руссифицируем (Локализация) Arch-linux GUI
Запускаем консоль

Вводим команду
```text
#  nano /etc/locale.gen
```      
> Нажми `CTRL+O` далее `Enter`, далее `CTRL+X`   
      
Редактируем файл `/etc/locale.gen`
> раскомментируй строку с ru_RU.UTF-8 UTF-8, после чего сгенерируй их введя команду:
```text
# locale-gen  
```      
> Нажми `CTRL+O` далее `Enter`, далее `CTRL+X`   
      
Создай файл `locale.conf`
```text
# nano /etc/locale.conf
```
Введи `LANG=ru_RU.UTF-8`
> Нажми `CTRL+O` далее `Enter`, далее `CTRL+X`

Изменяем раскладку клавиатуры
вводим в консоле
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
