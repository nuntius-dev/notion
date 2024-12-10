#!/bin/bash

# Parte común de la URL
BASE_URL="https://github.com/notion-enhancer/notion-repackaged/releases/download/v2.0.18-1"
PACKAGE_NAME="notion-app-enhanced_2.0.18-1"
EXT=".deb"

# Detectar la arquitectura del sistema
ARCH=$(dpkg --print-architecture)

echo "Detectando arquitectura del sistema: $ARCH"

# Validar arquitectura y formar la URL completa
case "$ARCH" in
    amd64 | arm64)
        PACKAGE_URL="$BASE_URL/${PACKAGE_NAME}_${ARCH}${EXT}"
        ;;
    *)
        echo "Arquitectura no soportada: $ARCH"
        exit 1
        ;;
esac

# Descargar el paquete correspondiente
TEMP_DEB="/tmp/${PACKAGE_NAME}_${ARCH}${EXT}"
echo "Descargando el paquete desde $PACKAGE_URL ..."
wget -O "$TEMP_DEB" "$PACKAGE_URL"

# Verificar si la descarga fue exitosa
if [ $? -ne 0 ]; then
    echo "Error al descargar el paquete."
    exit 1
fi

# Instalar el paquete descargado
echo "Instalando el paquete..."
sudo dpkg -i "$TEMP_DEB"

# Resolver dependencias si es necesario
if [ $? -ne 0 ]; then
    echo "Resolviendo dependencias faltantes..."
    sudo apt-get install -f -y
fi

# Limpiar archivos temporales
echo "Limpiando archivos temporales..."
rm -f "$TEMP_DEB"

echo "Instalación de Notion Enhanced completada."
