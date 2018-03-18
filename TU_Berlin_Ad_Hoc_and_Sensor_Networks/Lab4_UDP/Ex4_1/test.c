#include <stdio.h>

int re_order(int src){
	int i = 0;
	int ret = 0;
	int a[4];
	for(i = 0; i < 4; i++){
		a[i] = src & 0xff;
		src = src >> 8;
		printf("T: %x\n", a[i]);
	}
	ret = (a[0] << 24) + (a[1] << 8) + (a[2] >> 8) + (a[3] >> 24);
	return ret;	
}
int main(){
	printf("%x\n", re_order(97));
	return 0;
}
