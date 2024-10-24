#!/bin/bash

# Actualiza el sistema
sudo apt update

# Instala paquetes necesarios para permitir que apt utilice repositorios HTTPS
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Añade la clave GPG del repositorio oficial de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Añade el repositorio de Docker a las fuentes de apt
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Actualiza el sistema nuevamente para que apt reconozca el nuevo repositorio
sudo apt update

# Asegurarse de que el punto de instalación de Docker esté disponible
apt-cache policy docker-ce

# Instalar Docker
sudo apt install docker-ce -y

# Descargar la imagen de MongoDB 8.0
sudo docker pull mongo:8.0

# Preguntar al usuario la ruta donde quiere guardar los datos de MongoDB
echo "Por favor, introduce la ruta donde deseas almacenar los datos de MongoDB (ejemplo: /home/usuario/mongo_folder):"
read -r mongo_data_path

# Si la carpeta no existe, crearla
if [ ! -d "$mongo_data_path" ]; then
    echo "La carpeta no existe. Creándola ahora..."
    mkdir -p "$mongo_data_path"
fi

# Crear un contenedor de MongoDB en segundo plano (-d) en el puerto 2717 (mapeando a 27017 en el contenedor por defecto)
# Los datos se guardarán en la ruta indicada por el usuario.
sudo docker run -d -p 2717:27017 -v "$mongo_data_path":/data/db --name mymongo mongo:8.0

# Confirmación de que el contenedor se está ejecutando
echo "MongoDB se está ejecutando y los datos se almacenan en: $mongo_data_path"
