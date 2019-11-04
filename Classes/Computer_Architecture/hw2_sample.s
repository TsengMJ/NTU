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
# write your recursive code here, input is in a0(x10), store the result(integer type) to t0(x5)
# t1 (x6) t2(x7)
jal x1 RE
beq x0,x0 result
RE:  
    addi sp,sp ,-8
    sw x1 4(sp)
    sw x10 0(sp)
    addi x11, x0 ,2
    bge  x10, x11 ,L1  #(n/2)>=2?
    addi x10, x0 ,1 #else set return value 
    addi x5 , x10,0
    lw x1 4(sp)
    addi sp sp 8
    jalr x0 ,0(x1)
L1:
    srli x10,x10 ,1
    jal x1 RE
    addi x6 ,x10 ,0 #set f(n/2) to x6
    lw x5,0(sp) #load n to x5
    lw x1,4(sp) #return address
    addi sp ,sp ,8 #pop stack
    addi x7 ,x0,2 #set 2 to x7 
    mul x6 ,x6,x7 #mul 2
    add x10 ,x6,x5
    addi x5,x10,0
    jalr x0 ,0(x1)
    
    
    


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
