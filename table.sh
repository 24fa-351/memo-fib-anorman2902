#!/bin/bash

# Output CSV header with capitalized and bold labels
echo "FIBONACCI INDEX,TYPE,WIDTH,RESULT,REAL TIME,USER TIME,SYS TIME,METHOD" > fib_results.csv

# Define n values for testing iterative (1,000,000,000 to 10,000,000,000) and recursive (10,000 to 10,050)
iterative_n_values=$(seq 1000000000 1000000000 10000000000) # Generates 1,000,000,000, 2,000,000,000, ..., 10,000,000,000
recursive_n_values=$(seq 10000 5 10050)  # Generates 10,000, 10,005, 10,010, ..., 10,050

# Loop over integer types, including the 'short' type
for type in "short" "int" "long" "long_long" "intmax_t"; do

    # Define the width of each type in bits
    case $type in
        short)
            width=16
            ;;
        int)
            width=32
            ;;
        long)
            width=64
            ;;
        long_long)
            width=64
            ;;
        intmax_t)
            width=64 # or more depending on platform
            ;;
    esac

    # Run the iterative method for n values 1,000,000,000 to 10,000,000,000
    for n in $iterative_n_values; do
        # Run iterative version and capture timing
        iterative_output=$( ( /usr/bin/time -p ./fib "$n" i ) 2>&1 )
        
        # Extract real, user, and system times
        real_time=$(echo "$iterative_output" | grep real | awk '{print $2}')
        user_time=$(echo "$iterative_output" | grep user | awk '{print $2}')
        sys_time=$(echo "$iterative_output" | grep sys | awk '{print $2}')
        
        # Get the fib result or detect overflow
        result=$(echo "$iterative_output" | grep -v "real" | grep -v "user" | grep -v "sys" | xargs)
        [[ "$result" == *"OVERFLOW"* ]] && result="OVERFLOW"

        # Append results for iterative method to CSV
        echo "$n,$type,$width,$result,$real_time,$user_time,$sys_time,iterative" >> fib_results.csv
    done

    # Run the recursive method only for n values 10,000 to 10,050
    for n in $recursive_n_values; do
        # Run recursive version and capture timing
        recursive_output=$( ( /usr/bin/time -p ./fib "$n" r ) 2>&1 )
        
        # Extract real, user, and system times
        real_time=$(echo "$recursive_output" | grep real | awk '{print $2}')
        user_time=$(echo "$recursive_output" | grep user | awk '{print $2}')
        sys_time=$(echo "$recursive_output" | grep sys | awk '{print $2}')
        
        # Get the fib result or detect overflow
        result=$(echo "$recursive_output" | grep -v "real" | grep -v "user" | grep -v "sys" | xargs)
        [[ "$result" == *"OVERFLOW"* ]] && result="OVERFLOW"

        # Append results for recursive method to CSV
        echo "$n,$type,$width,$result,$real_time,$user_time,$sys_time,recursive" >> fib_results.csv
    done

done
