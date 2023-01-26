#!/bin/bash
set +x

read -e -p "Введите имя: " USERNAME
echo "Было введено имя: " $USERNAME

echo "Выберите страну репозиториев:"
select COUNTRY in "AR" "AU" "AT" "AZ" "BD" "BY" "BE" "BA" "BR" "BG" "KH" "CA" "CL" "CN" "CO" "HR" "CZ" "DK" "EC" "EE" "FI" "FR" "GE" "DE" "GR" "HK" "HU" "IS" "IN" "ID" "IR" "IE" "IL" "IT" "JP" "KZ" "KE" "LV" "LT" "LU" "MX" "MD" "MC" "NL" "NC" "NZ" "MK" "NO" "PK" "PY" "PL" "PT" "RO" "RU" "RE" "RS" "SG" "SK" "SI" "ZA" "KR" "ES" "SE" "CH" "TW" "TH" "TR" "UA" "GB" "US" "UZ" "VN"
do
  echo "Вы выбрали страну репозиториев: " $COUNTRY
  break
done

echo "Введите версию IP протокола IPv4 или IPv6"
select IP_VERSION in "4" "6"
do
  echo "Ваша версия IP протокола: IPv"$IP_VERSION
  break
done

echo "Введите протокол http или https:"

do
  echo "Ваша версия протокола:" $PROTOCOL
  break
done

cat <<SET>./settings
#!/bin/bash

USERNAME=$USERNAME

# Актуальне зеркала
COUNTRY=$COUNTRY
IP_VERSION=$IP_VERSION
PROTOCOL=$PROTOCOL
SET

/bin/bash install.sh
