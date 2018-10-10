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

### Part I ###
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
	

### Part II ###
strcmp:
	li $v0, -200
	li $v1, -200

	jr $ra


### Part III ###
memcpy:
	li $v0, -200
	li $v1, -200

	jr $ra


### Part IV ###
insert_car:
	li $v0, -200
	li $v1, -200
	

	jr $ra
	

### Part V ###
most_damaged:
	li $v0, -200
	li $v1, -200
	
	jr $ra


### Part VI ###
sort:
	li $v0, -200
	li $v1, -200
	
	jr $ra


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
