#include <stdio.h>

#define OFFSET(st,field) (size_t)&(((st*)0)->field)

#pragma pack(1)
struct A{
	short a;
	short b;
	char c;
	int d;
	short e;
};

#pragma pack()

#pragma pack(2)
struct B{
	short a;
	short b;
	char c;
	int d;
	short e;
};
#pragma pack()


int main(){
	struct A A1;
	printf("size A: %d, a-%d, b-%d, c-%d, d-%d, e-%d\n", 
		sizeof(struct A),
		OFFSET(struct A, a),
		OFFSET(struct A, b),
		OFFSET(struct A, c),
		OFFSET(struct A, d),
		OFFSET(struct A, e));
	struct B B1;
	printf("size B: %d, a-%d, b-%d, c-%d, d-%d, e-%d\n", 
		sizeof(struct B),
		OFFSET(struct B, a),
		OFFSET(struct B, b),
		OFFSET(struct B, c),
		OFFSET(struct B, d),
		OFFSET(struct B, e));
	return 0;
}
