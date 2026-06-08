# Makefile para compilar código Ensamblador ARM64 en Ubuntu x86_64 usando QEMU

AS = aarch64-linux-gnu-as
LD = aarch64-linux-gnu-ld
GCC = aarch64-linux-gnu-gcc
QEMU = qemu-aarch64
QEMU_LIB = /usr/aarch64-linux-gnu

.PHONY: all clean run_hello run_printf run_suma

all: hello printf_example suma_digitos 10_str64 11_print 12_read 13_brk 14_add_imm 15_add_array 16_complement 17_oddand 18_sensororr 19_divlsr 20_mullsl 21_cleanand 22_mul32

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

# Compilación de Ejemplo 10 (Load and Store)
10_str64: 10_str64.s
	$(AS) 10_str64.s -o 10_str64.o
	$(LD) 10_str64.o -o 10_str64

# Compilación de Ejemplo 11 (Print message)
11_print: 11_print.s
	$(AS) 11_print.s -o 11_print.o
	$(LD) 11_print.o -o 11_print

# Compilación de Ejemplo 12 (Read keyboard)
12_read: 12_read.s
	$(AS) 12_read.s -o 12_read.o
	$(LD) 12_read.o -o 12_read

# Compilación de Ejemplo 13 (Allocation memory with Break)
13_brk: 13_brk.s
	$(AS) 13_brk.s -o 13_brk.o
	$(LD) 13_brk.o -o 13_brk

# Compilación de Ejemplo 14 (Add immediate)
14_add_imm: 14_add_imm.s
	$(AS) 14_add_imm.s -o 14_add_imm.o
	$(LD) 14_add_imm.o -o 14_add_imm

# Compilación de Ejemplo 15 (Adding Array)
15_add_array: 15_add_array.s
	$(AS) 15_add_array.s -o 15_add_array.o
	$(LD) 15_add_array.o -o 15_add_array

# Compilación de Ejemplo 16 (Complement)
16_complement: 16_complement.s
	$(AS) 16_complement.s -o 16_complement.o
	$(LD) 16_complement.o -o 16_complement

# Compilación de Ejemplo 17 (Parity with AND)
17_oddand: 17_oddand.s
	$(AS) 17_oddand.s -o 17_oddand.o
	$(LD) 17_oddand.o -o 17_oddand

# Compilación de Ejemplo 18 (Sensor control with ORR)
18_sensororr: 18_sensororr.s
	$(AS) 18_sensororr.s -o 18_sensororr.o
	$(LD) 18_sensororr.o -o 18_sensororr

# Compilación de Ejemplo 19 (Division octal with LSR)
19_divlsr: 19_divlsr.s
	$(AS) 19_divlsr.s -o 19_divlsr.o
	$(LD) 19_divlsr.o -o 19_divlsr

# Compilación de Ejemplo 20 (Multiply with LSLV)
20_mullsl: 20_mullsl.s
	$(AS) 20_mullsl.s -o 20_mullsl.o
	$(LD) 20_mullsl.o -o 20_mullsl

# Compilación de Ejemplo 21 (Hex mask with AND)
21_cleanand: 21_cleanand.s
	$(AS) 21_cleanand.s -o 21_cleanand.o
	$(LD) 21_cleanand.o -o 21_cleanand

# Compilación de Ejemplo 22 (Multiply 32-bit with W registers)
22_mul32: 22_mul32.s
	$(AS) 22_mul32.s -o 22_mul32.o
	$(LD) 22_mul32.o -o 22_mul32

run_hello: hello
	$(QEMU) ./hello

run_printf: printf_example
	$(QEMU) -L $(QEMU_LIB) ./printf_example

run_suma: suma_digitos
	@$(QEMU) ./suma_digitos; echo "Suma de los digitos (codigo de retorno): $$?"

run_10_str64: 10_str64
	@$(QEMU) ./10_str64; echo "Retorno del programa (codigo de retorno): $$?"

run_11_print: 11_print
	@$(QEMU) ./11_print; echo "Retorno del programa (codigo de retorno): $$?"

run_12_read: 12_read
	@$(QEMU) ./12_read; echo "Retorno del programa (codigo de retorno): $$?"

run_13_brk: 13_brk
	@$(QEMU) ./13_brk; echo "Retorno del programa (codigo de retorno): $$?"

run_14_add_imm: 14_add_imm
	@$(QEMU) ./14_add_imm; echo "Retorno del programa (codigo de retorno): $$?"

run_15_add_array: 15_add_array
	@$(QEMU) ./15_add_array; echo "Retorno del programa (codigo de retorno): $$?"

run_16_complement: 16_complement
	@$(QEMU) ./16_complement; echo "Retorno del programa (codigo de retorno): $$?"

run_17_oddand: 17_oddand
	@$(QEMU) ./17_oddand; echo "Retorno del programa (codigo de retorno): $$?"

run_18_sensororr: 18_sensororr
	@$(QEMU) ./18_sensororr; echo "Retorno del programa (codigo de retorno): $$?"

run_19_divlsr: 19_divlsr
	@$(QEMU) ./19_divlsr; echo "Retorno del programa (codigo de retorno): $$?"

run_20_mullsl: 20_mullsl
	@$(QEMU) ./20_mullsl; echo "Retorno del programa (codigo de retorno): $$?"

run_21_cleanand: 21_cleanand
	@$(QEMU) ./21_cleanand; echo "Retorno del programa (codigo de retorno): $$?"

run_22_mul32: 22_mul32
	@$(QEMU) ./22_mul32; echo "Retorno del programa (codigo de retorno): $$?"

clean:
	rm -f *.o hello printf_example suma_digitos 10_str64 11_print 12_read 13_brk 14_add_imm 15_add_array 16_complement 17_oddand 18_sensororr 19_divlsr 20_mullsl 21_cleanand 22_mul32

