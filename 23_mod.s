.global _start

_start:
	mov x0, #10	// Dividendo (x)
	mov x1, #3	// Divisor (n)
	sdiv x2, x0, x1	// x2 = x0 / x1 (10 / 3 = 3)
	mul x2, x2, x1	// x2 = x2 * x1 (3 * 3 = 9)
	sub x0, x0, x2	// x0 = x0 - x2 (10 - 9 = 1) (Ahorrando la instrucción mov al almacenar en x0)

	mov x8, #93	// exit
	svc #0
