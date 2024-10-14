    .data
prices1:     .word 7, 1, 5, 3, 6, 4   # First set of example prices array
prices2:     .word 1, 2, 3, 4, 5      # Second set of example prices array
size1:       .word 6                 # Size of the first array
size2:       .word 5                 # Size of the second array
result:     .word 0                 # Stores the calculated result

# Strings
str_input1:  .string "input: [7, 1, 5, 3, 6, 4]\n"   # First input prompt
str_input2:  .string "input: [1, 2, 3, 4, 5]\n"      # Second input prompt
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

# Function to calculate total profit
calculate_profit:
    li      t1, 0                # t1 = totalProfit (initialize to 0)

    # Load size
    lw      t2, 0(a1)            # t2 = size

    # Loop starts from i = 1 (using t3 as i), compare prices[i] and prices[i-1]
    li      t3, 1

loop:
    beq     t3, t2, end_loop     # If i == size, exit loop

    # Load prices[i] and prices[i-1]
    slli    t4, t3, 2            # Calculate offset 4 * i
    add     t5, a0, t4           # t5 = address pointing to prices[i]
    lw      t6, 0(t5)            # t6 = prices[i]

    addi    t4, t4, -4           # Calculate offset 4 * (i-1)
    add     t5, a0, t4           # t5 = address pointing to prices[i-1]
    lw      t4, 0(t5)            # t4 = prices[i-1]

    # If prices[i] > prices[i-1], add profit
    blt     t6, t4, next_iter    # If prices[i] <= prices[i-1], skip to next iteration
    sub     t6, t6, t4           # t6 = prices[i] - prices[i-1] (profit)
    add     t1, t1, t6           # totalProfit += profit

next_iter:
    addi    t3, t3, 1            # i++
    j       loop                 # Jump back to loop

end_loop:
    # Store result totalProfit into result
    la      t5, result
    sw      t1, 0(t5)
    ret                          # Return

# Function to print a string
print_string:
    li      a7, 4                # syscall 4 is to print a string
    ecall                       # Make system call
    ret                          # Return