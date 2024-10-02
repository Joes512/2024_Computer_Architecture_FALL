    .data
input_float:   .word 0x4049FFFF    # Example: Float value 3.141592
output_bf16:   .word 0x0           # To store the converted BF16 result

    .text
    .globl main

main:
    # 1. Load input_float value into t0
    la   t0, input_float   # Load address of input_float into t0
    lw   t1, 0(t0)         # Load input_float value (32-bit float) into t1

    # 2. Call conversion function fp32_to_bf16
    jal  ra, fp32_to_bf16

    # 3. Store result in output_bf16
    la   t0, output_bf16   # Load address of output_bf16
    sw   t2, 0(t0)         # Store result from t2 (bf16) into output_bf16

    # 4. End the program
    li   a7, 10            # Load system call number 10 (terminate program) into a7
    ecall                  # Make system call to terminate

# Function: fp32_to_bf16
# Input: t1 (32-bit float)
# Output: t2 (16-bit BF16 result)
fp32_to_bf16:
    # 1. Check if NaN
    li   t3, 0x7fffffff    # Mask for ignoring the sign bit
    and  t4, t1, t3        # t4 = u.i & 0x7fffffff

    li   t5, 0x7f800000    # NaN threshold value
    bgt  t4, t5, nan_case  # If (u.i & 0x7fffffff) > 0x7f800000, jump to nan_case

    # 2. Handle normal value, perform BF16 conversion
    li   t3, 0x7fff        # Rounding adjustment value
    srli t4, t1, 16        # Shift right by 16 bits to get the upper half

    # Adjust rounding logic
    li   t5, 0x00008000    # Load immediate for rounding check (bit 16)
    and  t5, t1, t5        # Check if bit 16 is 1 (rounding)
    add  t2, t1, t3        # Add 0x7fff if rounding applies
    srli t2, t2, 16        # Shift result right by 16 bits to get BF16
    ret                    # Return result in t2

nan_case:
    # 3. Handle NaN, set to quiet NaN
    srli t2, t1, 16        # Shift right by 16 bits to get upper 16 bits
    li   t3, 0x0040        # Load immediate for quiet NaN
    or   t2, t2, t3        # Set NaN to quiet NaN
    ret                    # Return result in t2
