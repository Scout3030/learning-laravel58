#!/bin/bash

echo "Configurar el .env"
cp .env.example .env

MYSQL_DATABASE=${2:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 5 ; echo '')}
MYSQL_USERNAME=${2:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 5 ; echo '')}
MYSQL_PASSWORD=${2:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo '')}

echo "Establecer database mysql"
sed -i "/DB_DATABASE=/c\DB_DATABASE=LEARNING$MYSQL_DATABASE" .env

echo "Establecer usuario mysql"
sed -i "/DB_USERNAME=/c\DB_USERNAME=USR$MYSQL_USERNAME" .env

echo "Establecer contraseña mysql"
sed -i "/DB_PASSWORD=/c\DB_PASSWORD=$MYSQL_PASSWORD" .env

echo "Establecer conexion a db"
sed -i "/DB_HOST=/c\DB_HOST=db" .env

echo "Construir los contenedores"
docker-compose build app

echo "Poner en funcionamiento"
docker-compose up -d

echo "Instalar composer"
docker-compose exec app composer install

echo "Generar llaves"
docker-compose exec app php artisan key:generate

# echo "Linkear storage"
# docker-compose exec app php artisan storage:link

echo "Correr migraciones"
docker-compose exec app php artisan migrate

