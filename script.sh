#!/bin/bash

echo "Configurar el .env"
cp .env.example .env

read -p "¿Establecer nuevas variables mysql en .env?' [Y/n]: " optiona
if [[ $optiona =~ ^[Yy]$ ]]
then
    MYSQL_DATABASE=${1:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 5 ; echo '')}
    MYSQL_USERNAME=${2:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 5 ; echo '')}
    MYSQL_PASSWORD=${3:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo '')}

    echo "Establecer database mysql"
    sed -i "/DB_DATABASE=/c\DB_DATABASE=learning${MYSQL_DATABASE,,}" .env

    echo "Establecer usuario mysql"
    sed -i "/DB_USERNAME=/c\DB_USERNAME=usr${MYSQL_USERNAME,,}" .env

    echo "Establecer contraseña mysql"
    sed -i "/DB_PASSWORD=/c\DB_PASSWORD=${MYSQL_PASSWORD,,}" .env
fi

echo "Establecer conexion a db"
sed -i "/DB_HOST=/c\DB_HOST=db" .env

read -p "¿Construir conenedores?' [Y/n]: " optionb
if [[ $optionb =~ ^[Yy]$ ]]
then
    echo "Construir los contenedores"
    docker-compose build app
fi

read -p "¿Poner en funcionamiento conenedores?' [Y/n]: " optionc
if [[ $optionc =~ ^[Yy]$ ]]
then
    echo "Poner en funcionamiento"
    docker-compose up -d
fi

echo "Instalar composer"
docker-compose exec app composer install

echo "Dar permisos al storage"
docker-compose exec app chmod -R 777 storage

echo "Generar llaves"
docker-compose exec app php artisan key:generate

echo "Linkear storage"
docker-compose exec app php artisan storage:link

echo "Crear migraciones"
docker-compose exec app php artisan migrate

read -p "¿Crear seeds?' [Y/n]: " optiond
if [[ $optiond =~ ^[Yy]$ ]]
then
    docker-compose exec app php artisan db:seed
fi

docker-compose ps


