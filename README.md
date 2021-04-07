# ARCHIVO CONFIGURACIÓN

- Correr script, no crear variables nuevamente. Si las migraciones no se crean, correr dos veces el script.
- Las variables del .env se cargan en el docker-file.

## Levantar proyecto con docker

### Conceder permisos 
````
chmod +x script.sh
````

### Correr script
````
./script.sh
````
## Comandos importantes

### Listar contenedores
````
docker-compose ps -f name=learnig*
````

### Ver logs en nginx
````
docker-compose logs nginx
````

### Eliminar contenedores
````
docker ps -f name=learnig* -q | xargs docker rm -f
````

<br>  
Más información en: 

[Digital Ocean Tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-set-up-laravel-with-docker-compose-on-ubuntu-20-04)

