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

#####################################################################
# Part I
# (char, char) get_adfgvx_coords(int index1, int index2)
get_adfgvx_coords:
	# store stack
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	
	# test to see if inputs are valid
	li $v0, -1
	li $v1, -1
	li $t0, 5
	bltz $a0, get_adfgvx_coords_exit
	bltz $a0, get_adfgvx_coords_exit
	bgt $a0, $t0, get_adfgvx_coords_exit
	bgt $a1, $t0, get_adfgvx_coords_exit
	
	move $s0, $a0
	move $s1, $a1
	
	sw $ra, 12($sp)
	jal get_one_adfgvx_coord
	lw $ra, 12($sp)
	move $s2, $v0
	
	sw $ra, 12($sp)
	move $a0, $s1
	jal get_one_adfgvx_coord
	lw $ra, 12($sp)
	
	move $v1, $v0
	move $v0, $s2
	j get_adfgvx_coords_exit
	
get_one_adfgvx_coord:
	li $t0, 'A'
	beq $a0, 0, get_one_adfgvx_coord_return
	li $t0, 'D'
	beq $a0, 1, get_one_adfgvx_coord_return
	li $t0, 'F'
	beq $a0, 2, get_one_adfgvx_coord_return
	li $t0, 'G'
	beq $a0, 3, get_one_adfgvx_coord_return
	li $t0, 'V'
	beq $a0, 4, get_one_adfgvx_coord_return
	li $t0, 'X'
	beq $a0, 5, get_one_adfgvx_coord_return
	get_one_adfgvx_coord_return:
	move $v0, $t0
	jr $ra

# exit function
get_adfgvx_coords_exit:
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	jr $ra


#####################################################################
# Part II
# (int, int) search_adfgvx_grid(char[][] adfgvx_grid, char plaintext_char)
search_adfgvx_grid:
	# initial values
	li $v0, -1
	li $v1, -1
	
	li $t0, 0	# row counter
	li $t1, 0	# col counter
	#li $t3, 0	# ctr
search_adfgvx_grid_loop:
	lbu $t2, ($a0)
	#beq $t3, 36, search_adfgvx_grid_exit
	beqz $t2, search_adfgvx_grid_exit
	beq $t2, $a1, search_adfgvx_grid_found
	addi $t1, $t1, 1
	bne $t1, 6, search_adfgvx_grid_loop_next
	addi $t0, $t0, 1
	li $t1, 0
	search_adfgvx_grid_loop_next:
	addi $a0, $a0, 1
	#addi $t3, $t3, 1
	j search_adfgvx_grid_loop

search_adfgvx_grid_found:
	move $v0, $t0
	move $v1, $t1
	
search_adfgvx_grid_exit:
	jr $ra


#####################################################################
# Part III
# void map_plaintext(char[][] adfgvx_grid, String plaintext, char[][] middletext_buffer)
map_plaintext:
	# store stack
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	# store arguments
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
map_plaintext_loop:
	lbu $t0, ($s1)
	beqz $t0, map_plaintext_exit
	
	# call search_adfgvx_grid
	move $a0, $s0
	move $a1, $t0
	sw $ra, 12($sp)
	jal search_adfgvx_grid
	lw $ra, 12($sp)
	
	# call get_adfgvx_coords
	move $a0, $v0
	move $a1, $v1
	sw $ra, 12($sp)
	jal get_adfgvx_coords
	lw $ra, 12($sp)
	
	# store in buffer
	sb $v0, 0($s2)
	sb $v1, 1($s2)
	
	addi $s1, $s1, 1
	addi $s2, $s2, 2
	j map_plaintext_loop

map_plaintext_exit:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 16
	jr $ra


	#sw $ra, 12($sp)
	#lw $ra, 12($sp)
#####################################################################
# Part IV
# int swap_matrix_columns(char[][] matrix, int num_rows, int num_cols, int col1, int col2)
swap_matrix_columns:
	# variable for fifth arg
	lb $t0, 0($sp)
	
	# error checking
	li $v0, -1
	blez $a1, swap_matrix_columns_exit
	blez $a2, swap_matrix_columns_exit
	bltz $a3, swap_matrix_columns_exit
	bge $a3, $a2, swap_matrix_columns_exit
	bltz $t0, swap_matrix_columns_exit
	bge $t0, $a2, swap_matrix_columns_exit
	
	# check is swapping same col; make $a3 the smaller column
	beq $a3, $t0, swap_matrix_columns_exit
	bgt $t0, $a3, swap_matrix_columns_cont
	move $t1, $t0
	move $t0, $a3
	move $a3, $t1
	
swap_matrix_columns_cont:
	# arguements are valid...
	li $v0, 0
	li $t2, 0	# row ctr
	li $t3, -1	# col ctr

swap_matrix_columns_loop:
	beq $t2, $a1, swap_matrix_columns_exit	# counter - checks if all rows swapped
	move $t1, $a0	# store beginning of row
	li $t3, 0	# col ctr
	# get $a3 value
	swap_matrix_columns_loop_c1:
		beq $t3, $a3, swap_matrix_columns_loop_c1_found
		addi $t3, $t3, 1
		addi $t1, $t1, 1
		j swap_matrix_columns_loop_c1
	swap_matrix_columns_loop_c1_found:
		lbu $t4, ($t1)	# set $t4 to [$t2][col1]
		# reset values....
		move $t1, $a0
		li $t3, 0
		
	# get $t0 value, set it to $a3
	swap_matrix_columns_loop_c2:
		beq $t3, $t0, swap_matrix_columns_loop_c2_found
		addi $t3, $t3, 1
		addi $t1, $t1, 1
		j swap_matrix_columns_loop_c2
	swap_matrix_columns_loop_c2_found:
		lbu $t5, ($t1)	# set $t4 to [$t2][col1]
		sb $t4, ($t1)
		# reset values....
		move $t1, $a0
		li $t3, 0
		
	# set new $a3 value
	swap_matrix_columns_loop_set_c1:
		beq $t3, $a3, swap_matrix_columns_loop_set_c1_found
		addi $t3, $t3, 1
		addi $t1, $t1, 1
		j swap_matrix_columns_loop_set_c1
	swap_matrix_columns_loop_set_c1_found:
		sb $t5, ($t1)	# set $t4 to [$t2][col1]
		# reset values....
		move $t1, $a0
		li $t3, 0
		
	# get to end of row
	swap_matrix_columns_loop_end_r:
		beq $t3, $a2, swap_matrix_columns_loop_next
		addi $a0, $a0, 1
		addi $t3, $t3, 1
		j swap_matrix_columns_loop_end_r
	swap_matrix_columns_loop_next:
	addi $t2, $t2, 1
	j swap_matrix_columns_loop
	

swap_matrix_columns_exit:
	jr $ra


#####################################################################
# Part V
# void key_sort_matrix(char[][] matrix, int num_rows, int num_cols, T[] key, int elem_size)
key_sort_matrix:
li $v0, -200
li $v1, -200

jr $ra


#####################################################################
# Part IV
# int transpose(char[][] matrix_src, char[][] matrix_dest, int num_rows, int num_cols)
transpose:
li $v0, -200
li $v1, -200

jr $ra


#####################################################################
# Part VII
encrypt:
li $v0, -200
li $v1, -200

jr $ra


#####################################################################
# Part VIII
lookup_char:
li $v0, -200
li $v1, -200

jr $ra


#####################################################################
# Part IX
string_sort:
li $v0, -200
li $v1, -200

jr $ra


#####################################################################
# Part X
decrypt:
li $v0, -200
li $v1, -200

jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
