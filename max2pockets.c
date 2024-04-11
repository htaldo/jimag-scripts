#include <stdio.h>

int main(void) {
	int n;
	scanf("%d", &n);
	if (n == 1) {
		printf("1");
	}
	else {
		printf("1");
		for(int i=2; i<=n; i++) {
			printf(",%d", i);
		}
	}
	return 0;
}
