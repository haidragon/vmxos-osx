all: interrupt_hw.o interrupt.o

interrupt.o: interrupt.c interrupt.h ../kernel.h
	gcc -m32 -ffreestanding -fno-builtin -nostdlib -o interrupt.o -c interrupt.c

interrupt_hw.o: interrupt_hw.asm
	nasm -f aout interrupt_hw.asm -o interrupt_hw.o
#	nasm -f coff interrupt_hw.asm -o interrupt_hw.o

clean:
	rm -f *.o
