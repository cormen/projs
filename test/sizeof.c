#include <stdio.h>
struct a {
	char cc;
	int ii;
};
int main() 
{
	printf(" \
		 char = %d \n \
		 signed char = %d \n \
		 unsigned char = %d \n \
		 short = %d \n \
		 short int = %d \n \
		 signed short = %d \n \
		 signed short int = %d \n \
		 unsigned short = %d \n \
		 unsigned short int = %d \n \
		 int = %d \n \
		 signed int = %d \n \
		 unsigned = %d \n \
		 unsigned int = %d \n \
		 long = %d \n \
		 long int = %d \n \
		 signed long = %d \n \
		 signed long int = %d \n \
		 unsigned long = %d \n \
		 unsigned long int = %d \n \
		 long long = %d \n \
		 long long int = %d \n \
		 signed long long = %d \n \
		 signed long long int = %d \n \
		 unsigned long long = %d \n \
		 unsigned long long int = %d \n \
		 float = %d \n \
		 double = %d \n \
		 long double = %d \n \
		 struct a = %d \n \
		 ",
		sizeof(char),
		sizeof(signed char),
		sizeof(unsigned char),
		sizeof(short),
		sizeof(short int),
		sizeof(signed short),
		sizeof(signed short int),
		sizeof(unsigned short),
		sizeof(unsigned short int),
		sizeof(int),
		sizeof(signed int),
		sizeof(unsigned),
		sizeof(unsigned int),
		sizeof(long),
		sizeof(long int),
		sizeof(signed long),
		sizeof(signed long int),
		sizeof(unsigned long),
		sizeof(unsigned long int),
		sizeof(long long),
		sizeof(long long int),
		sizeof(signed long long),
		sizeof(signed long long int),
		sizeof(unsigned long long),
		sizeof(unsigned long long int),
		sizeof(float),
		sizeof(double),
		sizeof(long double),
		sizeof(struct a)
	);
	return 0;
}
