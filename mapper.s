.include "reader.s"

.equ pagelen, 4096
.equ setregoffset, 28
.equ clrregoffset, 40
.equ PROT_READ, 1
.equ PROT_WRITE, 2
.equ MAP_SHARED, 1

.equ BUFFERLEN, 250

.global _start

_start: openFile devmem, S_RDWR
	movs	r4, r0

1:	ldr	r5,	=uartaddr
	ldr	r5,	[r5]
	mov r1, #pagelen
	
	@let linux choose a virtual address
	mov r0, #0

	@ mmap2 service num
	mov r7, #sys_mmap2 

	@ call service
	svc 0 

	@ keep the returned virtual address	 
	movs r8, r0 
	
	@ move addr to msg reg
	mov r2, r8

	@ file descriptor (stdout)
	mov r1, #1

	@ system call number
	mov r0, #4

	@ call kernel
	int 0x80

.data
timespecsec: .word 0
timespecnano: .word 100000000
devmem: .asciz "/dev/mem"
memOpnErr: .asciz "Failed to open /dev/mem\n"
memOpnsz: .word .-memOpnErr
memMapErr: .asciz "Failed to map memory\n"
memMapsz: .word .-memMapErr
uartaddr: .word	0x7E20100