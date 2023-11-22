# Генерация приватного ключа
privkey=$(wg genkey)

# Генерация публичного ключа из приватного
pubkey=$(echo "$privkey" | wg pubkey)

echo "Приватный ключ: $privkey"
echo "Публичный ключ: $pubkey"
