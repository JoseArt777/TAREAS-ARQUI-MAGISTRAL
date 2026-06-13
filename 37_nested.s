.global _start

.bss
pattern: .space 36

.text
_start:
    ldr x0, =pattern
    mov x1, #53
    mov x2, #49

loop1:
    cmp x2, x1
    b.gt end_loop1
    mov x3, #49

loop2:
    cmp x3, x2
    b.gt end_loop2
    
    strb w3, [x0]
    add x0, x0, #1
    mov x4, #32
    strb w4, [x0]
    add x0, x0, #1
    
    add x3, x3, #1
    b loop2

end_loop2:
    add x2, x2, #1
    mov x4, #10
    strb w4, [x0]
    add x0, x0, #1
    b loop1

end_loop1:
    strb wzr, [x0]

    mov x0, #1
    ldr x1, =pattern
    mov x2, #36
    mov x8, #64
    svc #0

    mov x0, #0
    mov x8, #93
    svc #0
