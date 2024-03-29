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
zero_one_value: .word 0
zero_two_value: .word 0
four_buff: .space 32
three_buff: .space 32
one_dot: .asciiz "1."

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
    la $a0, nl
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
    la $a0, nl
    li $v0, 4
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
    la $a0, nl
    li $v0, 4
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
    la $a0, nl
    li $v0, 4
    syscall
    j exit

    
# PART 3 -------------------------------------------------------------------
# checks if there is one other arg (F); Leads to part 3
check_one_arg_f:
    lw $t0, num_args
    li $t1, 2
    bne $t0, $t1, exit_invalid_args
    lw $s0, addr_arg1
    li $s1, 0  # length of string
    
check_valid_eight:
    lbu $t0, 0($s0)
    beqz $t0, check_valid_eight_done
    addi $s1, $s1, 1
    addi $s0, $s0, 1
    li $t3, '0'	
    beq $t0, $t3, check_valid_eight
    li $t3, '1'		
    beq $t0, $t3, check_valid_eight
    li $t3, '2'		
    beq $t0, $t3, check_valid_eight
    li $t3, '3'		
    beq $t0, $t3, check_valid_eight
    li $t3, '4'		
    beq $t0, $t3, check_valid_eight
    li $t3, '5'		
    beq $t0, $t3, check_valid_eight
    li $t3, '6'		
    beq $t0, $t3, check_valid_eight
    li $t3, '7'		
    beq $t0, $t3, check_valid_eight
    li $t3, '8'		
    beq $t0, $t3, check_valid_eight
    li $t3, '9'		
    beq $t0, $t3, check_valid_eight
    li $t3, 'A'		
    beq $t0, $t3, check_valid_eight
    li $t3, 'B'		
    beq $t0, $t3, check_valid_eight
    li $t3, 'C'		
    beq $t0, $t3, check_valid_eight
    li $t3, 'D'		
    beq $t0, $t3, check_valid_eight
    li $t3, 'E'		
    beq $t0, $t3, check_valid_eight
    li $t3, 'F'		
    beq $t0, $t3, check_valid_eight
    j exit_invalid_args

check_valid_eight_done:
    # check to see if addr_arg1 is 8 chars
    li $t0, 8
    sub $s1, $s1, $t0	# $s1 = count - 8
    bnez $s1, exit_invalid_args	# exit if arg1 neq 8 chars
    
    lw $s0, addr_arg1
    # if first char = 8, then start checking for zeros at the second char
    li $t1, '8'
    lb $t0, 0($s0)
    bne $t0, $t1, check_if_zero_one_loop
    addi $s0, $s0, 1
    # check if zero  
check_if_zero_one_loop:
    li $t1, '0'
    lb $t0, 0($s0)
    beqz $t0, f_exit_zero
    bne $t0, $t1, not_special_zero
    addi $s0, $s0, 1
    j check_if_zero_one_loop
not_special_zero:      
    # check for +/-INF
    # see if chars 2,3 = "F8"
    lw $s0, addr_arg1
    # if second char = F, then start check third char
    li $t1, 'F'
    lb $t0, 1($s0)
    bne $t0, $t1, not_special_inf
    # if third char = 8, then check 4-8 = 0
    li $t1, '8'
    lb $t0, 2($s0)
    bne $t0, $t1, not_special_inf
    addi $s0, $s0, 3
    # check if zero  
check_if_zero_inf_loop:
    li $t1, '0'
    lb $t0, 0($s0)
    beqz $t0, check_first_inf
    bne $t0, $t1, not_special_inf
    addi $s0, $s0, 1
    j check_if_zero_inf_loop
check_first_inf:
    lw $s0, addr_arg1
    # if first char = F, then neg_infinity
    li $t1, 'F'
    lb $t0, 0($s0)
    beq $t0, $t1, f_exit_neg_inf
    # if first char = 7, then pos_infinity. else, checks if NaN and then converts
    li $t1, '7'
    beq $t0, $t1, f_exit_pos_inf    
not_special_inf:
    # TODO
    # hex -> bin
    # NaN VALUES 
    # FLOATING_POINT VALUES
    la $s0, three_buff
    lw $s1, addr_arg1
    li $s2, 8	# counter
hex_to_bin_loop:
    lbu $t0, 0($s1)
    beqz $t0, hex_to_bin_loop_done
    addi $s1, $s1, 1	# next digit...
    addi $s2, $s2, -1	# decrement counter
    li $t1, '9'
    ble $t0, $t1, add_hex_num
    # add hex letter
    li $t2, '7'
    sub $t0, $t0, $t2    
    j set_val
    # add hex number
    add_hex_num:
    li $t2, '0'
    sub $t0, $t0, $t2
    
    set_val:
    li $t2, 2
    div $t0, $t2	# org num / new base
    mflo $t0		# quotient
    mfhi $t9		# remainder
    div $t0, $t2
    mflo $t0
    mfhi $t8
    div $t0, $t2
    mflo $t0
    mfhi $t7
    div $t0, $t2
    mflo $t0
    mfhi $t6
    sb $t6, 0($s0)
    sb $t7, 1($s0)
    sb $t8, 2($s0)
    sb $t9, 3($s0)

    addi $s0, $s0, 4
    j hex_to_bin_loop
   
hex_to_bin_loop_done: 
    # check if NaN
    la $s0, three_buff
    li $s1, 8	# 8 bits in e
    li $s2, 23	# 23 bits in m
    addi $s0, $s0, 1	# skip first bit (sign not relevant)
    
    check_e_loop:
    lb $t0, 0($s0)
    beqz $s1, check_m_loop
    li $t1, 1
    bne $t0, $t1, not_special_three
    addi $s0, $s0, 1	# next digit...
    addi $s1, $s1, -1	# decrement counter...
    j check_e_loop
    check_m_loop:
    lb $t0, 0($s0)
    beqz $s2, not_special_three
    li $t1, 0
    bne $t0, $t1, f_exit_nan
    addi $s0, $s0, 1	# next digit...
    addi $s2, $s2, -1	# decrement counter...
    j check_m_loop
    
not_special_three:
    la $s0, three_buff
    lb $t0, 0($s0)
    li $t1, 0
    beq $t0, $t1, start_at_one
    la $a0, neg_sign
    li $v0, 4
    syscall
start_at_one:
    la $a0, one_dot
    li $v0, 4
    syscall
    # print mantissa
    la $s0, three_buff
    li $s1, 23	# 23 bits in m
    addi $s0, $s0, 9	# skip first 9 bits
    print_m_loop:
    lb $t0, 0($s0)
    beqz $s1, print_m_loop_done
    lb $a0, 0($s0)
    li $v0, 1
    syscall
    addi $s0, $s0, 1	# next digit...
    addi $s1, $s1, -1	# decrement counter...
    j print_m_loop
print_m_loop_done:
    la $a0, floating_point_str
    li $v0, 4
    syscall
    # convert exponent bits to decimal val
    la $s0, three_buff
    li $s1, 7	# 7 bits left/ in e - starting bit
    li $s2, 0 	# decimal value
    li $s3, 2	# base
    addi $s0, $s0, 1	# skip first bit (sign not relevant here)
    lb $t0, 0($s0)
    add $s2, $s2, $t0	# set init value
    
    convert_fraction_loop:
    lb $t0, 1($s0)
    beqz $s1, convert_fraction_loop_done
    mult $s2, $s3
    mflo $s2
    add $s2, $s2, $t0
    addi $s0, $s0, 1	# next digit...
    addi $s1, $s1, -1	# decrement counter...
    bne $t0, $t1, convert_fraction_loop
    
    j convert_fraction_loop
    
    convert_fraction_loop_done:
    li $t0, 127
    sub $s2, $s2, $t0
    move $a0, $s2
    li $v0, 1
    syscall
    la $a0, nl
    li $v0, 4
    syscall
    j exit
    
    j end_print

# this is to print
#    la $s0, three_buff
#    li $s6, 32
#    la $a0, nl
#    li $v0, 4
#    syscall
#print_bin:
#    
#    lb $a0, 0($s0)
#    li $v0, 1
#    syscall
#    addi $s0, $s0, 1
#    addi $s6, $s6, -1
#    beqz $s6, end_print
#    j print_bin
    
    
end_print:    
    la $a0, nl
    li $v0, 4
    syscall
    j exit 
f_exit_zero:
    la $a0, zero_str
    li $v0, 4
    syscall
    j exit
f_exit_neg_inf:
    la $a0, neg_infinity_str
    li $v0, 4
    syscall
    j exit
f_exit_pos_inf:
    la $a0, pos_infinity_str
    li $v0, 4
    syscall
    j exit
f_exit_nan:
    la $a0, NaN_str
    li $v0, 4
    syscall
    j exit    
    

# PART 4 -------------------------------------------------------------------
# checks if there are three other args (C); Leads to part 4
check_three_arg:
    lw $t0, num_args
    li $t1, 4
    bne $t0, $t1, exit_invalid_args
    # convert addr_arg2 to decimal
    lw $t0, addr_arg2
    move $a0, $t0
    li $v0, 84
    syscall
    move $s1, $v0
    # conver addr_arg3 to decimal
    lw $t0, addr_arg3
    move $a0, $t0
    li $v0, 84
    syscall
    move $s2, $v0
    # validate addr_arg1
    lw $s0, addr_arg1
# checks to make sure each digit in addr_arg1 is < addr_arg2    
validate_part_four_loop:
    lbu $t0, 0($s0)
    beqz $t0, validate_part_four_loop_done
    li $t1, '0'
    sub $t2, $t0, $t1 
    addi $s0, $s0, 1
    bge $t2, $s1, exit_invalid_args
    j validate_part_four_loop

validate_part_four_loop_done:  
    # check if bases are equal. if equal, return
    beq $s1, $s2, exit_equal_bases    
    
    # convert to base 10
    lw $s0, addr_arg1
    lbu $t0, 0($s0)
    li $t1, '0'
    sub $t0, $t0, $t1
    li $s3, 0
    add $s3, $s3, $t0
    
convert_to_decimal_loop: 
    lbu $t0, 1($s0)    
    beqz $t0, convert_to_decimal_loop_done  
    li $t1, '0'
    sub $t0, $t0, $t1
    mult $s3, $s1	# mult curr * org_base
    mflo $s3
    add $s3, $s3, $t0
    addi $s0, $s0, 1
    j convert_to_decimal_loop
    
convert_to_decimal_loop_done:
    li $t0, 10
    bne $s2, $t0, convert_from_decimal
    move $a0, $s3
    li $v0, 1
    syscall
    la $a0, nl
    li $v0, 4
    syscall
    j exit

convert_from_decimal:
    # convert num from string to decimal
    
    li $s5, 0	# value in new base
    li $s4, 1	# place ie 1 10 100
    
    li $s6, 0	# counter
    la $s0, four_buff
    
from_decimal_loop:
    beqz $s3, from_decimal_loop_done
    div $s3, $s2	# org num / new base
    mflo $s3		# quotient to $s0
    mfhi $t0		# remainder
    
    addi $s6, $s6, 1	# increment
    sb $t0, 0($s0)
    addi $s0, $s0, 1
    
    mult $t0, $s4	# remainder * place
    mflo $t1		# $t1 = mult ans
    #add $s5, $s5, $t1	# $s3 = $s3 + new remainder in place
    li $t2, 10
    mult $s4, $t2
    mflo $s4
    j from_decimal_loop
    
from_decimal_loop_done: 
    #move $a0, $s6
    #li $v0, 1
    #syscall
    
    la $s0, four_buff
    add $s0, $s0, $s6
    # add $s0, $s0, $s6
    
reverse:
    addi $s0, $s0, -1
    addi $s6, $s6, -1
    
    lb $a0, 0($s0)
    li $v0, 1
    syscall
    beqz $s6, end
    j reverse
end:
    # move $a0, $s5
    # li $v0, 1
    # syscall
    la $a0, nl
    li $v0, 4
    syscall
    j exit

    
exit_equal_bases:
    lw $s0, addr_arg1
    move $a0, $s0
    li $v0, 4
    syscall
    la $a0, nl
    li $v0, 4
    syscall
    j exit


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
