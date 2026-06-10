# Resumen de Entornos y Programación en Ensamblador ARM64 (AArch64)

Este documento recopila de manera detallada el contenido de la serie de 5 videos sobre el desarrollo de entornos y la programación en ensamblador ARM64 (AArch64), basándose en las transcripciones provistas.

---

## Índice
1. [Video 1: Entornos de Desarrollo para ARM64](#video-1-entornos-de-desarrollo-para-arm64)
2. [Video 2: Configuración y Uso de Raspberry Pi Connect](#video-2-configuración-y-uso-de-raspberry-pi-connect)
3. [Video 3: Instrucciones de Carga (Load), Almacenamiento (Store) y Directivas](#video-3-instrucciones-de-carga-load-almacenamiento-store-y-directivas)
4. [Video 4: Llamadas al Sistema (Syscalls) y Operaciones de Memoria (Ejemplos 10 al 15)](#video-4-llamadas-al-sistema-syscalls-y-operaciones-de-memoria-ejemplos-10-al-15)
5. [Video 5: Operaciones Aritméticas, Lógicas y de Datos (Ejemplos 16 al 23)](#video-5-operaciones-aritméticas-lógicas-y-de-datos-ejemplos-16-al-23)
6. [Video 6: Comparaciones, Condiciones Compuestas y Estructuras Condicionales (Ejemplos 24 al 27)](#video-6-comparaciones-condiciones-compuestas-y-estructuras-condicionales-ejemplos-24-al-27)

---

## Video 1: Entornos de Desarrollo para ARM64

Este video introduce **cinco entornos diferentes** para compilar y ejecutar código ensamblador ARM64 (AArch64), desde hardware real hasta emulación de espacio de usuario.

### El Programa de Prueba común (`test.s`)
En todos los entornos se utiliza el mismo programa mínimo de prueba para verificar que el ensamblador y el enlazador funcionan correctamente. Este programa retorna el valor `5` al sistema operativo.

```assembly
// test.s
.global _start

_start:
    mov x0, 5      // Registro x0 almacena el código de retorno (5)
    mov x8, 93     // Registro x8 almacena el número de la syscall 'exit' (93)
    svc 0          // Supervisor Call (System Call) para salir
```

#### Comandos de Compilación y Ejecución (Nativos)
```bash
# 1. Ensamblar el código fuente (.s) a objeto (.o)
as test.s -o test.o

# 2. Enlazar el objeto (.o) a un archivo ejecutable
ld test.o -o test

# 3. Ejecutar y consultar el valor de retorno en terminal
./test; echo $?
# Salida esperada: 5
```

---

### Los 5 Entornos Explicados

| Entorno | Descripción / Requisitos | Comandos Clave |
| :--- | :--- | :--- |
| **1. Hardware Real (Raspberry Pi 5)** | Ejecución nativa directa sobre la arquitectura ARM64 con Raspberry Pi OS (versión Trixie). | `as test.s -o test.o` <br> `ld test.o -o test` |
| **2. Emulación de Sistema Completo (QEMU)** | Emula una máquina ARM64 completa. Descarga la imagen oficial de Raspberry Pi OS Legacy Light 64-bit, archivos DTB y kernel. | `xz -d image.img.xz` <br> `qemu-img resize image.img 4G` <br> `qemu-system-aarch64 [parámetros]` |
| **3. Android (UserLAnd)** | App de Android para ejecutar distribuciones Linux (como Arch Linux o Debian) en espacio de usuario sin root. | Uso de la app *UserLAnd* de la Play Store. Edición con `nano test.s` y compilación nativa en el móvil. |
| **4. QEMU User Space (Arch Linux)** | Emulación rápida que solo ejecuta binarios compilados de manera cruzada traducidos al vuelo. | `pacman -S aarch64-linux-gnu-binutils qemu-user` <br> `aarch64-linux-gnu-as test.s -o test.o` <br> `qemu-aarch64 ./test` |
| **5. QEMU User Space (Debian / Ubuntu)** | Similar al de Arch Linux, utilizando el compilador cruzado y utilidades del ecosistema Debian. | `apt install binutils-aarch64-linux-gnu qemu-user` <br> `aarch64-linux-gnu-as test.s -o test.o` <br> `qemu-aarch64 ./test` |

---

## Video 2: Configuración y Uso de Raspberry Pi Connect

**Raspberry Pi Connect** es un servicio que proporciona acceso remoto seguro y gratuito a la Raspberry Pi desde un navegador web a través de internet, sin necesidad de configurar VPNs o redireccionamiento de puertos (ideal para IoT).

### Proceso de Configuración paso a paso

1. **Crear una Cuenta de ID de Raspberry Pi:**
   * Acceder al sitio web de software de Raspberry Pi y buscar la sección de **Raspberry Pi Connect**.
   * Hacer clic en *Sign in* y registrar un ID nuevo utilizando correo electrónico, contraseña, nombre de usuario y confirmando el correo electrónico de verificación recibido.
2. **Instalar el Paquete en la Raspberry Pi:**
   * Acceder localmente a la Raspberry Pi (físicamente o vía SSH).
   * Actualizar el sistema e instalar el servicio:
     ```bash
     sudo apt update && sudo apt upgrade
     sudo apt install rpi-connect
     ```
3. **Vincular el Dispositivo:**
   * Ejecutar el comando para iniciar sesión desde la terminal de la Raspberry Pi:
     ```bash
     rpi-connect signin
     ```
   * Copiar el enlace provisto por el comando y pegarlo en la barra de direcciones de un navegador.
   * Asignar un nombre al dispositivo (por ejemplo, `Raspberry Pi 5`).
4. **Métodos de Acceso Remoto desde el Navegador:**
   * **Compartir Pantalla (Screen Sharing):** Permite ver y controlar el entorno de escritorio completo de manera rápida y fluida en pantalla completa.
   * **Shell Remoto (Remote Shell):** Abre una terminal interactiva en el navegador donde se pueden ejecutar comandos directamente.

---

## Video 3: Instrucciones de Carga (Load), Almacenamiento (Store) y Directivas

Este video profundiza en la estructura del código, la compilación alternativa mediante GCC, herramientas de inspección como `objdump`, y el uso de instrucciones de carga (`LDR`) y almacenamiento (`STR`).

### Conceptos Clave de Compilación y Diagnóstico
* **Uso de GCC:** Se puede compilar código ensamblador con `gcc`. Como `gcc` espera el punto de entrada llamado `main` (en lugar de `_start`), para usar `_start` se debe pasar el parámetro `-nostartfiles`:
  ```bash
  aarch64-linux-gnu-gcc -nostartfiles test.s -o test
  ```
* **Uso de `objdump`:** Permite desensamblar y examinar el binario.
  * `objdump -d <ejecutable>`: Muestra las instrucciones desensambladas paso a paso.
  * `objdump -s <ejecutable>`: Muestra el contenido completo del ejecutable con su representación en hexadecimal de las secciones.
* **Automatización con Scripts:** Se crean scripts de Bash (`asld` y `asldec` / `adec`) para automatizar el ensamblado, enlazado, ejecución y limpieza opcional.

---

### Explicación de los Ejemplos del Video 3

#### Ejemplo 02: Directiva `EQU`
La directiva `.equ` (o simplemente `EQU`) asigna una constante simbólica a una etiqueta. No consume memoria en ejecución, el ensamblador la sustituye por su valor.
```assembly
.equ max, 100
.global _start
_start:
    mov x0, max    // x0 = 100
    mov x8, 93
    svc 0
```

#### Ejemplo 03 y 04: Alineación de Memoria (`.align` y `.balign`)
ARM64 requiere que las instrucciones y datos estén alineados (usualmente a 16 bytes) para optimizar el rendimiento de la CPU.
* `.align 4`: Utiliza potencias de dos ($2^4 = 16$ bytes).
* `.balign 16`: Especifica directamente la alineación en bytes (16 bytes).
* Si hay desalineación, el ensamblador rellena los bytes restantes con instrucciones `NOP` (no operación), que se observan al inspeccionar con `objdump -d`.

#### Ejemplo 05: Carga Directa desde Arreglo (`LDR`)
Acceso directo a la primera posición de un arreglo en memoria usando un puntero.
```assembly
.data
a: .word 1, 2, 3   // Arreglo 'a' con tres enteros de 32 bits (4 bytes cada uno)

.text
.global _start
_start:
    ldr x1, =a     // Carga la dirección base del arreglo 'a' en x1 (puntero)
    ldr w0, [x1]   // Carga el contenido de la dirección en x1 en w0 (valor 1)
    mov x8, 93
    svc 0
```

#### Ejemplo 06: Direccionamiento con Desplazamiento (Offset)
Acceder a elementos subsiguientes del arreglo sumando un desplazamiento en bytes sin modificar el registro base.
* Nota: Al ser datos de tipo `.word` (4 bytes cada uno), el índice 2 del arreglo (valor `3`) se encuentra en el desplazamiento de 8 bytes ($2 \times 4$ bytes).
```assembly
    ldr x1, =a
    ldr w0, [x1, #8]  // Carga el elemento en la dirección (x1 + 8 bytes) -> valor 3
```

#### Ejemplo 07: Almacenamiento en Memoria (`STR`)
Permite escribir valores de los registros a variables ubicadas en la sección de datos no inicializados (`.bss`).
```assembly
.data
a: .word 10

.bss
b: .space 8        // Reserva 8 bytes de espacio no inicializado

.text
.global _start
_start:
    ldr x1, =a
    ldr w2, [x1]   // w2 = 10
    ldr x3, =b     // x3 = dirección de b
    str w2, [x3]   // Almacena el valor de w2 en la dirección de x3 (b = 10)
    
    ldr w0, [x3]   // Retorna el valor de b en w0 para comprobar con echo
    mov x8, 93
    svc 0
```

#### Ejemplo 08: Trabajo con Cadenas y ASCII
Permite cargar caracteres individuales manipulando el desplazamiento y usando registros de menor tamaño (`w` en lugar de `x`).
* Se almacena una cadena de texto `.string "ola"`.
* Para extraer la letra `'a'`, se aplica un desplazamiento de 3 bytes (las posiciones son `'o'` en 0, `'l'` en 1, `'a'` en 2... wait, la transcripción indica que el desplazamiento es 3 o 2? En "ola", `'o'`=0, `'l'`=1, `'a'`=2. Si usamos desplazamiento 3, estaríamos cargando el carácter nulo `\0` de terminación de cadena si es "ola". No obstante, la transcripción indica un desplazamiento de 3 o se inicializa con otra palabra. Verificaremos el ASCII devuelto que es `97` para `'a'`).
* Para guardar se usa `str w2, [x3]` con un registro de tamaño medio.

#### Ejemplo 09: Operaciones a Nivel de Byte (`STRB` / `LDRB`)
Cuando se trabaja con tipos de datos `.byte` (1 byte), se utilizan las instrucciones correspondientes para evitar sobreescribir memoria contigua:
* `strb w2, [x1]`: Guarda únicamente el byte menos significativo en la dirección apuntada.
* `echo $?` en la terminal solo puede mostrar valores en el rango de un byte (de 0 a 255).

---

## Video 4: Syscalls y Operaciones de Memoria (Ejemplos 10 al 15)

Este video presenta scripts automatizados de ejecución cruzada con QEMU User y una serie de ejemplos prácticos sobre llamadas al sistema, asignación dinámica de memoria y operaciones aritméticas básicas.

### El Script de Automatización `asld`
Se utiliza este script para emular programas ejecutando la compilación cruzada y llamando a `qemu-aarch64`:
```bash
#!/usr/bin/env bash
# Ensambla, enlaza, ejecuta y limpia
aarch64-linux-gnu-as $1.s -o $1.o
aarch64-linux-gnu-ld $1.o -o $1
qemu-aarch64 ./$1; echo $?
rm $1.o $1
```

---

### Explicación de los Ejemplos del Video 4

#### Ejemplo 10: Intercambio / Copia de Valores de 64 bits (`10_str64.s`)
Carga el contenido de la variable `B` y lo almacena en la dirección de la variable `A`.
* Carga direcciones de `A` y `B` en `x1` y `x2` respectivamente.
* Carga el valor en la dirección de `B` en un registro y lo almacena en la dirección de `A` usando `str`.

#### Ejemplo 11: Syscall de Escritura en Pantalla (`11_print.s`)
Uso de la llamada al sistema `write` (Syscall 64 en ARM64) para imprimir un mensaje en `stdout` (descriptor de archivo 1).
* **Parámetros:**
  * `x0`: File descriptor (1 = stdout)
  * `x1`: Dirección del buffer de texto
  * `x2`: Longitud en bytes (14 en este caso)
  * `x8`: Número de Syscall (64)
  * `svc 0`: Ejecución de llamada al sistema.
* Retorna `0` en `x0` para finalizar correctamente.

#### Ejemplo 12: Lectura de Teclado y Búfer (`12_read.s`)
Uso de la llamada al sistema `read` (Syscall 63 en ARM64) para capturar datos ingresados por el usuario.
* **Parámetros de lectura:**
  * `x0`: File descriptor (0 = stdin)
  * `x1`: Dirección del buffer de 16 bytes
  * `x2`: Tamaño del buffer (16)
  * `x8`: Código de Syscall (63)
* **Peligro:** Si el usuario ingresa una cadena mayor al tamaño del buffer (16 bytes), el excedente queda en el flujo de entrada estándar, provocando que se intente interpretar por la terminal tras finalizar el programa, causando errores.

#### Ejemplo 13: Asignación Dinámica de Memoria con `brk` (`13_brk.s`)
La syscall `brk` (Syscall 214 en ARM64) se utiliza para mover el límite del segmento de datos (heap pointer).
1. Se invoca `brk` con valor `0` (null) en `x0` para obtener la dirección actual de memoria disponible.
2. Se incrementa dicha dirección en 4 bytes (tamaño de un entero).
3. Se invoca `brk` nuevamente con la dirección incrementada en `x0` para solicitar y reservar formalmente el espacio de memoria.
4. Se escribe un valor (por ejemplo, `100`) en la dirección de memoria reservada y luego se lee para retornarlo.

#### Ejemplo 14: Suma de un Valor Inmediato (`14_add_imm.s`)
Suma un valor constante a un registro usando la instrucción `add`.
* Carga un valor en `x0` con `mov`.
* Suma un inmediato directamente: `add x0, x0, 100` y retorna el resultado.

#### Ejemplo 15: Suma y Negación de un Arreglo (`15_add_array.s`)
Suma elementos de un arreglo y calcula su valor absoluto/negativo.
* Declara un arreglo `a` con valores `-1`, `-2` y `-3`.
* Carga la dirección con `adr x0, a`.
* Carga los tres elementos usando desplazamientos de byte: `0` (posición 0), `4` (posición 1), `8` (posición 2) en los registros `x1`, `x2` y `x3`.
* Suma todos los elementos en `x0` (`-1 + -2 + -3 = -6`).
* Invoca la instrucción `neg x0, x0` para invertir el signo del valor, devolviendo el resultado positivo `6`.

---

## Video 5: Operaciones Aritméticas, Lógicas y de Datos (Ejemplos 16 al 23)

Este video detalla operaciones aritméticas avanzadas, manipulación de bits, operaciones lógicas y la emulación de operaciones no nativas en ARM64.

### Explicación de los Ejemplos del Video 5

#### Ejemplo 16: Complemento a dos con `NEG` (`16_complement.s`)
La instrucción `neg` calcula el complemento a dos de un registro (invierte el signo algebraico).
* Carga el valor negativo `-180` en `x1`.
* Ejecuta `neg x0, x1`. El resultado almacenado en `x0` es el positivo `180`.

#### Ejemplo 17: Prueba de Paridad con Bitwise `AND` (`17_oddand.s`)
Determina si un número es par o impar aislando el bit menos significativo (LSB).
* Carga el valor `33` (impar) en `x1`.
* Aplica `and x0, x1, 1`. Si el bit 0 está encendido (valor 1), el número es impar; si es 0, es par.
* El valor de retorno es `1` confirmando que es impar.

#### Ejemplo 18: Control de Sensores con Bitwise `ORR` (`18_sensororr.s`)
Fusiona y actualiza estados de sensores utilizando una operación OR lógica a nivel de bits.
* `x1` almacena el estado inicial de sensores: `10010` en binario (18 decimal).
* `x2` recibe la lectura de sensores adicionales: `1001` en binario (9 decimal).
* `orr x0, x1, x2` realiza la operación lógica OR bit por bit.
* Resultado final en `x0`: `10111` binario (23 decimal), consolidando todos los indicadores activos.

#### Ejemplo 19: División con Desplazamiento a la Derecha `LSR` (`19_divlsr.s`)
El desplazamiento lógico a la derecha de $N$ bits equivale a una división entera por $2^N$.
* Carga el número octal `7400` en `x1` (que equivale al entero decimal `3840`).
* Aplica `lsr x0, x1, 4` (desplaza 4 bits a la derecha, dividiendo por $2^4 = 16$).
* Resultado: $3840 / 16 = 240$.

#### Ejemplo 20: Multiplicación con Desplazamiento Variable a la Izquierda `LSLV` (`20_mullsl.s`)
El desplazamiento lógico a la izquierda equivale a multiplicar por una potencia de 2. La versión `LSLV` utiliza un registro en lugar de un inmediato para determinar el número de bits a desplazar.
* Carga `32` en `x1` (número base).
* Carga `2` en `x2` (número de posiciones de desplazamiento, indicando multiplicar por $2^2 = 4$).
* `lslv x0, x1, x2` realiza la multiplicación variable.
* Resultado en `x0`: `128` ($32 \times 4$).

#### Ejemplo 21: Enmascaramiento y Limpieza de bits con `AND` / `MOVZ` / `MOVK` (`21_cleanand.s`)
Muestra cómo cargar enteros de 32 bits de longitud y cómo usar una máscara binaria para limpiar secciones de un registro.
* `mov` carga los 16 bits inferiores.
* `movz` con desplazamiento de 16 bits inicializa y borra los bits restantes.
* `movk` (Move Keep) modifica 16 bits específicos sin alterar el resto del registro.
* Aplica una máscara de bits `FF` mediante la instrucción `and x0, x1, x2` para aislar los bits deseados.
* Resultado: `204` en decimal (correspondiente al byte `0xCC` en hexadecimal).

#### Ejemplo 22: Multiplicación de 32 bits con Registros `W` (`22_mul32.s`)
Uso de la instrucción `mul` limitando la operación a un ancho de palabra de 32 bits mediante la nomenclatura de registros `W` (mitad menos significativa del registro `X`).
* Carga direcciones y valores de dos variables globales `word1` y `word2` de tipo `.word`.
* Realiza la multiplicación: `mul w0, w2, w3` (o registros equivalentes corregidos).
* El uso de registros de 32 bits ayuda a evitar desbordamientos inesperados y trunca el resultado a la sección baja deseada (retorna `255` o byte `0xFF`).

#### Ejemplo 23: Operación de Módulo en ARM64 (`23mod.s`)
ARM64 no tiene una instrucción nativa directa para calcular el módulo ($x \pmod n$). Se implementa recreando matemáticamente la fórmula: $\text{módulo} = x - (n \times \text{div\_entera}(x, n))$.
1. Carga el dividendo $x = 10$ en `x0` y el divisor $n = 3$ en `x1`.
2. Realiza la división entera con signo: `sdiv x2, x0, x1` ($10 / 3 = 3$).
3. Multiplica el divisor por el resultado entero: `mul x2, x2, x1` ($3 \times 3 = 9$).
4. Resta el producto obtenido del dividendo original: `sub x2, x0, x2` ($10 - 9 = 1$).
5. Mueve el resultado a `x0` para retornarlo.
* Resultado obtenido: `1`.

---

## Video 6: Comparaciones, Condiciones Compuestas e IF (Ejemplos 24 al 27)

Este video explica cómo hacer comparaciones en ARM64, leer las banderas del procesador (`nzcv`), evaluar varias condiciones juntas con AND y simular un `if` con saltos condicionales (`branch`).

### Explicación de los Ejemplos

#### Ejemplo 24: Comparación y banderas NZCV (`24_compare.s`)
Compara `10` y `20` con `cmp x1, x2` (que resta $10-20$ activando banderas). Pasa el registro `nzcv` a `x0` con `mrs` y lo desplaza 28 bits a la derecha (`lsr`). Como da negativo, se activa la bandera N y retorna `8` en decimal.

#### Ejemplo 25: Condición compuesta doble (`25_compound.s`)
Verifica si `15` está en el rango entre `10` y `20`. Compara `15 > 10` guardando el resultado en `x3` con `cset gt` y `15 < 20` guardando en `x4` con `cset lt`. Junta ambas con un `and` en `x0` para retornar `1` (verdadero).

#### Ejemplo 26: Condición compuesta triple (`26_compound_triple.s`)
Igual al anterior, pero añade una tercera comparación para ver si `15` es diferente de `15` usando `cset x6, ne`. Al juntar las tres condiciones con `and`, retorna `0` (falso) porque no son diferentes. Si se cambia `x3` a `20`, sí retorna `1`.

#### Ejemplo 27: Sentencia condicional - IF (`27_if.s`)
Simula un `if` de manera eficiente negando la condición: compara `10` y `5` con `cmp x0, x1` y salta al final si es menor (`b.lt endif`). Como no es menor, hace la suma y retorna `15`. Si cambiamos `x1` a `15`, el salto se cumple y retorna el `10` original.


