/*
peek and poke for bytes, words, and dwords in qb64
public domain, sept 2011, michael calkins
http://www.network54.com/Forum/648955/message/1315950606/
*/

unsigned char peekb(void * p)
{return *(unsigned char *)p;}

unsigned short int peekw(void * p)
{return *(unsigned short int *)p;}

unsigned long int peekd(void * p)
{return *(unsigned long int *)p;}

void pokeb(void * p, unsigned char n)
{*(unsigned char *)p = n;}

void pokew(void * p, unsigned short int n)
{*(unsigned short int *)p = n;}

void poked(void * p, unsigned long int n)
{*(unsigned long int *)p = n;}