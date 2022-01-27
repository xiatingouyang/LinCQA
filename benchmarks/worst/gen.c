#include<stdio.h>
#include<stdlib.h>


int main(int argc, char** argv){
	if (argc < 4) return 0;
	
	long a = atoi(argv[1]);
	long b = atoi(argv[2]);
	
	long n = atoi(argv[3]);

	for(long i = 0; i < a; i++){
		for(long j = 0; j < b; j++){
			printf("%ld,%ld\n", i, j);
		}
	
	}

	long missing = n - a * b;

	for(long i = 0; i < missing; i++){
		printf("%ld,%ld\n",  n + i, n + i);
	}
	
	return 0;
}
