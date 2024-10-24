#!/bin/bash

# Comprobar si Docker ya está instalado
if ! [ -x "$(command -v docker)" ]; then
  echo "Docker no está instalado. Procediendo con la instalación..."
  
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

  echo "Docker se ha instalado correctamente."

else
  echo "Docker ya está instalado. Saltando la instalación."
fi

# Descargar la imagen de MongoDB 8.0 si no está descargada
if [[ "$(sudo docker images -q mongo:8.0 2> /dev/null)" == "" ]]; then
  echo "Descargando la imagen de MongoDB 8.0..."
  sudo docker pull mongo:8.0
else
  echo "La imagen de MongoDB 8.0 ya está descargada."
fi

# Preguntar al usuario la ruta donde quiere guardar los datos de MongoDB
echo "Por favor, introduce la ruta donde deseas almacenar los datos de MongoDB (ejemplo: /home/usuario/mongo_folder):"
read -r mongo_data_path

# Si la carpeta no existe, crearla
if [ ! -d "$mongo_data_path" ]; then
    echo "La carpeta no existe. Creándola ahora..."
    mkdir -p "$mongo_data_path"
fi

# Preguntar el puerto que desea utilizar (por defecto 2717)
echo "Por favor, introduce el puerto que deseas usar para MongoDB (por defecto: 2717):"
read -r mongo_port

# Asignar el puerto predeterminado si el usuario no ingresa uno
mongo_port=${mongo_port:-2717}

# Preguntar el nombre del contenedor (por defecto 'mymongo')
echo "Por favor, introduce el nombre del contenedor de MongoDB (por defecto: mymongo):"
read -r mongo_container_name

# Asignar el nombre predeterminado si el usuario no ingresa uno
mongo_container_name=${mongo_container_name:-mymongo}

# Crear el contenedor de MongoDB con los parámetros proporcionados
sudo docker run -d -p "$mongo_port":27017 -v "$mongo_data_path":/data/db --name "$mongo_container_name" mongo:8.0

# Confirmación de que el contenedor se está ejecutando
echo "MongoDB se está ejecutando en el puerto: $mongo_port y los datos se almacenan en: $mongo_data_path"
echo "Nombre del contenedor: $mongo_container_name"
sudo docker exec -it $mongo_container_name bash
