.include "file_read.s"

.equ pagelen, 4096
.equ sys_mmap2, 192

.equ periph, 0x20000000
.equ uart_offset, 0x7E20100
.equ setregoffset, 28
.equ clrregoffset, 40
.equ PROT_RD, 0x1
.equ PROT_WR, 0x2
.equ MAP_SHARED, 0x1
.equ PROT_RDWR, PROT_RD|PROT_WR
.equ BUFFERLEN, 250

.equ UART_IBRD, 0x24
.equ UART_FBRD, 0x28
.equ UART_LCRH, 0x2C
.equ UART_IMSC, 0x38
.equ UART_CR, 0x30
.equ UART_FR, 0x18
.equ UART_DR, 0x0

.equ UART_WLEN1, (1<<6)
.equ UART_WLEN0, (1<<5)
.equ UART_FEN, (1<<4)
.equ STP2, (1<<3)

.equ UART_TXFF, (1<<7)
.equ UART_RXFE, (1<<4)
.equ UART_RXE, (1<<9)
.equ UART_TXE, (1<<8)
.equ UART_UARTEN, (1<<0)

.equ BITS, (UART_WLEN1|UART_WLEN0|UART_FEN|STP2)
.equ FINAL_BITS, (UART_RXE|UART_TXE|UART_UARTEN)

.global _start

_start: openFile devmem, S_RDWR
		mov	r4, r0 

L1:		ldr	r0, =uartaddr
		mov	r1, #pagelen

		mov	r2, #PROT_RDWR
		mov	r3, #MAP_SHARED

		@ mmap2 service
		mov r7, #sys_mmap2
		svc 0

		@ keep virtual address
		mov	r5,	r0

UART_INIT:
		@ set baud rate

		mov r1, #1
		str r1, [r5, #UART_IBRD]
		mov r1, #0x28
		str r1, [r5, #UART_FBRD]

		@ set parity

		mov r1, #BITS
		str r1, [r5, #UART_LCRH]

		@ mask interrupts

		mov r1, #0
		str r1, [r5, #UART_IMSC]

put_loop:
		ldr r2, [r5, #UART_FR]
		tst r2, #UART_TXFF
		bne put_loop

		mov r0, #0x3
		str r0, [r5, #UART_DR]

get_loop:
		ldr r2, [r5, #UART_FR]
		tst r2, #UART_RXFE
		bne get_loop

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
uartaddr: .word periph+uart_offset