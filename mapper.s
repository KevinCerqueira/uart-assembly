.include "reader.s"

.equ pagelen, 4096
.EQU sys_mmap2, 192 
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
	
	@ print virtual address

	mov r0, #1
	ldr r1, [r8] @ string to print
	mov r2, #16 @ length of our string
	mov r7, #4 @ linux write system call
	svc 0 @ Call linux to print

	mov r0, #0 @ Use 0 return code
	mov r7, #1 @ Service command code 1
	svc 0 @ Call linux to terminate

.data
timespecsec: .word 0
timespecnano: .word 100000000
devmem: .asciz "/dev/mem"
memOpnErr: .asciz "Failed to open /dev/mem\n"
memOpnsz: .word .-memOpnErr
memMapErr: .asciz "Failed to map memory\n"
memMapsz: .word .-memMapErr
uartaddr: .word	0x7E20100
