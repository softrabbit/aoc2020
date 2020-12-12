#include <stdio.h>

/* Part 2, find the missing seat. */

int seats[1024]; /* 2^10 seats to fill, global to init to 0 */

void main() {
	FILE *f;
	int seat;
	int max = 0;
	int c;
	
	f = fopen("input.txt","r");
	if(f) {
		seat = 0;
		while( (c = getc(f)) != EOF) {
			/* No error checking, B|R == 1 and F|L == 0 */
			if(c == 'B' || c == 'R') {				
				seat = seat << 1 | 1;
			} else if( c == 'F' || c == 'L') {
				seat = seat << 1;
			} else if( c == '\n') {
				/* End of line, mark seat in array */
				seats[seat] = 1;
				seat = 0;				
			}
		}
		/* Then find empty seat, disregard "some of the 
		   seats at the very front and back" */
		for(c = 0; c<1024 && seats[c] == 0; c++);
		printf("%d\n",c);
		for(; c<1024 ; c++) {
			if(seats[c] == 0 &&
			   seats[c-1] == 1 &&
			   seats[c+1] == 1) {
				printf("Seat %d\n", c);
			}
		}
	} else {
		printf("Can't open file\n");
	}
}
