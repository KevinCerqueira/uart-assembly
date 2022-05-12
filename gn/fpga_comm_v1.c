#include <stdio.h>

extern void begin_uart();

int main(){
	
	asm("mov r6, #5");
	for(int i = 0; i < 20000000; i++){
		begin_uart();	
	}
	return 0;
}
