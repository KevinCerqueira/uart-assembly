.equ O_RDONLY, 0
.equ O_WRONLY, 1
.equ O_CREAT, 0100
.equ S_RDWR, 0666

.include "unistd.s"

.macro openFile fileName, flags
	ldr r0, =\fileName
	mov r1, #\flags
	Chapter 7 Linux Operating SyStem ServiCeS
	136
	mov r2, #S_RDWR @ RW access rights
	mov r7, #sys_open
.endm


.macro flushClose fd
@fsync syscall
	mov r0, \fd
	mov r7, #sys_fsync
	svc 0
@close syscall
	mov r0, \fd
	mov r7, #sys_close
	svc 0
.endm