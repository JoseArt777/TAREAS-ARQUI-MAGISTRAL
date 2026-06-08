# Cuestionario Resuelto: Ensamblador ARM64 (AArch64) y Entornos de Desarrollo

Este documento recopila las preguntas consultadas en esta sesión junto con sus respectivas respuestas y explicaciones técnicas detalladas basadas en los archivos de tu espacio de trabajo (`TAREAS-ARQUI-MAGISTRAL`).

---

## 1. Direccionamiento, Offsets y Secciones de Memoria

### **¿Cuántos bytes de offset tiene aplicada la instrucción `ldr` de direccionamiento en el ejemplo 5?**
* **Respuesta:** **0 bytes** (o **8 bytes** si se refiere al Ejemplo 6).
* **Explicación:** En el archivo `05_ldr.s` la instrucción es `ldr w0, [x1]`, la cual accede directamente a la dirección base. En el archivo `06_ldroffset.s` (Ejemplo 6), se utiliza un offset de 8 bytes mediante `ldr x0, [x1, x2]` con `x2 = 8`.

### **¿Cuántos bytes de offset tiene aplicada la instrucción `ldr x2...` en el ejemplo 8?**
* **Respuesta:** **3 bytes**.
* **Explicación:** La instrucción del archivo `08_ascii.s` es `ldr x2, [x1, #3]`, lo que aplica un offset inmediato de `#3`.

### **¿Cuántos bytes de offset tiene aplicada la instrucción `str` de direccionamiento en el ejemplo 7?**
* **Respuesta:** **0 bytes** (o **e. Ninguna es correcta** si el valor `0` no figuraba entre las opciones numéricas).
* **Explicación:** La instrucción en `07_str.s` es `str x2, [x3]`, la cual escribe directamente en la dirección apuntada sin ningún desplazamiento.

### **¿Cuántos bytes de offset tiene aplicada la instrucción `strb w2...` en el ejemplo 8?**
* **Respuesta:** **0 bytes**.
* **Explicación:** En `08_ascii.s`, la instrucción es `strb w2, [x3]`, operando directamente sobre la dirección en `x3`.

### **¿Cuántos bytes de offset tiene aplicada la instrucción `ldrb w0...` en el ejemplo 10?**
* **Respuesta:** **0 bytes**.
* **Explicación:** La instrucción en `10_str64.s` es `ldrb w0, [x1]`.

### **¿Cuántos bytes de offset tiene aplicada la instrucción `str x3...` en el ejemplo 10?**
* **Respuesta:** **0 bytes**.
* **Explicación:** La instrucción en `10_str64.s` es `str x3, [x1]`.

### **¿Cuántos bytes de offset tiene aplicada la instrucción `ldr x0...` en el ejemplo 8?**
* **Respuesta:** **0 bytes**.
* **Explicación:** La instrucción en `08_ascii.s` es `ldr x0, [x3]`.

### **¿Cuántas secciones tiene declaradas el ejemplo 7?**
* **Respuesta:** **3 secciones**.
* **Explicación:** El archivo `07_str.s` declara explícitamente las secciones **`.data`**, **`.bss`** y **`.text`**.

---

## 2. Tamaños de Datos y Alineación de Memoria

### **¿Cuántos bytes están declarados en el segmento data del ejemplo 12?**
* **Respuesta:** **14 bytes**.
* **Explicación:** Contiene la cadena `msg: .ascii "Enter a text: "`. Al ser `.ascii`, no se añade un byte nulo al final, por lo que ocupa exactamente sus 14 caracteres.

### **¿Cuántos bytes están declarados en el segmento data del ejemplo 9?**
* **Respuesta:** **1 byte**.
* **Explicación:** El archivo `09_byte.s` declara únicamente `a: .byte 0`.

### **¿Cuántos bytes están declarados en el segmento data del ejemplo 8?**
* **Respuesta:** **9 bytes**.
* **Explicación:** Declara `a: .word 0` (4 bytes) y `s: .string "hola"` (5 bytes en total, contando los 4 caracteres más el terminador nulo `\0` que añade automáticamente la directiva `.string`).

### **¿Cuántos bytes están declarados en el segmento data del ejemplo 15?**
* **Respuesta:** **12 bytes**.
* **Explicación:** Declara `a: .word -1, -2, -3` (3 enteros de 32 bits $\times$ 4 bytes cada uno).

### **¿En el ejemplo 15, si cada elemento del arreglo ocupa 4 bytes y el primer elemento se encuentra en el desplazamiento 0, qué desplazamiento en bytes corresponde al tercer elemento?**
* **Respuesta:** **8 bytes**.
* **Explicación:** El primer elemento `a[0]` está en offset `0`, el segundo `a[1]` en `4` y el tercero `a[2]` en `8` (representado en la instrucción `ldr x3, [x0, #8]`).

### **¿A cuántos bytes está alineado data y text el ejemplo 3?**
* **Respuesta:** **4 bytes** (según el archivo físico `03_align.s`) o **16 bytes** (según el resumen del video si se asume la directiva `.align 4`).
* **Explicación:** El archivo `03_align.s` no contiene directivas explícitas, por lo que usa la alineación por defecto de 4 bytes. Sin embargo, en el resumen de los videos, el Ejemplo 3 se asocia con el uso de `.align 4` (donde $2^4 = 16$ bytes).

### **¿Cuántos bytes de alineación se obtienen mediante .balign 16?**
* **Respuesta:** **16 bytes**.
* **Explicación:** La directiva `.balign` toma la alineación de forma directa en bytes, por lo que `.balign 16` alinea exactamente a un múltiplo de 16 bytes.

---

## 3. Comportamiento de Código y Operaciones Aritmético-Lógicas

### **Considerando el ejemplo 22, si en lugar de multiplicar se divide, ¿qué valor imprime echo en la ejecución?**
* **Respuesta:** **255** (usando registros de 32 bits `W` del código original) o **1** (si se cambiaran a registros de 64 bits `X`).
* **Explicación:** 
  * Con registros de 32 bits: `w2` (0xFFFFFFFF) / `w4` (0x00000001) = `0xFFFFFFFF`. La terminal interpreta los 8 bits menos significativos del código de salida devuelto, imprimiendo `255`.
  * Con registros de 64 bits: `x2` / `x4` = `65,793` (`0x10101`). Los 8 bits menos significativos corresponden a `0x01` (`1`).

### **Considerando el ejemplo 21, ¿por cuál instrucción se puede sustituir and para que deje en x0 el mismo valor?**
* **Respuesta:** **e. ANDS X0, X1, X2**.
* **Explicación:** La instrucción `ands` realiza la misma operación lógica AND bit por bit que `and`, la única diferencia es que además actualiza las banderas de estado del procesador (N, Z, C, V), dejando el valor idéntico en `x0`.

### **En el ejemplo 17, ¿qué valor en base 10 tendría x0, si inmediatamente antes de las dos instrucciones de salida se colocan mov x2, -1 y and x0, x1, x2?**
* **Respuesta:** **33**.
* **Explicación:** Dado que `x2` toma el valor de `-1` (todos los bits en `1`), hacer un AND lógico de `x1` (`33`) con todos los bits en uno da como resultado el mismo número `33` ($33 \text{ AND } -1 = 33$).

### **Del video 5. En el ejemplo de limpieza de registros se utiliza una máscara hexadecimal FF para conservar únicamente el byte menos significativo. Si el valor original fuera hexadecimal 0xA1B2C3D4, ¿qué valor decimal quedaría después de aplicar la máscara?**
* **Respuesta:** **212**.
* **Explicación:** Al aplicar la máscara `0xFF` sobre `0xA1B2C3D4` queda únicamente `0xD4`. Convirtiendo `D4` hexadecimal a decimal: $(13 \times 16) + 4 = 208 + 4 = 212$.

### **Del video 5. En el ejemplo del sensor se parte del estado binario 10010 y se combina mediante ORR con el valor binario 101. ¿Cuál es el resultado decimal obtenido después de la fusión de ambos estados?**
* **Respuesta:** **23**.
* **Explicación:** `10010` OR `00101` = `10111` binario. Convirtiéndolo a decimal: $16 + 4 + 2 + 1 = 23$.

### **En el ejemplo 16, ¿qué valor en base 10 tendría x0, si inmediatamente antes de las dos instrucciones de salida se coloca la instrucción lsl, x0, x0, 4?**
* **Respuesta:** **2880**.
* **Explicación:** Al principio `x0` toma el valor absoluto de `-180` (que es `180`). Aplicar `lsl x0, x0, 4` equivale a multiplicar por $2^4 = 16$. Por tanto, $180 \times 16 = 2880$.

### **Del video 5. Si en lugar de desplazar el valor octal 7400 cuatro posiciones a la derecha se desplazara únicamente tres posiciones mediante LSR, ¿cuál sería el resultado decimal final?**
* **Respuesta:** **480**.
* **Explicación:** El valor octal `07400` equivale a `3840` en decimal. Un desplazamiento lógico a la derecha de 3 posiciones equivale a una división entre $2^3 = 8$. Por tanto, $3840 / 8 = 480$.

### **Si se ingresara al registro x2 el valor 65535 en el ejemplo 9, ¿qué valor imprime echo?**
* **Respuesta:** **255**.
* **Explicación:** `65535` equivale a `0xFFFF`. Al guardarlo en memoria con `strb`, solo se almacena el byte menos significativo (`0xFF`), que en decimal es `255`. Este valor se recupera y se devuelve al salir del programa.

### **En el ejemplo 16, ¿qué valor en base 10 tendría x0, si inmediatamente antes de las dos instrucciones de salida se coloca la instrucción lsr, x0, x0, 4?**
* **Respuesta:** **11**.
* **Explicación:** `x0` inicia valiendo `180`. La instrucción `lsr x0, x0, 4` hace una división entera entre $16$. El resultado entero truncado es $180 / 16 = 11$.

### **Del video 5. Tomando el procedimiento utilizado para calcular el módulo, si x=37 y n=5, ¿qué valor debería quedar finalmente en el registro de retorno después de realizar división entera, multiplicación y resta?**
* **Respuesta:** **2**.
* **Explicación:** Se emula la operación módulo: $37 \pmod 5 = 37 - (5 \times (37 / 5)) = 37 - 35 = 2$.

---

## 4. Gestión de Memoria Dinámica (`brk`)

### **En el ejemplo 13, ¿cuál llamada a brk libera lo agregado del segmento data?**
* **Respuesta:** **b. ninguna es correcta**.
* **Explicación:** En el archivo `13_brk.s` solo ocurren dos llamadas a `brk`: la primera consulta la dirección del límite de memoria y la segunda la extiende. Ninguna llamada en el programa libera memoria dinámica.

### **En el ejemplo 13, ¿cuál llamada a brk solicita ampliar el segmento data?**
* **Respuesta:** **a. segunda**.
* **Explicación:** La segunda llamada a la syscall `brk` (214) le pasa una dirección de memoria incrementada en 4 bytes (`actual + 4`) para reservar ese espacio en el heap.

---

## 5. Directivas del Ensamblador y Comandos

### **¿Qué hace la directiva `.global`?**
* **Respuesta:** **d. Hace visible la etiqueta de entrada para el enlazador.**
* **Explicación:** Declara un símbolo como de alcance global para que el enlazador (`ld`) pueda localizarlo fuera del archivo objeto, definiendo típicamente el punto de entrada `_start`.

### **¿Cuál es el parámetro de OBJ-DUMP para visualizar la secciones de una archivo ejecutable utilizado en el ejemplo 1?**
* **Respuesta:** **c. s**.
* **Explicación:** El comando `objdump -s` (o `--full-contents`) se utiliza para mostrar el contenido completo de todas las secciones del ejecutable y su representación hexadecimal.

### **En el ejemplo 11 la cadena está definida como asciz, donde asciz asigna el caracter fin de cadena o 0, ¿no debería tener un largo 15 para imprimir?**
* **Respuesta:** **c. Ninguna es correcta**.
* **Explicación:** No es necesario. La llamada al sistema `write` escribe exactamente la cantidad de bytes que le pases en el registro `x2` (que es 14, correspondientes a los caracteres imprimibles). El byte de terminación nulo `\0` no necesita ser impreso en la terminal.

### **En el ejemplo 23, ¿de qué forma podemos ahorrarnos la instrucción mov que está antes de las dos instrucciones de salida?**
* **Respuesta:** **f. en la instrucción sub rd debe ser x0**.
* **Explicación:** Modificando el registro de destino de `sub` para que sea `x0` (`sub x0, x0, x2`) en lugar de `x2` (`sub x2, x0, x2`), el resultado se almacena directamente en el registro de retorno, eliminando la necesidad de hacer un `mov` posterior.

### **¿Qué directiva se utilizó para definir constantes en el ejemplo 2?**
* **Respuesta:** **d. equ**.
* **Explicación:** Se utiliza la directiva `.equ` para asignar un valor simbólico a una etiqueta (por ejemplo, `.equ MAX, 100`).

### **Del video 3. ¿Cuántos bytes ocupa una instrucción ARM64 según el texto?**
* **Respuesta:** **4 bytes** (32 bits).

---

## 6. Entornos de Desarrollo y Raspberry Pi Connect

### **Del video de entornos. Respecto al flujo GNU mostrado en Raspberry Pi, ¿cuál es la secuencia correcta de transformación del programa?**
* **Respuesta:** **b. Fuente → objeto → ejecutable**.
* **Explicación:** El código fuente (`.s`) se ensambla a un archivo objeto (`.o`) y este último se enlaza para producir el archivo ejecutable final.

### **Del video de entornos. ¿Cuál es la principal diferencia conceptual entre QEMU completo y QEMU-USER según la explicación presentada?**
* **Respuesta:** **e. QEMU-USER emula espacio de usuario y no el sistema completo**.
* **Explicación:** QEMU completo emula la máquina entera, incluyendo hardware, BIOS y el núcleo de Linux. QEMU-USER traduce las instrucciones del binario y sus llamadas al sistema directamente al espacio de usuario de la arquitectura anfitriona sin emular hardware completo.

### **¿Con qué comando se redimensiona una imagen de Raspberry Pi OS?**
* **Respuesta:** **d. qemu-img**.
* **Explicación:** Se utiliza la herramienta `qemu-img` con la sintaxis `qemu-img resize imagen.img 4G`.

### **¿Con qué comando se ejecuta un binario emulado de ARM64 en el espacio de usuario?**
* **Respuesta:** **e. qemu-aarch64**.
* **Explicación:** Es la herramienta de emulación de espacio de usuario utilizada para ejecutar los ejecutables de ARM64 en sistemas x86_64.

### **Del video de RPI Connect. Considerando el caso descrito, ¿por qué resulta relevante que la Raspberry Pi tenga SSH habilitado?**
* **Respuesta:** **c. Facilita la configuración inicial y ejecución de comandos locales.**
* **Explicación:** SSH permite la conexión por línea de comandos remota para llevar a cabo la instalación inicial del paquete (`rpi-connect`) y su posterior emparejamiento.

### **Del video de RPI Connect. Si un usuario puede acceder a Screen Sharing desde cualquier lugar, ¿qué requisito lógico sigue siendo indispensable?**
* **Respuesta:** **d. Que el dispositivo mantenga conectividad funcional.**
* **Explicación:** Dado que la conexión viaja a través del servicio de internet de Raspberry Pi Connect, el dispositivo a controlar debe estar conectado a la red.

### **¿Qué comando se necesita para instalar rpi-connect en Raspberry Pi OS?**
* **Respuesta:** **f. Ninguna es correcta**.
* **Explicación:** El comando correcto para instalarlo es `sudo apt install rpi-connect`, utilizando el gestor de paquetes **`apt`** que no venía listado correctamente en las opciones.

### **¿Qué archivos necesita QEMU para emular una Raspberry Pi OS respecto al núcleo y el hardware disponible?**
* **Respuesta:** **b. DTB y Kernel**.
* **Explicación:** Requiere el Kernel de Linux y el árbol de descripción de dispositivos (DTB) compatible con la placa.

### **¿De cuántos GB espera QEMU que sea el tamaño de una imagen de Raspberry Pi OS?**
* **Respuesta:** **4 GB**.
* **Explicación:** Es el tamaño configurado habitualmente mediante `qemu-img resize`.

---

## 7. Preguntas de Cuestionario Adicionales

### **Si el buffer del ejemplo 12 tiene capacidad para 16 bytes y el usuario introduce exactamente 20 caracteres antes de presionar Enter, ¿cuántos caracteres quedan pendientes en la entrada estándar después de la lectura?**
* **Respuesta:** **5 caracteres** (incluyendo el salto de línea `\n`) o **4 caracteres** (excluyéndolo).
* **Explicación:** Los 20 caracteres más el Enter suman 21 bytes. Al leer solo 16 bytes, quedan 5 bytes remanentes en `stdin`.

### **¿Qué instrucción realiza la operación lógica XOR (O exclusivo) en registros de 64 bits en ARM64?**
* **Respuesta:** **f. EOR X0, X1, X2**.
* **Explicación:** La operación XOR se realiza mediante la instrucción `EOR` (Exclusive OR).

### **¿Qué valor octal se debe ingresar en x2 para que el ejemplo 18 dé el mismo resultado?**
* **Respuesta:** **`05`** (o **`#05`**).
* **Explicación:** El valor actual es binario `0b101` (5 en decimal). En notación octal se le añade un cero delante, quedando `05`.
