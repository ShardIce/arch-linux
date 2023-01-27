#!/bin/bash

mkdir /var/tmp/clear_install/
curl -o /var/tmp/clear_install/install.sh https://raw.githubusercontent.com/ShardIce/arch-linux/master/install/clear_install/install.sh
curl -o /var/tmp/clear_install/creating_settings.sh https://raw.githubusercontent.com/ShardIce/arch-linux/master/install/clear_install/creating_settings.sh

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
clear
/bin/bash /clear_install/creating_settings.sh
}
function start_uefi {
clear
echo "раздел в раззработке"
}

#Создаем меню
function menu {
clear
echo
echo -e "\t\t\tМеню скрипта\n"
echo -e "\t1. Проверка наличия интернета"
echo -e "\t2. Старт чистой установки BIOS"
echo -e "\t3. Старт чистой установки UEFI"
echo -e "\t4. Информация об интерфейсах"
echo -e "\t5. Информация о памяти"
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
        start_uefi ;;
4)
        ifconfig ;;
5)
        meminfo ;;

*)
        clear
echo "Нужно выбрать раздел";;
esac
echo -en "\n\n\t\t\tНажмите любую клавишу для продолжения"
read -n 1 line
done
clear
