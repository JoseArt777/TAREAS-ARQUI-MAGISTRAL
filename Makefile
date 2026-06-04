# Makefile para compilar código Ensamblador ARM64 en Ubuntu x86_64 usando QEMU

AS = aarch64-linux-gnu-as
LD = aarch64-linux-gnu-ld
GCC = aarch64-linux-gnu-gcc
QEMU = qemu-aarch64
QEMU_LIB = /usr/aarch64-linux-gnu

.PHONY: all clean run_hello run_printf run_suma

all: hello printf_example suma_digitos

# Compilación de Hello World puro (con Syscalls)
hello: hello.s
	$(AS) hello.s -o hello.o
	$(LD) hello.o -o hello

# Compilación usando la biblioteca estándar de C (printf, etc.)
printf_example: printf_example.s
	$(GCC) printf_example.s -o printf_example

# Compilación del programa de suma de dígitos
suma_digitos: suma_digitos.s
	$(AS) suma_digitos.s -o suma_digitos.o
	$(LD) suma_digitos.o -o suma_digitos

run_hello: hello
	$(QEMU) ./hello

run_printf: printf_example
	$(QEMU) -L $(QEMU_LIB) ./printf_example

run_suma: suma_digitos
	@$(QEMU) ./suma_digitos; echo "Suma de los digitos (codigo de retorno): $$?"

clean:
	rm -f *.o hello printf_example suma_digitos

