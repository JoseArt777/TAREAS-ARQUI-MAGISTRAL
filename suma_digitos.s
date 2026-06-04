.global _start

.section .text
_start:
    // 1. Mostrar el prompt en consola
    mov x0, #1          // File descriptor: 1 (stdout)
    ldr x1, =prompt     // Puntero al mensaje
    mov x2, #33         // Longitud del prompt (33 caracteres)
    mov x8, #64         // Syscall number para write (64)
    svc #0              // Invocar syscall

    // 2. Leer la entrada del usuario
    mov x0, #0          // File descriptor: 0 (stdin)
    ldr x1, =buffer     // Puntero al buffer para guardar la entrada
    mov x2, #10         // Leer hasta 10 bytes (3 dígitos + \n + margen)
    mov x8, #63         // Syscall number para read (63)
    svc #0              // Invocar syscall

    // 3. Procesar los dígitos ingresados
    ldr x1, =buffer     // Cargar la dirección del buffer

    // Primer dígito
    ldrb w2, [x1, #0]
    sub w2, w2, #48     // Restar '0' (48) para obtener el valor numérico

    // Segundo dígito
    ldrb w3, [x1, #1]
    sub w3, w3, #48

    // Tercer dígito
    ldrb w4, [x1, #2]
    sub w4, w4, #48

    // Sumar los dígitos
    add w0, w2, w3
    add w0, w0, w4

    // 4. Salir con el código de retorno en x0 (w0 se extiende automáticamente a x0)
    mov x8, #93         // Syscall number para exit (93)
    svc #0

.section .data
prompt:
    .ascii "Ingrese una cadena de 3 digitos: "

.section .bss
buffer:
    .space 10
