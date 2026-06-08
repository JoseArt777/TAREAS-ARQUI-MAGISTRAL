.global _start

_start:
	mov x1, #-180	// x1 = -180
	neg x0, x1	// x0 = -x1 (two's complement)

	mov x8, #93
	svc #0
