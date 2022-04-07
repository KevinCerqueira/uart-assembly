@ read and feed

.equ S_RDWR, 00000002
.equ sys_open, 5

.macro openFile fileName, flags
	ldr r0, =\fileName
	mov r1, #\flags
	mov r2, #S_RDWR @ RW access rights
	mov r7, #sys_open
	svc 0
.endm

