
@ Codigo em assembly para ligar o LED ligado no GPIO6 como seu GND (LED liga com valor logico 0)
@ Cogigo usando o endereço da memoria direto, ocasionando erro
@ Usar como base para criar o novo codigo

@ IOmemory.s
@ Opens the /dev/gpiomem device and maps GPIO memory
@ into program virtual address space.
@ 2017-09-29: Bob Plantz

@ 2022-04-06: Guilherme Nobre

@ Define my Raspberry Pi
        .cpu    cortex-a53
        .fpu    neon-fp-armv8
        .syntax unified         @ modern syntax

@ Constants for assembler
@ The following are defined in /usr/include/asm-generic/fcntl.h:
@ Note that the values are specified in octal.
        .equ    O_RDWR, 00000002   @ open for read/write
        .equ    O_DSYNC, 00010000  @ synchronize virtual memory
        .equ    __O_SYNC, 04000000 @      programming changes with
        .equ    O_SYNC,__O_SYNC|O_DSYNC @ I/O memory
@ The following are defined in /usr/include/asm-generic/mman-common.h:
        .equ    PROT_READ,0x1   @ page can be read
        .equ    PROT_WRITE,0x2  @ page can be written
        .equ    MAP_SHARED,0x01 @ share changes
@ The following are defined by me:
        .equ    PERIPH, 0x20000000   @ RPi zero & 1 peripherals
        .equ    GPIO_OFFSET, 0x200000  @ start of GPIO device
        
@        .equ    UART_OFFSET, 0x7E20100 @ start of UART addresses
        
        .equ    O_FLAGS,O_RDWR|O_SYNC @ open file flags
        .equ    PROT_RDWR, PROT_READ|PROT_WRITE
        .equ    NO_PREF,0
        .equ    PAGE_SIZE,4096  @ Raspbian memory page
        .equ    FILE_DESCRP_ARG, 0   @ file descriptor
        .equ    DEVICE_ARG, 4        @ device address
        
@        .equ    UART_ARG, 8

        .equ    STACK_ARGS, 8    @ sp already 8-byte aligned

@ Constant program data
        .section .rodata
        .align  2
device:
        .asciz  "/dev/gpiomem"
fdMsg:
        .asciz  "File descriptor = %i\n"
memMsg:
        .asciz  "Using memory at %p\n"

	.text

	.align 2

	.global main

	.type   main, %function

main:

	sub     sp, sp, 16      			@ space for saving regs
        str     r4, [sp, #0]     		@ save r4
        str     r5, [sp, #4]     		@      r5
        str     fp, [sp, #8]     		@      fp
        str     lr, [sp, #12]    		@      lr
        add     fp, sp, #12      		@ set our frame pointer
        sub     sp, sp, #STACK_ARGS 		@ sp on 8-byte boundary

@ Open /dev/gpiomem for read/write and syncing     
   
        ldr     r0, #deviceAddr  		@ address of /dev/gpiomem
        ldr     r1, #openMode    		@ flags for accessing device
        bl      open
        mov     r4, r0          		@ use r4 for file descriptor

@ Map the GPIO registers to a virtual memory location so we can access them    
    
        str     r4, [sp, #FILE_DESCRP_ARG] 	@ /dev/gpiomem file descriptor
        ldr     r0, gpio        		@ address of GPIO
        
        str     r0, [sp, #DEVICE_ARG]		@ location of GPIO
        mov     r0, #NO_PREF     		@ let kernel pick memory
        mov     r1, #PAGE_SIZE   		@ get 1 page of memory
        mov     r2, #PROT_RDWR   		@ read/write this memory
        mov     r3, #MAP_SHARED  		@ share with other processes
        bl      mmap
        
        ldr 	r0, =0x7E200004		@ Carrega o endereço de memoria no r0 para fazer o acesso e alteração de todos os dados
        mov     r5, r0          		@ save virtual memory address
	
	mov	r1, #4				@ Move o valor logico 100 para o registrador r1
	
	@ lsl	r1, #18 			@ Transforma o valor logico 1 em 262.144^10 (001 000 000 000 000 000 000) 
	@ str	r1, [r5, #0]			@ Escreve o valor no endereço de memoria guardado em r0 (Endereço da GPFSEL0)
	
	str	r1, [r5, #14]			@ Escreve o valor no endereço de memoria guardado em r0 (Endereço FSEL14 da GPFSEL1)
	str	r1, [r5, #17]			@ Escreve o valor no endereço de memoria guardado em r0 (Endereço FSEL15 da GPFSEL1)
	
	@ mov 	r1, #1				@ Substitui o valor em r1 por 1
	@ lsl 	r1, #6				@ Transforma o valor logico 1 em 64^10 (0100 0000)
	@ str	r1, [r5, #40]			@ Escreve no endereço da GPCLR0 o valor de r1 para desligar o GPIO6
	
	
	
deviceAddr:
        .word   device
openMode:
        .word   O_FLAGS
gpio:
        .word   PERIPH+GPIO_OFFSET
