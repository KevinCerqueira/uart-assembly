.include "file_read.s"

@ MI DE SISTEMAS DIGITAIS, PROBLEMA 1, TURMA 2
@ ALUNOS: GUILHERME NOBRE, KEVIN CERQUEIRA, ESDRAS ABREU
@ testado na pi 104

@ constantes para mapeamento de memoria

.equ pagelen, 4096
.equ sys_mmap2, 192

.equ uart_offset, 0x20201
.equ PROT_RD, 0x1
.equ PROT_WR, 0x2
.equ MAP_SHARED, 1
.equ PROT_RDWR, PROT_RD|PROT_WR
.equ BUFFERLEN, 250

@ constantes para endereços de registradores da UART

.equ UART_IBRD, 0x24     @ divisor inteiro da baude raute (taxa de transmissão)
.equ UART_FBRD, 0x28     @ divisor fracionário da baude raute (taxa de transmissão)
.equ UART_LCRH, 0x2C     @ linha de controle do registrador
.equ UART_IMSC, 0x38     @ Setando a limpeza da mascara
.equ UART_CR, 0x30       @ registrador de controle
.equ UART_FR, 0x18       @ registrador de flag
.equ UART_DR, 0x0        @ registrador de dados

@ lcrh setup

.equ UART_WLEN1, (1<<6)   @ MSB de comprimento de palavra
.equ UART_WLEN0, (1<<5)   @ LSB de comprimento de palavra
.equ UART_FEN, (1<<4)     @ Habilitando a FIFO
.equ STP2, (1<<3)         @ Uso de 2 bits de paradas (stop bit)

@ cr setup

.equ UART_RXE, (1<<9)       @ Habilitando recebimento de dados (RX)
.equ UART_TXE, (1<<8)	    @ Habilitando transmissão de dados (TX)
.equ UART_UARTEN, (1<<0)    @ Habilitando a UART

@ fr setup

.equ UART_TXFF, (1<<7)      @ Transmissão FIFO
.equ UART_RXFE, (1<<4)      @ Recepção FIFO

.equ BITS, (UART_WLEN1|UART_WLEN0|UART_FEN|STP2) 
.equ FINAL_BITS, (UART_RXE|UART_TXE|UART_UARTEN)

.global _start

_start: openFile devmem, S_RDWR
		mov	r4, r0 

MAP_MEM:
		ldr r5, =uartaddr           
		ldr r5, [r5]		      
		mov r1, #pagelen
		mov r2, #(PROT_RD + PROT_WR)
		mov r3, #MAP_SHARED
		mov r0, #0

		@ mmap2 service
		mov r7, #sys_mmap2
		svc 0

		@ keep virtual address
		mov	r5,	r0

UART_INIT:
		@ set baud rate

		mov r1, #10
		str r1, [r5, #UART_IBRD]
		mov r1, #0x40
		str r1, [r5, #UART_FBRD]

DISABLE_UART:
		mov r1, #0
		str r1, [r5, #UART_CR]

CHECK_LOOP:
		ldr r2, [r5, #UART_FR]
		tst r2, #UART_TXFF
		@ bne CHECK_LOOP

CLEAR_FIFO:
		ldr r1, [r5, #UART_LCRH]
		mov r0, #1
		lsl r0, #4
		bic r1, r0
		str r1, [r5, #UART_LCRH]

SET_UART:

		@ set parity, word length, stop bits

		mov r1, #BITS
		str r1, [r5, #UART_LCRH]

		@ set rxe and txe

		ldr r1, =FINAL_BITS
		str r1, [r5, #UART_CR]

		@ mask interrupts

		mov r1, #0
		str r1, [r5, #UART_IMSC]

put_loop:
		@ ldr r2, [r5, #UART_FR]
		@ tst r2, #UART_TXFF
		@ bne put_loop

		mov r0, #5
		str r0, [r5, #UART_DR]
		b put_loop

get_loop:
		@ ldr r2, [r5, #UART_FR]
		@ tst r2, #UART_RXFE
		@ bne get_loop

		ldr r3, [r5, #UART_DR]

		@terminate program
		mov r0, #0
		mov r7, #1
		svc 0

.data
timespecsec: .word 0
wbaudrate: .word 16
clrbaudrate: .word 0
timespecnano: .word 100000000
devmem: .asciz "/dev/mem"
uartaddr: .word uart_offset
