#!/bin/bash

# Запитуємо ім'я контейнера
read -p "Введіть ім'я Docker-контейнера: " container_name
read -p "Введіть порт ноди сток (17690): " node_port

# Створення директорії /elixir/, якщо її ще немає
mkdir -p /elixir/

# Створюємо файл env з ім'ям контейнера
env_file="/elixir/${container_name}.env"

# Запитуємо дані у користувача
read -p "Введіть STRATEGY_EXECUTOR_DISPLAY_NAME для $container_name: " display_name
read -p "Введіть STRATEGY_EXECUTOR_BENEFICIARY (адресу каманця) для $container_name: " beneficiary
read -p "Введіть SIGNER_PRIVATE_KEY для $container_name (без 0x): " private_key

# Записуємо дані у файл env
cat <<EOL > $env_file
ENV=testnet-3

STRATEGY_EXECUTOR_DISPLAY_NAME=$display_name
STRATEGY_EXECUTOR_BENEFICIARY=$beneficiary
SIGNER_PRIVATE_KEY=$private_key
EOL

echo "Файл $env_file створено!"

# Запускаємо Docker-контейнер
docker run --env-file $HOME/elixir/$env_file --name $container_name --platform linux/amd64 --restart always -p $node_port:$node_port elixirprotocol/validator:v3

echo "Docker-контейнер $container_name запущено!"
echo "Port $node_port"
echo "MM $beneficiary "
echo "Validator name $display_name"