#!/bin/bash

set +x

curl -O https://raw.githubusercontent.com/ShardIce/arch-linux/master/install/settings

./settings
echo "Подтянули настройки для $USERNAME"
