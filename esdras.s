.equ UART_BASE, 0x7E20100     // UART base address
.org    0x1000    // Start at memory location 1000
.text  // Code Section
.global _start
_start:
// print a text string to the UART
LDR  r1, =UART_BASE
LDR  r4, =TEXT_STRING

LOOP:
LDRB r0, [r4]    // load a single byte from the string
CMP  r0, #0
BEQ  _stop       // stop when the null character is found
STR  r0, [r1]    // copy the character to the UART DATA field
ADD  r4, r4, #1  // move to next character in memory
B LOOP

_stop:
B    _stop

.data  // Data Section
// Define a null-terminated string
TEXT_STRING:
.asciz    "This is a text string"

.end
