.global main
.align 2

.section .text
main:
    // Save link register (x30) and frame pointer (x29) to stack
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Load the address of the format string into x0 (first argument of printf)
    adrp x0, msg
    add x0, x0, :lo12:msg
    bl printf

    // Restore link register and frame pointer, set exit code to 0, and return
    ldp x29, x30, [sp], #16
    mov w0, #0
    ret

.section .data
msg:
    .asciz "Hello from printf in ARM64!\n"
