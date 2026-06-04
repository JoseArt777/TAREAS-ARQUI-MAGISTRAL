# Desarrollo en Ensamblador ARM64 (AArch64) en Linux

Este documento explica cómo recrear los entornos de desarrollo descritos en el video de **Kunusoft** titulado **"Five Arm64 Development Environments You Should Try for Assembly Programming"** (Cinco entornos de desarrollo de ARM64 que deberías probar para la programación en ensamblador) y cómo utilizar el entorno que ya tienes configurado en tu máquina local.

---

## 1. Los 5 Entornos Mencionados en el Video

El video de **Kunusoft** describe las siguientes 5 opciones para desarrollar en ensamblador ARM64:

1. **Hardware Real (p. ej. Raspberry Pi 5 / Orange Pi):** 
   * **Cómo funciona:** Se usa una computadora monoplaca (SBC) que tiene un procesador nativo ARM64 con un sistema operativo como Raspberry Pi OS. 
   * **Ventaja:** No requiere emulación; el código se ensambla, enlaza y ejecuta directamente de forma nativa.

2. **Emulación de Sistema Completo con QEMU:**
   * **Cómo funciona:** Se emula una máquina ARM64 completa (incluyendo el Kernel de Linux y la BIOS/Device Tree) dentro de tu PC con arquitectura x86_64.
   * **Ventaja:** Permite simular el sistema completo (drivers, controladores, sistema de archivos completo de la Raspberry Pi).

3. **UserLAnd en Android:**
   * **Cómo funciona:** Utiliza la aplicación *UserLAnd* en un dispositivo móvil Android para ejecutar una distribución Linux (como Arch o Debian) en modo de espacio de usuario.
   * **Ventaja:** Al ser la mayoría de los teléfonos modernos ARM64 nativos, puedes escribir y compilar código ensamblador directamente en tu teléfono sin emulación.

4. **Emulación a Nivel de Usuario con QEMU (en Arch Linux):**
   * **Cómo funciona:** Emulación de llamadas al sistema (Syscalls) usando `qemu-user` en un sistema Arch Linux. El compilador cruzado traduce el código y QEMU ejecuta solo el binario traduciendo las llamadas ARM64 a x86_64 al vuelo.

5. **Emulación a Nivel de Usuario con QEMU (en sistemas Debian/Ubuntu):**
   * **Cómo funciona:** Similar al punto anterior, pero utilizando las herramientas de Debian/Ubuntu (`gcc-aarch64-linux-gnu`, `qemu-user`).
   * **Es el método ideal para ti**, ya que tu máquina tiene instalado **Ubuntu 24.04 LTS (x86_64)**.

---

## 2. Tu Entorno Local Listo para Usar

Hemos verificado que **ya cuentas con las herramientas necesarias** instaladas en tu sistema:
- **Ensamblador cruzado:** `aarch64-linux-gnu-as`
- **Compilador cruzado (GCC):** `aarch64-linux-gnu-gcc`
- **Enlazador cruzado:** `aarch64-linux-gnu-ld`
- **Emulador de espacio de usuario:** `qemu-aarch64`

### Archivos de Ejemplo creados en tu espacio de trabajo:
1. **`hello.s`**: Código ensamblador puro que realiza llamadas al sistema (syscalls) directas de Linux para escribir en pantalla y salir.
2. **`printf_example.s`**: Código ensamblador que hace uso de la biblioteca estándar de C (`printf`) cargada de manera dinámica.
3. **`Makefile`**: Script de automatización para compilar y ejecutar fácilmente ambos archivos.

---

## 3. Instrucciones de Uso

Puedes manejar tu entorno desde la terminal en este directorio utilizando el `Makefile` provisto:

### A) Compilar todo:
Para generar los ejecutables `hello` y `printf_example`:
```bash
make
```

### B) Ejecutar los programas emulados:
Para correr el ejemplo de llamadas al sistema (`hello`):
```bash
make run_hello
```

Para correr el ejemplo que usa `printf` (`printf_example`):
```bash
make run_printf
```
> **Nota:** Para ejecutar programas que llaman a la biblioteca estándar de C, se usa `qemu-aarch64 -L /usr/aarch64-linux-gnu ./nombre_programa` para indicarle a QEMU dónde encontrar las bibliotecas dinámicas compiladas para ARM64.

### C) Limpiar archivos temporales:
Para borrar los ejecutables y archivos objeto `.o`:
```bash
make clean
```

---

## 4. Estructura de un Programa Ensamblador ARM64 (AArch64)

### Ejemplo 1: Llamadas al Sistema (Syscalls) en Linux (`hello.s`)
En ARM64, las llamadas al sistema se invocan colocando los argumentos en los registros `x0` a `x7`, el número de syscall en `x8`, y llamando a la instrucción `svc #0`:
* **Syscall `write` (64):** `write(fd, buf, count)`
  * `x0` = File descriptor (1 para stdout)
  * `x1` = Puntero a la cadena de texto
  * `x2` = Longitud de la cadena
  * `x8` = 64
* **Syscall `exit` (93):** `exit(status)`
  * `x0` = Código de salida (0 para éxito)
  * `x8` = 93

### Ejemplo 2: Uso de Funciones C (`printf_example.s`)
Si usas funciones de C, el enlazador/compilador configurará el punto de entrada en `main` en lugar de `_start`. Debes recordar:
* Guardar el *Frame Pointer* (`x29`) y el *Link Register* (`x30`) en la pila al inicio de la función y restaurarlos al salir (`stp` / `ldp`).
* El registro `x0` contiene el primer argumento (el formato de texto) y la instrucción `bl printf` realiza el salto.
