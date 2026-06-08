#!/bin/zsh

# Asegurar que estamos en el directorio del script
cd "$(dirname "$0")"

echo "=== [1/4] Verificando estado de Colima (Entorno Docker) ==="

# Verificar si colima está instalado
if ! command -v colima &> /dev/null; then
    echo "❌ Colima no está instalado. Asegúrate de aprobar la instalación de Homebrew."
    exit 1
fi

# Verificar si colima está corriendo
if ! colima status &> /dev/null; then
    echo "🚀 Iniciando Colima..."
    colima start --cpu 2 --memory 2
else
    echo "✅ Colima ya está iniciado."
fi

# Asegurar que el socket de Docker esté configurado correctamente
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"

echo "\n=== [2/4] Construyendo imagen de Docker (arm64-asm-env) ==="
docker build -t arm64-asm-env .

echo "\n=== [3/4] Compilando con Make dentro del contenedor Linux ARM64 ==="
# Ejecutamos make sobrescribiendo las variables del compilador/enlazador y quitando QEMU, 
# ya que en el contenedor corre nativamente como Linux ARM64.
docker run --rm -v "$(pwd)":/workspace arm64-asm-env make AS=as LD=ld GCC=gcc QEMU="" clean all

echo "\n=== [4/4] Ejecutando programas compilados ==="
echo "\n--- Ejecutando hello (Syscalls) ---"
docker run --rm -v "$(pwd)":/workspace arm64-asm-env ./hello

echo "\n--- Ejecutando printf_example (Biblioteca estándar C) ---"
docker run --rm -v "$(pwd)":/workspace arm64-asm-env ./printf_example

echo "\n--- Ejecutando 10_str64 (Ejemplo 10) ---"
docker run --rm -v "$(pwd)":/workspace arm64-asm-env sh -c "./10_str64; echo 'Código de retorno: '\$?"

echo "\n--- Ejecutando suma_digitos ---"
# Mostramos el valor de retorno
docker run --rm -v "$(pwd)":/workspace arm64-asm-env sh -c "./suma_digitos; echo 'Código de retorno: '\$?"
