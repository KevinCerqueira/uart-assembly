#include <stdio.h>
#include <time.h>

void delay(int ms){
	long pause;
	clock_t now, then;
	pause = ms*(CLOCKS_PER_SEC/1000);
	while( (now-then) < pause);
		now = clock();
}

extern void map_mem();
extern void set_uart();
extern void put_data(); 
/* gcc example.c say_hi.o -o hello */
int main(){
	int delay_time;
	
	map_mem();
	/* printf("Your life is worthless!\n"); */

	set_uart();
	printf("You serve ZERO purpose!\n"); 
	
	int command = 8;
	/* scanf("%d", command); */
	/* printf("%d", command); */
	put_data(command);
		

	return 0;
}
