.include "file_read.s"

.equ pagelen, 4096
.equ mmap2, 192

.equ periph, 0x20000000
.equ uart_offset, 0x7E20100

.equ setregoffset, 28
.equ clrregoffset, 40
.equ PROT_RD, 0x1
.equ PROT_WR, 0x2
.equ MAP_SHARED, 0x1
.equ PROT_RDWR, PROT_RD|PROT_WR
.equ BUFFERLEN, 250

.global _start

_start: openFile devmem
		mov	r4, r0 

L1:		ldr	r0, =uartaddr
		mov r1, #pagelen

		mov	r2, #PROT_RDWR
		mov	r3,	#MAP_SHARED

		@ mmap2 service
		mov r7, #sys_mmap2
		svc 0

		@ keep virtual address
		mov	r5,	r0

		@terminate program
		mov r0, #0
		mov r7, #1
		svc 0

.data
timespecsec: .word 0
timespecnano: word 100000000
devmem: .asciz "/dev/mem"
uartaddr: .word periph+uart_offset



