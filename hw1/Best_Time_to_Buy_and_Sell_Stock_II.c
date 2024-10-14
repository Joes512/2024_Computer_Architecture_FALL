#include <stdio.h>

int maxProfit(int prices[], int length) {
    int maxProfit = 0;
    printf("input:");
    for (int i = 0; i < length; i++) {
        printf("%d ", prices[i]);
        if (i < length - 1 && prices[i] < prices[i + 1])
            maxProfit += prices[i + 1] - prices[i];
    }
    printf("\nresult: %d\n", maxProfit);
    return maxProfit;
}

int main() {
    int prices1[] = {7, 1, 5, 3, 6, 4};
    int prices2[] = {1, 2, 3, 4, 5, 6};
    maxProfit(prices1, sizeof(prices1) / sizeof(prices1[0]));
    maxProfit(prices2, sizeof(prices2) / sizeof(prices2[0]));
    
    return 0;
}