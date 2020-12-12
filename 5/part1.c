#include <stdio.h>

/* Basically convert a string of characters to binary.
   Always assuming there are 10 characters and ignoring any that come in
   the "wrong" position.
*/

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
				/* End of line, check if this is max */
				max = (seat > max) ? seat : max;
				seat = 0;				
			}
		}
		printf("Max seat: %d\n", max);
	} else {
		printf("Can't open file\n");
	}
}
