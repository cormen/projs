#include <stdio.h>
int main()
{
	int a = 1;
	int *p = &a;
	printf("a=%d, &a=0x%x, p=0x%x\n", a, &a, p);
	return 0;
}