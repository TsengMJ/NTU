.globl __start

.rodata
    msg_input: .string "Enter a number: "
    msg_result: .string "The result is: "
    newline: .string "\n"

.text

__start:
  # prints msg_input
    li a0, 4
    la a1, msg_input
    ecall
  # read from standard input
    li a0, 5
    ecall

################################################################################ 
# write your recursive code here, input is in a0, store the result(integer type) to t0
    jal ra, func
    beq zero, zero, result

func:
    addi sp,sp, -8
    sw ra, 4(sp)
    sw a0, 0(sp)
    li t1, 2
    bge a0, t1, recursive
    li t0, 1
    lw ra, 4(sp)
    addi sp, sp, 8
    jalr zero, 0(ra)
    
recursive:
    srli a0, a0, 1
    jal ra, func
    lw a0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp 8
    slli t0, t0, 1
    add t0, t0, a0
    jalr zero, 0(ra)

################################################################################

result:
  # prints msg_result
    li a0, 4
    la a1, msg_result
    ecall
  # prints the result in t0
    li a0, 1
    mv a1, t0
    ecall
  # ends the program with status code 0
    li a0, 10
    ecall
