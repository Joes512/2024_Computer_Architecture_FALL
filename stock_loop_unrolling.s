    .data
prices1:     .word 7, 1, 5, 3, 6, 4   # First set of example prices array
prices2:     .word 1, 2, 3, 4, 5, 6      # Second set of example prices array
size1:       .word 6                 # Size of the first array
size2:       .word 6                 # Size of the second array
result:     .word 0                 # Stores the calculated result

# Strings
str_input1:  .string "input: [7, 1, 5, 3, 6, 4]\n"   # First input prompt
str_input2:  .string "input: [1, 2, 3, 4, 5, 6]\n"      # Second input prompt
str_output: .string "output: "                      # Output prompt
newline:    .string "\n"                            # Newline character

    .text
    .globl _start
_start:
    # Calculation for the first price array
    la      a0, str_input1        # Load input prompt string
    jal     print_string          # Print input prompt

    la      a0, prices1           # a0 = address pointing to prices1
    la      a1, size1             # a1 = address pointing to size1
    jal     calculate_profit      # Calculate total profit

    la      a0, str_output        # Load output prompt string
    jal     print_string          # Print output prompt

    la      a0, result            # Load result address into a0
    lw      a0, 0(a0)             # Load result
    li      a7, 1                 # syscall 1 is to print an integer
    ecall                       # Make system call

    # Print newline
    la      a0, newline           # Load newline character
    jal     print_string          # Print newline

    # Calculation for the second price array
    la      a0, str_input2        # Load input prompt string
    jal     print_string          # Print input prompt

    la      a0, prices2           # a0 = address pointing to prices2
    la      a1, size2             # a1 = address pointing to size2
    jal     calculate_profit      # Calculate total profit
 
    la      a0, str_output        # Load output prompt string
    jal     print_string          # Print output prompt

    la      a0, result            # Load result address into a0
    lw      a0, 0(a0)             # Load result
    li      a7, 1                 # syscall 1 is to print an integer
    ecall                       # Make system call

    # Print newline
    la      a0, newline           # Load newline character
    jal     print_string          # Print newline

    # Exit program normally
    li      a0, 0                # Exit code 0
    li      a7, 93               # Syscall for exit
    ecall                       # Make system call

# Function to calculate total profit with loop unrolled
calculate_profit:
    li      t1, 0                # t1 = totalProfit (initialize to 0)

    # Load size
    lw      t2, 0(a1)            # t2 = size

    # Manually unroll the loop for each iteration
    # Assuming maximum array size is 6 for unrolling
    lw      t3, 0(a0)            # t3 = prices[0]
    lw      t4, 4(a0)            # t4 = prices[1]
    blt     t4, t3, skip1        # If prices[1] <= prices[0], skip
    sub     t5, t4, t3           # t5 = prices[1] - prices[0] (profit)
    add     t1, t1, t5           # totalProfit += profit
skip1:

    lw      t3, 4(a0)            # t3 = prices[1]
    lw      t4, 8(a0)            # t4 = prices[2]
    blt     t4, t3, skip2        # If prices[2] <= prices[1], skip
    sub     t5, t4, t3           # t5 = prices[2] - prices[1] (profit)
    add     t1, t1, t5           # totalProfit += profit
skip2:

    lw      t3, 8(a0)            # t3 = prices[2]
    lw      t4, 12(a0)           # t4 = prices[3]
    blt     t4, t3, skip3        # If prices[3] <= prices[2], skip
    sub     t5, t4, t3           # t5 = prices[3] - prices[2] (profit)
    add     t1, t1, t5           # totalProfit += profit
skip3:

    lw      t3, 12(a0)           # t3 = prices[3]
    lw      t4, 16(a0)           # t4 = prices[4]
    blt     t4, t3, skip4        # If prices[4] <= prices[3], skip
    sub     t5, t4, t3           # t5 = prices[4] - prices[3] (profit)
    add     t1, t1, t5           # totalProfit += profit
skip4:

    lw      t3, 16(a0)           # t3 = prices[4]
    lw      t4, 20(a0)           # t4 = prices[5]
    blt     t4, t3, skip5        # If prices[5] <= prices[4], skip
    sub     t5, t4, t3           # t5 = prices[5] - prices[4] (profit)
    add     t1, t1, t5           # totalProfit += profit
skip5:

    # Store result totalProfit into result
    la      t5, result
    sw      t1, 0(t5)
    ret                          # Return                   # Return

# Function to print a string
print_string:
    li      a7, 4                # syscall 4 is to print a string
    ecall                       # Make system call
    ret                          # Return