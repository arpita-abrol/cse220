# Arpita Abrol
# aabrol
# 111504563

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

# $a0 - $a3 	= function arguments
# $v0, $v1 	= return values
# $s0 - $s7 	= local variables
# $t0 - $t9	= temp values
# $sp 		= the stack
########	should preserve changed $s or $ra registers that are changed

#####################################################################
### Part I ###
# int index_of_car(car[] cars, int length, int start_index, int year)
index_of_car:
	# preserve registers...
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	li $v0, -1	# default case for errors...
	li $t0, 1885
	
	# check for any errors
	blez $a1, return_index_of_car	# end if length <= 0
	bltz $a2, return_index_of_car	# end if start_index < 0
	bge $a2, $a1, return_index_of_car	# end if start_index >= length
	blt $a3, $t0, return_index_of_car	# end if year < 1885
	li $s0, 0	# i = 0

start_index_of_car_loop:
	beq $s0, $a2, index_of_car_loop
	addi $a0, $a0, 16	# advance array pointer to next element
	addi $s0, $s0, 1	# i = i + 1
	j start_index_of_car_loop

index_of_car_loop:	
	beq $a2, $a1, return_index_of_car
	lbu $t3, 12($a0)
	lbu $t4, 13($a0)
	# convert to correct year format
	li $t5, 256
	mult $t4, $t5
	mflo $t4
	add $t3, $t3, $t4
	
	beq $t3, $a3, end_index_of_car	# check if years are equal
	addi $a2, $a2, 1
	addi $a0, $a0, 16
	j index_of_car_loop
	
end_index_of_car:
	move $v0, $a2

return_index_of_car:
	# restore registers
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	jr $ra # return to caller function
	
#####################################################################
### Part II ###
# int strcmp(string str1, string str2)
strcmp:
	# preserve registers...
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	# preserve strings
	move $s0, $a0	# $s0 = str1
	move $s1, $a1	# $s1 = str2
	
	# get string lengths
	jal get_string_length
	move $s2, $v0	# $t0 = str1.length()
	move $a0, $s1
	jal get_string_length
	move $s3, $v0	# $t1 = str2.length()
	
	beqz $s2, str_one_zero
	beqz $s3, str_two_zero
	
	li $v0, 0 	# default -- for case when str1 = str2
	li $t2, 0	# ctr
	
strcmp_check:
	lbu $t0, 0($s0)
	lbu $t1, 0($s1)
	bne $t0, $t1, strcmp_not_equal
	beqz $t0, strcmp_end	# if both are equal then if one is null, both are so end
	addi $t2, $t2, 1
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j strcmp_check
	
strcmp_not_equal:
	sub $v0, $t0, $t1
	j strcmp_end

str_one_zero:
	li $t0, 0
	sub $v0, $t0, $s3
	j strcmp_end
	
str_two_zero:
	move $v0, $s2
	j strcmp_end
	
strcmp_end:
	# restore registers	
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra

# int get_string_length(string str)
get_string_length:
	li $t0, 0	# ctr

get_string_length_loop:
	lbu $t1, 0($a0)
	beqz $t1, get_string_length_done
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	j get_string_length_loop
	
get_string_length_done:
	move $v0, $t0
	jr $ra


#####################################################################
### Part III ###
# int memcpy(byte *src, byte *dest, int n)
memcpy:
	li $v0, -1
	blez $a2, return_memcpy	# only possible failure
	
	li $v0, 0	# will be success
	li $t0, 0	# ctr
	
memcpy_loop:
	beq $t0, $a2, return_memcpy
	lbu $t1, 0($a0)
	sb $t1, 0($a1)
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j memcpy_loop
	
return_memcpy:
	jr $ra


#####################################################################
### Part IV ###
# int insert_car(car[] cars, int length, car new_car, int index)
insert_car:
	# preserve registers...
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	# error testing
	li $v0, -1	# return for error
	bltz $a1, return_insert_car	# length < 0
	bltz $a3, return_insert_car	# index < 0
	bgt $a3, $a1, return_insert_car	# index > length
	
	li $v0, 0	# return for success
	
	# store args so can call new functions
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	li $t0, 0	# ctr
	
# loop... get to end
start_insert_car_loop:
	beq $t0, $s1, insert_car_end
	addi $s0, $s0, 16	# advance array pointer to next element
	addi $t0, $t0, 1	# i = i + 1
	j start_insert_car_loop
	
# insert car at end
insert_car_end:
	move $a0, $s2	# src
	move $a1, $s0	# dest
	li $a2, 16	# num bytes
	jal memcpy	# function
	
# check if insert at end
	beq $s1, $s3, return_insert_car
	
# insert new_car not at end
	# make $s4 set for one element before $s0
	move $s4, $s0
	addi $s4, $s4, -16
insert_car_move_loop:
	beq $s1, $s3 insert_car_new
	move $a0, $s4
	move $a1, $s0
	li $a2, 16
	jal memcpy	
	addi $s1, $s1, -1
	addi $s0, $s0, -16
	addi $s4, $s4, -16
	j insert_car_move_loop
	
insert_car_new:
	move $a0, $s2	# src
	move $a1, $s0	# dest
	li $a2, 16	# num bytes
	jal memcpy	# function
	
return_insert_car:
	# restore registers...
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24
	
	jr $ra
	
#####################################################################
### Part V ###
# (int, int) most_damaged(car[] cars, repair[] repairs, int cars_length, int repairs_length)
most_damaged:
	# preserve registers...
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	
	# check for any errors
	li $v0, -1
	li $v1, -1
	blez $a2, return_most_damaged
	blez $a3, return_most_damaged
	
	# store args so can call new functions
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	# set curr max- first car in list
	# move $t0, $s0	# store address for first car
	li $s4, -1		# store index for car - placeholder
	li $s5, -1		# store repair cost for car - placeholder
	
	# go through all cars in list:
	li $s6, 0	# counter / tmp index
most_damaged_cars_loop:
	beq $s6, $s2, most_damaged_cars_done
	move $t0, $s0	# store address for curr car
	
	li $t2, 0	# counter
	li $s7, 0	# tmp cost
	move $s1, $a1
	# get car cost...
	most_damaged_cars_cost_loop:
		beq $t2, $s3, most_damaged_cars_loop_resume
		lw $t1, 0($s1)	# pointer for car in curr repair
		bne $t1, $t0, most_damaged_cars_cost_loop_next	# if curr_car isn't right index, skip
		
		li $t4, 0
		lh $t4, 8($s1)
		add $s7, $s7, $t4	# add repairs
		
		most_damaged_cars_cost_loop_next:
		addi $t2, $t2, 1
		addi $s1, $s1, 12
		j most_damaged_cars_cost_loop
	
	most_damaged_cars_loop_resume: 
	
	ble $s7, $s5, most_damaged_cars_loop_next	
	move $s4, $s6
	move $s5, $s7
	
	most_damaged_cars_loop_next:
	addi $s0, $s0, 16	# go to next car in list
	addi, $s6, $s6, 1	# increment counter
	j most_damaged_cars_loop

most_damaged_cars_done:
	move $v0, $s4
	move $v1, $s5

return_most_damaged:
	# restore registers
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
	jr $ra

#####################################################################
### Part VI ###
# int sort(car[] cars, int length)
sort:
	# preserve registers...
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	
	# check for errors
	li $v0, -1
	blez $a1, return_sort
	
	li $v0, 0	# no error, return 0
	# preserve vals
	move $s0, $a0
	move $s1, $a1
	
	li $s2, 1	# true/false... 0/1
sort_loop:
	beqz $s2, sort_loop_exit
	li $s2, 0	# sorted = True
	
	# first for loop
	li $s3, 1		# i = 1
	addi $s1, $s1, -1	# length - 1
	move $s4, $s0		# cars[0]
	move $s5, $s0		# cars[0]
	addi $s5, $s5, 16	# cars[1]
	sort_loop_one:
		bge $s3, $s1, sort_loop_one_exit
		lh $t0, 12($s4)	# year of cars[i]
		lh $t1, 12($s5) # year of cars[i+1]
		ble $t0, $t1, sort_loop_one_next
		# swap cars now
		move $a0, $s4
		addi $sp, $sp, -16
		move $a1, $sp
		li $a2, 16
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal memcpy
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		move $a0, $s5
		move $a1, $s4
		li $a2, 16
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal memcpy
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		move $a0, $sp
		move $a1, $s5
		li $a2, 16
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal memcpy
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		addi $sp, $sp, 16
		
		li $s2, 1	# set to false
		sort_loop_one_next:
		addi $s4, $s4, 32
		addi $s5, $s5, 32
		addi $s3, $s3, 2
		j sort_loop_one	
	sort_loop_one_exit:
	
	# second for loop
	li $s3, 0		# i = 0
	move $s4, $s0		# cars[0]
	addi $s4, $s4, 16	# cars[1]
	move $s5, $s0		# cars[0]
	addi $s5, $s5, 32	# cars[2]
	sort_loop_two:
		bge $s3, $s1, sort_loop_two_exit
		lh $t0, 12($s4)	# year of cars[i]
		lh $t1, 12($s5) # year of cars[i+1]
		ble $t0, $t1, sort_loop_two_next
		# swap cars now
		move $a0, $s4
		addi $sp, $sp, -16
		move $a1, $sp
		li $a2, 16
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal memcpy
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		move $a0, $s5
		move $a1, $s4
		li $a2, 16
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal memcpy
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		move $a0, $sp
		move $a1, $s5
		li $a2, 16
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal memcpy
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		addi $sp, $sp, 16
		
		li $s2, 1	# set to false
		sort_loop_two_next:
		addi $s4, $s4, 32
		addi $s5, $s5, 32
		addi $s3, $s3, 2
		j sort_loop_two	
	sort_loop_two_exit:
	
	j sort_loop
	
sort_loop_exit:

return_sort:
	# restore registers...
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	addi $sp, $sp, 24
	jr $ra

#####################################################################
### Part VII ###
most_popular_feature:
	li $v0, -200
	li $v1, -200
	
	jr $ra
	

### Optional function: not required for the assignment ###
transliterate:
	li $v0, -200
	li $v1, -200
	
	jr $ra


### Optional function: not required for the assignment ###
char_at:
	li $v0, -200
	li $v1, -200

	jr $ra


### Optional function: not required for the assignment ###
index_of:
	li $v0, -200
	li $v1, -200
		
	jr $ra

#####################################################################
### Part VIII ###
compute_check_digit:
	li $v0, -200
	li $v1, -200
	
	jr $ra	

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
