.equ AUX_ENABLES,   0x2116112388
.equ AUX_MU_IER_REG,    0x2116112448
.equ AUX_MU_CNTL_REG,   0x2116112480
.equ AUX_MU_LCR_REG,    0x2116112460
.equ AUX_MU_MCR_REG,    0x2116112464
.equ AUX_MU_IIR_REG,    0x2116112456
.equ AUX_MU_BAUD_REG,   0x2116112488
.equ GPPUD,    0x2116026516
.equ GPPUDCLK0,    0x2116026520
.equ GPCLR0,    0x2116026408
.equ GPFSEL1,    0x2116026368



InitializeUART:
PUSH {lr}
@ Enable UART
MOV R1, #1
LDR R0, =AUX_ENABLES
STR R1, [R0]
@ disable interrupts
MOV R1, #0
LDR R0, =AUX_MU_IER_REG
STR R1, [R0]
@ disable transmit/receive
MOV R1, #0
LDR R0, =AUX_MU_CNTL_REG
STR R1, [R0]
@ set 8 bits communication
MOV R1, #3
LDR R0, =AUX_MU_LCR_REG
STR R1, [R0]
@ set the RTS line high
MOV R1, #0
LDR R0, =AUX_MU_MCR_REG
STR R1, [R0]
@ leave disable interrupts
MOV R3, #0
LDR R0, =AUX_MU_IER_REG
STR R3, [R0]
@ clear the input and output buffers
MOV R1, #198
LDR R0, =AUX_MU_IIR_REG
STR R1, [R0]
@ set BAUD = 270
MOV R1, #200
ADD R1, R1, #70
LDR R0, =AUX_MU_BAUD_REG
STR R1, [R0]
@ Set GPIO line 14 for transmission (TXD)
LDR R0, =GPFSEL1
LDR R1, [R0]
BIC R3, R1, #28672
ORR R3, R3, #8192
STR R3, [R0]
@ Set GPIO line 15 for receiving (RXD)
LDR R1, [R0]
BIC R3, R1, #229376
ORR R3, R3, #65536
STR R3, [R0]
@ disable GPIO pull-up/down
MOV R1, #0
LDR R0, =GPPUD
STR R1, [R0]
@ wait for 150 cycles
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
@ clear clock lines
MOV R1, #0
LDR R0, =GPCLR0
STR R1, [R0]
@ enable bits 0 and 1 in CONTROL
MOV R1, #3
LDR R0, =AUX_MU_CNTL_REG
STR R1, [R0]
@ return
POP {pc}        

Cycle:      MOV pc, lr