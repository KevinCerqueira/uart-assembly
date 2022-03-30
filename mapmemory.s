.equ pagelen, 4096
.equ setregoffset, 28
.equ clrregoffset, 40
.equ PROT_READ, 1
.equ PROT_WRITE, 2
.equ MAP_SHARED, 1

section.text
	global_start
_start:
	openFile	devmem, S_RDWR
	mov	r4, r0
	ldr	r5, =uartio
	ldr	r5, [r5]
	mov r1, #pagelen
	mov r2, #(PROT_READ + PROT_WRITE)
	mov r3, #MAP_SHARED @ mem share options
	mov r0, #0
	mov r7, #sys_mmap2
	svc 0
	mov r8, r0
	
	
section .data
timespecsec: .word 0
timespecnano: .word 100000000
devmem: .asciz "/dev/mem"
memOpnErr: .asciz "Failed to open /dev/mem\n"
memOpnsz: .word .-memOpnErr
memMapErr: .asciz "Failed to map memory\n"
memMapsz: .word .-memMapErr
gpioaddr: .word 0x7E20100
