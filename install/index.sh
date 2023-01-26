#!/bin/bash

function ping_lan {
clear
ping -c 3 8.8.8.8
}
function  ifconfig {
clear
/sbin/ifconfig
}
function meminfo {
clear
/bin/ cat /proc/meminfo
}
function start {
/bin/bash creating_settings.sh
}

#Создаем меню
function menu {
clear
echo
echo -e "\t\t\tМеню скрипта\n"
echo -e "\t1. Проверка наличия интернета"
echo -e "\t2. Старт чистой установки"
echo -e "\t3. Информация об интерфейсах"
echo -e "\t4. Информация о памяти"
echo -e "\t0. Выход"
echo -en "\t\tВведите номер раздела: "
read -n 1 option
}
#Используем цикл While и команду Case для создания меню.
while [ $? -ne 1 ]
do
        menu
        case $option in
0)
        break ;;
1)
        ping_lan ;;
2)
        start ;;
3)
        ifconfig ;;
4)
        meminfo ;;

*)
        clear
echo "Нужно выбрать раздел";;
esac
echo -en "\n\n\t\t\tНажмите любую клавишу для продолжения"
read -n 1 line
done
clear

curl -O https://raw.githubusercontent.com/ShardIce/arch-linux/master/install/install.sh
curl -O https://raw.githubusercontent.com/ShardIce/arch-linux/master/install/creating_settings.sh
