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

	mov r2, r8 @ address of gpio regs
	add r2, #setregoffset @ off to set reg
	mov r0, #1 @ 1 bit to shift into pos
	ldr r3, =\pin @ base of pin info table
	add r3, #8 @ add offset for shift amt
	ldr r3, [r3] @ load shift from table
	lsl r0, r3 @ do the shift
	str r0, [r2] @ write to the register

	mov r2, r8 @ address of gpio regs
	add r2, #clrregoffset @ off set of clr reg
	mov r0, #1 @ 1 bit to shift into pos
	ldr r3, =\pin @ base of pin info table
	add r3, #8 @ add offset for shift amt
	ldr r3, [r3] @ load shift from table
	lsl r0, r3 @ do the shift
	str r0, [r2] @ write to the register


section .data
timespecsec: .word 0
timespecnano: .word 100000000
devmem: .asciz "/dev/mem"
memOpnErr: .asciz "Failed to open /dev/mem\n"
memOpnsz: .word .-memOpnErr
memMapErr: .asciz "Failed to map memory\n"
memMapsz: .word .-memMapErr

gpioaddr: .word 0x7E20100

pin17: .word 4 @ offset to select register
.word 21 @ bit offset in select register
.word 17 @ bit offset in set & clr register
pin22: .word 8 @ offset to select register
.word 6 @ bit offset in select register
.word 22 @ bit offset in set & clr register
pin27: .word 8 @ offset to select register
.word 21 @ bit offset in select register
.word 27 @ bit offset in set & clr registe
