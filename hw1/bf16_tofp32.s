.data
input_bf16:   .word 0x3f80    # Example: BF16 value (1.0 in bf16)
output_fp32: .word 0x0       # To store the converted FP32 result

.text
.globl main

main:
    # 1. Load input_bf16 value into t0
    la   t0, input_bf16   # Load address of input_bf16 into t0
    lw   t1, 0(t0)        # Load input_bf16 value (16-bit bf16) into t1

    # 2. Call conversion function bf16_to_fp32
    jal  ra, bf16_to_fp32

    # 3. Store result in output_fp32
    la   t0, output_fp32  # Load address of output_fp32
    sw   t2, 0(t0)        # Store result from t2 (fp32) into output_fp32

    # 4. End the program
    li   a7, 10           # Load system call number 10 (terminate program) into a7
    ecall                 # Make system call to terminate

# Function: bf16_to_fp32
# Input: t1 (16-bit bf16)
# Output: t2 (32-bit FP32 result)
bf16_to_fp32:
    # 1. Convert bf16 to fp32 by shifting left by 16 bits
    slli t2, t1, 16       # Shift left by 16 bits to get the fp32 representation
    ret                   # Return result in t2