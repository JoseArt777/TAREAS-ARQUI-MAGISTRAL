#!/bin/bash

# 1. Verificar si Colima está corriendo
if ! colima status &>/dev/null; then
    echo " Colima no está corriendo. Iniciando Colima..."
    colima start
else
    echo "Listo, Colima ya está en ejecución."
fi

# 2. Asegurar que la imagen de Docker existe (usará caché si ya está construida)
echo "🐳 Verificando/Construyendo imagen de Docker..."
docker build -t entorno-arm64 . -q

# 3. Entrar al contenedor
echo "💻 Entrando al entorno Linux ARM64... (Escribe 'exit' para salir)"
docker run -it -v $(pwd):/workspace entorno-arm64 /bin/bash
