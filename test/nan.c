#include <stdio.h>
#define NAN -999
#define NO_MARK -1
#define ARRAY_SIZE 10
int main()
{
    int A[ARRAY_SIZE] = {1, /*0*/
        NAN, /*1*/
        NAN, /*2*/
        5, /*3*/
        7,
        9,
        NAN,
        NAN,
        NAN,
        15};
    int mark = NO_MARK;/*clean mark*/
    int i,j;
    for (i=0; i<ARRAY_SIZE; i++)
    {
        printf("%d,",A[i]);
    }
    printf("\n------------------\n");
    for (i=0; i<ARRAY_SIZE; i++)
    {
        if (A[i] == NAN)
        {
            if (mark == NO_MARK)
                mark = i; /*the first NAN after cleaned the mark*/
        }
        else /*A[i]!=NAN*/
        {
            if (mark != NO_MARK)
                /*A[mark]..A[i-1] are NAN*/
            {
                printf ("from mark %d to i-1 %d are NAN\n",mark,i-1);
                for (j=mark; j<i; j++)
                {
                    /*printf ("A[%d]=NAN (%d)\n",j,A[j]);*/
                    A[j] = (A[mark-1] + A[i])/2;/*replace with you function*/
                }
                mark = NO_MARK; /*clean mark*/
            }
        }
    }
    printf("------------------\n");
    for (i=0; i<ARRAY_SIZE; i++)
    {
        printf("%d,",A[i]);
    }
    printf("\n");	
    return 0;
}
