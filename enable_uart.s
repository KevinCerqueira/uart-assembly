global _start

_start:
	BL main

main:
BL InitializeUART

.equ AUX_ENABLES, 0x7E215004
.equ AUX_MU_IER_REG, 0x7E215044
.equ AUX_MU_CNTL_REG, 0x7E215060
.equ AUX_MU_LCR_REG, 0x7E21504C
.equ AUX_MU_MCR_REG, 0x7E215050
.equ AUX_MU_IIR_REG, 0x7E215048
.equ AUX_MU_BAUD_REG, 0x7E215068
.equ GPPUD, 0x7E200094
.equ GPPUDCLK0, 0x7E200098
.equ GPCLR0, 0x7E200028
.equ GPFSEL1, 0x7E200004

InitializeUART:
PUSH {lr}
@ Habilitando UART
MOV R1, #1
LDR R0, =AUX_ENABLES
STR R1, [R0]

@ Desabilitando interruptores
MOV R1, #0
LDR R0, =AUX_MU_IER_REG
STR R1, [R0]

@ Desabilitando transmissor/receptor
MOV R1, #0
LDR R0, =AUX_MU_CNTL_REG
STR R1, [R0]

@ Setando 8 bits para comunicação
MOV R1, #3
LDR R0, =AUX_MU_LCR_REG
STR R1, [R0]

@ Setando RTS linha de nivel alto
MOV R1, #0
LDR R0, =AUX_MU_MCR_REG
STR R1, [R0]

@ Deixando desabilitado os interruptores
MOV R3, #0
LDR R0, =AUX_MU_IER_REG
STR R3, [R0]

@ Limpando os buffers (entrada/saida)
MOV R1, #198
LDR R0, =AUX_MU_IIR_REG
STR R1, [R0]

@ Setando BAUD = 270
MOV R1, #200
ADD R1, R1, #70
LDR R0, =AUX_MU_BAUD_REG
STR R1, [R0]

@ Setando GPIO linha 14 para transmissao (TXD)
LDR R0, =GPFSEL1
LDR R1, [R0]
BIC R3, R1, #28672
ORR R3, R3, #8192
STR R3, [R0]

@ Setando GPIO linha 15 para recebimento (RXD)
LDR R1, [R0]
BIC R3, R1, #229376
ORR R3, R3, #65536
STR R3, [R0]

@ Desabilitando GPIO pull-up/down
MOV R1, #0
LDR R0, =GPPUD
STR R1, [R0]

@ Espetando por 150 ciclos
MOV R1, #0
cycle1: ADD R1, R1, #1
BL Cycle
CMP R1, #150
BNE cycle1

@ Assert clock lines (14 & 15)
MOV R1, #16384  @ 1<<14
LDR R0, =GPPUDCLK0
STR R1, [R0]
MOV R1, #32768 @ 1<<15
STR R1, [R0]

@ wait for 150 cycles
MOV R1, #0
cycle2: ADD R1, R1, #1
BL Cycle
CMP R1, #150
BNE cycle2

@ Limpando linhas do clock
MOV R1, #0
LDR R0, =GPCLR0
STR R1, [R0]

@ Habilitando bits 0 e 1 no CONTROL
MOV R1, #3
LDR R0, =AUX_MU_CNTL_REG
STR R1, [R0]

@ return
POP {pc}        

Cycle:      MOV pc, lr
