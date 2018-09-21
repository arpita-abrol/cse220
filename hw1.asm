# Arpita Abrol
# aabrol
# 111504563

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Output strings
zero_str: .asciiz "Zero\n"
neg_infinity_str: .asciiz "-Inf\n"
pos_infinity_str: .asciiz "+Inf\n"
NaN_str: .asciiz "NaN\n"
floating_point_str: .asciiz "_2*2^"

# Miscellaneous strings
nl: .asciiz "\n"

# Put your additional .data declarations here, if any.
neg_sign: .asciiz "-"
max_neg_value: .asciiz "-2147483648"
tmp1: .asciiz "temp\n"
tmp2: .asciiz "temp2\n"

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beq $a0, 0, zero_args
    beq $a0, 1, one_arg
    beq $a0, 2, two_args
    beq $a0, 3, three_args
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here
zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory
    
start_coding_here:
    # Start the assignment by writing your code here
# PART 1 -------------------------------------------------------------------
    # Check if the first arg is one character
    lw $t0, addr_arg0
    lb $t1, 1($t0)
    bne $t1, $0, exit_invalid_operation	# bne if addr_arg0 is longer than 1 char 
    # Check if addr_arg0 = 2
    lw $t0, addr_arg0
    lb $t0, 0($t0)
    li $t1, '2'
    beq $t0, $t1, check_one_arg_two
    # Check if addr_arg0 = F
    lw $t0, addr_arg0
    lb $t0, 0($t0)
    li $t1, 'F'
    beq $t0, $t1, check_one_arg_f
    # Check if addr_arg0 = C
    lw $t0, addr_arg0
    lb $t0, 0($t0)
    li $t1, 'C'
    beq $t0, $t1, check_three_arg
    # Else if addr_arg0 neq F/2/C
    j exit_invalid_operation
    
# PART 2 -------------------------------------------------------------------
# checks if there is one other arg (2)
check_one_arg_two:
    lw $t0, num_args
    li $t1, 2
    bne $t0, $t1, exit_invalid_args
    # Check if the second arg is >32 chars
    lw $s0, addr_arg1
    li $s1, 0  # length of string
    
count_loop:
    lbu $t0, 0($s0)
    beqz $t0, done_with_count
    addi $s1, $s1, 1
    addi $s0, $s0, 1
    li $t3, '0'			# input validation
    beq $t0, $t3, count_loop	# input validation
    li $t3, '1'			# input validation
    beq $t0, $t3, count_loop	# input validation
    j exit_invalid_args

done_with_count:
#    li $v0, 1
#    move $a0, $s1
#    syscall
    # check to see if addr_arg1 has at most 32 characters
    li $t0, 32
    sub $s1, $s1, $t0	# $s1 = count - 32
    bgtz $s1, exit_invalid_args	# exit if arg1 > 32 chars
    add $s1, $s1, $t0 # $s1 = num of characters
    li $t1, 1
    sub $s1, $s1, $t1
    blez $s1, exit_invalid_args # exit if arg1 < 2 chars
    add $s1, $s1, $t1
    # Check most significant bit
    lw $s0, addr_arg1
    lbu $t0, 0($s0)
    li $t1, '0'
    beq $t0, $t1, pos_number	# pos number
    li $t1, '1'	
    beq $t0, $t1, neg_number	# neg number

# Check for special case- -2^(N-1)
neg_number: 
    li $t0, 32
    bne $s1, $t0, convert_neg_number # special case must have 32 chars
    lw $s0, addr_arg1
    addi $s0, $s0, 1	# increment by 1 so check_if_all_zero_loop starts at second char
# check to make sure all vals besides first are 0
check_if_all_zero_loop:
    lbu $t3, 0($s0)
    beqz $t3, pass_max_neg_check
    addi $s0, $s0, 1
    li $t4, '0'					# input validation
    beq $t3, $t4, check_if_all_zero_loop	# input validation
    j convert_neg_number
# this is the max neg value
pass_max_neg_check:
    la $a0, max_neg_value
    li $v0, 4
    syscall
    j exit
    
# this is a neg value, but not the max neg value    
convert_neg_number:  
    li $s2, 1
    lw $s0, addr_arg1
    li $t2, 0 # counter
find_the_zero_loop:
    lb $t0, 0($s0)
    beqz $t0, find_the_zero_loop_done
    addi $s0, $s0, 1
    addi $t2, $t2, 1
    li $t1, '0'			
    beq $t0, $t1, add_val_total	# input validation
    j find_the_zero_loop

add_val_total:
    li $t3, 0
    sub $t3, $s1, $t2
    li $t4, 1
    li $t5, 2
    li $t6, 1
    li $t8, 0
add_val_total_loop:
    blez $t3, add_new
    mult $t4, $t5
    mflo $t4
    addi $t3, $t3, -1
    j add_val_total_loop
add_new:
    add $s2, $s2, $t4
    j find_the_zero_loop

find_the_zero_loop_done:
    la $a0, neg_sign
    li $v0, 4
    syscall
    move $a0, $s2
    li $v0, 1    
    syscall
    j exit

# check for special case- 0
pos_number:
    li $s2, 0
# check to make sure all vals besides first are 0
check_if_zero_loop:
    lbu $t3, 0($s0)
    beqz $t3, pass_is_zero_check
    addi $s0, $s0, 1
    li $t4, '0'				# input validation
    beq $t3, $t4, check_if_zero_loop	# input validation
    j get_pos_number
# this is zero
pass_is_zero_check:
    li $a0, '0'
    li $v0, 11
    syscall
    j exit

# this is a pos num
get_pos_number:
    li $s2, 0
    lw $s0, addr_arg1
    li $t2, 0 # counter
find_the_one_loop:
    lb $t0, 0($s0)
    beqz $t0, find_the_one_loop_done
    addi $s0, $s0, 1
    addi $t2, $t2, 1
    li $t1, '1'			
    beq $t0, $t1, add_val_total2	# input validation
    j find_the_one_loop

add_val_total2:
    li $t3, 0
    sub $t3, $s1, $t2
    li $t4, 1
    li $t5, 2
    li $t6, 1
    li $t8, 0
add_val_total_loop2:
    blez $t3, add_new2
    mult $t4, $t5
    mflo $t4
    addi $t3, $t3, -1
    j add_val_total_loop2
add_new2:
    add $s2, $s2, $t4
    j find_the_one_loop

find_the_one_loop_done:
    move $a0, $s2
    li $v0, 1    
    syscall
    j exit

    
# PART 3 -------------------------------------------------------------------
# checks if there is one other arg (F); Leads to part 3
check_one_arg_f:
    lw $t0, num_args
    li $t1, 2
    bne $t0, $t1, exit_invalid_args

# PART 4 -------------------------------------------------------------------
# checks if there are three other args (C); Leads to part 4
check_three_arg:
    lw $t0, num_args
    li $t1, 4
    bne $t0, $t1, exit_invalid_args


# below are the exit calls
exit_invalid_operation:
    la $a0, invalid_operation_error
    li $v0, 4
    syscall
    j exit
    
exit_invalid_args:
    la $a0, invalid_args_error
    li $v0, 4
    syscall
    j exit

exit:
    li $v0, 10   # terminate program
    syscall
