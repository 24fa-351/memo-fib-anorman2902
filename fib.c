#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h> // For intmax_t

#define MAX_INDEX 10000  // Increase this if needed

typedef intmax_t fib_type;

// Cache array for memoization
fib_type fib_cache[MAX_INDEX + 1] = {0};

// Core recursive Fibonacci function
fib_type fibonacci_recursive_core(fib_type position) {
    if (position == 1) {
        return 0;
    }
    if (position == 2) {
        return 1;
    }
    
    return fibonacci_recursive_core(position - 1) + fibonacci_recursive_core(position - 2);
}

// Wrapper function with memoization for recursion
fib_type fibonacci_recursive(fib_type position) {
    if (position <= MAX_INDEX && fib_cache[position] != 0) {
        return fib_cache[position];
    }

    fib_type result;
    if (position == 1) {
        result = 0;
    } else if (position == 2) {
        result = 1;
    } else {
        result = fibonacci_recursive(position - 1) + fibonacci_recursive(position - 2);
    }

    if (position <= MAX_INDEX) {
        fib_cache[position] = result;
    }

    return result;
}

// Iterative Fibonacci (without memoization)
fib_type fibonacci_iterative(fib_type position) {
    if (position == 1) {
        return 0;
    }
    if (position == 2) {
        return 1;
    }

    fib_type previous_fib_number = 0;
    fib_type current_fib_number = 1;
    fib_type next_fib_number;

    for (fib_type index = 3; index <= position; index++) {
        next_fib_number = previous_fib_number + current_fib_number;
        previous_fib_number = current_fib_number;
        current_fib_number = next_fib_number;
    }

    return current_fib_number;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <integer> <r|i>\n", argv[0]);
        return 1;
    }

    fib_type command_line_number;
    if (sscanf(argv[1], "%jd", &command_line_number) != 1 || command_line_number < 1) {
        fprintf(stderr, "Error: First argument must be a positive integer.\n");
        return 1;
    }

    char method = argv[2][0];  // Get method ('r' or 'i')
    fib_type fib_result;

    if (method == 'r') {
        fib_result = fibonacci_recursive(command_line_number);
    } else if (method == 'i') {
        fib_result = fibonacci_iterative(command_line_number);
    } else {
        fprintf(stderr, "Invalid method. Use 'r' for recursive or 'i' for iterative.\n");
        return 1;
    }

    printf("%jd\n\n", fib_result);
    return 0;
}
