.global _start

.section .text
_start:
    // write(1, msg, len)
    mov x0, #1          // File descriptor: 1 (stdout)
    ldr x1, =msg        // Pointer to the message in memory
    mov x2, #14         // Length of the message ("Hello, ARM64!\n" has 14 characters)
    mov x8, #64         // Linux syscall number for write (64)
    svc #0              // Invoke system call

    // exit(0)
    mov x0, #0          // Return status: 0
    mov x8, #93         // Linux syscall number for exit (93)
    svc #0              // Invoke system call

.section .data
msg:
    .ascii "Hello, ARM64!\n"
