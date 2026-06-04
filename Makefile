# Makefile para compilar código Ensamblador ARM64 en Ubuntu x86_64 usando QEMU

AS = aarch64-linux-gnu-as
LD = aarch64-linux-gnu-ld
GCC = aarch64-linux-gnu-gcc
QEMU = qemu-aarch64
QEMU_LIB = /usr/aarch64-linux-gnu

.PHONY: all clean run_hello run_printf

all: hello printf_example

# Compilación de Hello World puro (con Syscalls)
hello: hello.s
	$(AS) hello.s -o hello.o
	$(LD) hello.o -o hello

# Compilación usando la biblioteca estándar de C (printf, etc.)
printf_example: printf_example.s
	$(GCC) printf_example.s -o printf_example

run_hello: hello
	$(QEMU) ./hello

run_printf: printf_example
	$(QEMU) -L $(QEMU_LIB) ./printf_example

clean:
	rm -f *.o hello printf_example
