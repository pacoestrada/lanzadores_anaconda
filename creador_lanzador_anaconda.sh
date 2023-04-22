#!/bin/bash

# URL de la imagen del icono
ICON_URL="https://drive.google.com/uc?id=1kUqXG_wiTjL5R8QVAyXrBtgYNsAUAaxM"

# Cuadro de diálogo de bienvenida
zenity --info --title="Bienvenido" --text="Bienvenido al creador de lanzador para Anaconda Navigator" --width=300

# Obtén el nombre de usuario y la ruta de instalación de Anaconda
USERNAME=$(whoami)
ANACONDA_PATH=$(which conda | sed 's/\/bin\/conda//g')

# Verifica si Anaconda está instalado
if [ -z "$ANACONDA_PATH" ]; then
  zenity --error --text="Anaconda no está instalado en tu sistema. Por favor, instálalo antes de ejecutar este script."
  exit 1
fi

# Cuadro de diálogo para confirmar el nombre de usuario
zenity --question --title="Nombre de usuario" --text="¿Es $USERNAME tu nombre de usuario?" --width=300
if [ $? -ne 0 ]; then
  zenity --error --text="El nombre de usuario no coincide. Por favor, verifica tu nombre de usuario y vuelve a intentarlo."
  exit 1
fi

# Cuadro de diálogo para confirmar la ruta de instalación de Anaconda
zenity --question --title="Ruta de instalación de Anaconda" --text="La ruta de instalación de Anaconda es:\n$ANACONDA_PATH\n¿Es correcto?" --width=300
if [ $? -ne 0 ]; then
  zenity --error --text="La ruta de instalación de Anaconda no es correcta. Por favor, verifica la ruta de instalación y vuelve a intentarlo."
  exit 1
fi

# Descarga y guarda el icono en la carpeta de imágenes del usuario
ICON_FOLDER="/home/$USERNAME/imagenes"
mkdir -p "$ICON_FOLDER"
wget -O "$ICON_FOLDER/anaconda_logo.png" "$ICON_URL"

# Crea el archivo .desktop
DESKTOP_FILE_CONTENT="[Desktop Entry]
Version=1.0
Type=Application
Name=Anaconda Navigator
GenericName=Anaconda
Comment=Launch Anaconda Navigator
Exec=bash -c 'export PATH=\"$ANACONDA_PATH/bin:$PATH\" && anaconda-navigator'
Icon=$ICON_FOLDER/anaconda_logo.png
Terminal=false
Categories=Development;Science;IDE;
StartupWMClass=Anaconda Navigator"

echo "$DESKTOP_FILE_CONTENT" > anaconda-navigator.desktop

# Copia el archivo .desktop a las ubicaciones correspondientes
cp anaconda-navigator.desktop ~/Desktop/
chmod +x ~/Desktop/anaconda-navigator.desktop
sudo cp anaconda-navigator.desktop /usr/share/applications/
rm anaconda-navigator.desktop

# Cuadro de diálogo de éxito
zenity --info --title="Éxito" --text="Lanzador de Anaconda Navigator creado en el escritorio y el menú de aplicaciones." --width=300
