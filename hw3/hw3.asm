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
	#move $t9, $a0
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
#move $a0, $t9
#li $v0, 4
#syscall
#li $a0, '\n'
#li $v0, 11
#syscall
	jr $ra


#####################################################################
# Part V
# void key_sort_matrix(char[][] matrix, int num_rows, int num_cols, T[] key, int elem_size)
key_sort_matrix:
	# variable for fifth arg
	lb $t0, 0($sp)
	
	# store stack
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	
	# store all args in s registers
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	move $s7, $a3
	move $s4, $t0
	
	li $s5, 0	# ctr... i
	li $s6, 0	# ctr... j
	
	beq $s4, 4, key_sort_matrix_loop_word
	
key_sort_matrix_loop:
	beq $s5, $s2, key_sort_matrix_exit
	
	move $s3, $s7	# reset array
	li $s6, 0
	key_sort_matrix_loop_two:
		move $t2, $s2
		sub $t2, $t2, $s5
		addi $t2, $t2, -1
		bge $s6, $t2, key_sort_matrix_loop_resume
		
		# get key[j] and key[j+1]
		lb $t0, ($s3)
		add $s3, $s3, $s4
		lb $t1, ($s3)
	
		ble $t0, $t1, key_sort_matrix_loop_two_increment
		# swap pos in key
		sb $t0, ($s3)
		sub $s3, $s3, $s4
		sb $t1, ($s3)
		add $s3, $s3, $s4
		
		# swap cols
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		move $a3, $s6
		addi $s6, $s6, 1
		addi $sp, $sp, -8
		sw $s6, 0($sp)
		sw $ra, 4($sp)
		jal swap_matrix_columns
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		addi $s6, $s6, -1
		
		key_sort_matrix_loop_two_increment:
		addi $s6, $s6, 1
		j key_sort_matrix_loop_two
	
	key_sort_matrix_loop_resume:
	
	addi $s5, $s5, 1
	j key_sort_matrix_loop
	
key_sort_matrix_loop_word:
	beq $s5, $s2, key_sort_matrix_exit
	
	move $s3, $s7	# reset array
	li $s6, 0
	key_sort_matrix_loop_two_word:
		move $t2, $s2
		sub $t2, $t2, $s5
		addi $t2, $t2, -1
		bge $s6, $t2, key_sort_matrix_loop_resume_word
		
		# get key[j] and key[j+1]
		lw $t0, ($s3)
		add $s3, $s3, $s4
		lw $t1, ($s3)
	
		ble $t0, $t1, key_sort_matrix_loop_two_increment_word
		# swap pos in key
		sw $t0, ($s3)
		sub $s3, $s3, $s4
		sw $t1, ($s3)
		add $s3, $s3, $s4
		
		# swap cols
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		move $a3, $s6
		addi $s6, $s6, 1
		addi $sp, $sp, -8
		sw $s6, 0($sp)
		sw $ra, 4($sp)
		jal swap_matrix_columns
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		addi $s6, $s6, -1
		
		key_sort_matrix_loop_two_increment_word:
		addi $s6, $s6, 1
		j key_sort_matrix_loop_two_word
	
	key_sort_matrix_loop_resume_word:
	
	addi $s5, $s5, 1
	j key_sort_matrix_loop_word

key_sort_matrix_exit:
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
	# exit
	jr $ra


#####################################################################
# Part VI
# int transpose(char[][] matrix_src, char[][] matrix_dest, int num_rows, int num_cols)
transpose:
	
	# error checking
	li $v0, -1
	blez $a2, transpose_exit
	blez $a3, transpose_exit
	
	# error checking complete
	li $v0, 0
	
	li $t0, 0	# row counter
	li $t1, 0	# col ctr
	move $t3, $a0	# copy init pos
	
transpose_loop:
	beq $t1, $a3, transpose_exit
	move $a0, $t3
	li $t0, 0
	transpose_row_loop:
		beq $t0, $a2, transpose_row_exit
		lbu $t2, ($a0)
		sb $t2, ($a1)
		addi $t0, $t0, 1
		add $a0, $a0, $a3
		addi $a1, $a1, 1
		j transpose_row_loop
	transpose_row_exit:
	addi $t3, $t3, 1
	addi $t1, $t1, 1
	j transpose_loop
	
transpose_exit:
	jr $ra


#####################################################################
# Part VII
# void encrypt(char[][] adfgvx_grid, String plaintext, String keyword, char[] ciphertext)
encrypt:
	# store stack
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	
	# store all args in s registers
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
# create heap_cipher_text
# get length of plaintext * 2
	li $t0, 0	# ctr
	move $t1, $a1	# plaintext address
encrypt_plaintext_loop:
	lbu $t2, ($t1)
	beqz $t2, encrypt_plaintext_exit
	addi $t0, $t0, 2	# add 2 bc mapping will give two chars per input char
	addi $t1, $t1, 1
	j encrypt_plaintext_loop

encrypt_plaintext_exit:
	# make the length of plaintext a multiple of the keyword size
	
	# get rows, cols of heap_ciphertext_array
	# cols = length of keyword; $s6
	# rows = length of plaintext * 2 / cols; $s5
	li $s6, 0
	move $t2, $s2	# $t2 = keyword address
encrypt_keyword_length_loop:
	lbu $t3, ($t2)
	beqz $t3, encrypt_keyword_length_exit
	addi $s6, $s6, 1
	addi $t2, $t2, 1
	j encrypt_keyword_length_loop

encrypt_keyword_length_exit:	
	div $t0, $s6	# length of plaintext * 2 / cols
	mflo $s5	# set $s5 to quotient
	# check for remainder
	mfhi $t2
	beqz $t2, encrypt_heap_ciphertext_array_create
	addi $s5, $s5, 1
	mult $s5, $s6
	mflo $t0
	
encrypt_heap_ciphertext_array_create:
	# create heap_ciphertext_array, $v0
	move $s7, $t0	# save length of array
	move $a0, $s7
	li $v0, 9
	syscall
	
	move $s4, $v0	# heap_ciphertext_array address
	li $t1, '*'	# set to asterik
	
# fill heap_ciphertext_array with asteriks
encrypt_heap_ciphertext_array_fill_loop:
	beqz $t0, encrypt_heap_ciphertext_array_fill_exit
	sb $t1, ($v0)
	addi $v0, $v0, 1	# move to next byte
	addi $t0, $t0, -1	# decrement counter
	j encrypt_heap_ciphertext_array_fill_loop
	
encrypt_heap_ciphertext_array_fill_exit:
	# call map_plaintext
	move $a0, $s0
	move $a1, $s1
	move $a2, $s4	# set $a2 to buffer
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal map_plaintext
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# call key_sort_matrix
	move $a0, $s4	# matrix = heap_ciphertext_array
	move $a1, $s5	# num_rows
	move $a2, $s6	# num_cols
	move $a3, $s2	# key
	addi $sp, $sp, -8
	li $t0, 1	# elem_size
	sw $t0, 0($sp)
	sw $ra, 4($sp)
	jal key_sort_matrix
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	# transpose the matriz
	move $a0, $s4	# matrix_source
	move $a1, $s3	# matrix dest
	move $a2, $s5	# num_rows
	move $a3, $s6	# num_cols
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal transpose
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# null-terminate ciphertext
	add $s3, $s3, $s7
	li $t0, '\0'
	sb $t0, ($s3)
	

encrypt_exit:
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
	# exit
	jr $ra


#####################################################################
# Part VIII
# (int, char) lookup_char(char[][] adfgvx_grid, char row_char, char col_char)
lookup_char:
	# store stack
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	# move args to s registers
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	# get index of chars
	move $a0, $s1
	sw $ra, 12($sp)
	jal get_one_adfgvx_char
	lw $ra, 12($sp)
	move $s1, $v0
	
	move $a0, $s2
	sw $ra, 12($sp)
	jal get_one_adfgvx_char
	lw $ra, 12($sp)
	move $s2, $v0
	
	# index checking
	li $v0, -1
	beq $s1, -1, lookup_char_exit
	beq $s2, -1, lookup_char_exit
	
	li $v0, 0	# error checking passed
	
	# get char from grid
	li $t0, 6		# row_size
	mult $s1, $t0
	mflo $t0
	add $t0, $t0, $s2
	
	add $s0, $s0, $t0
	lb $v1, ($s0)

lookup_char_exit:
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 16
	# exit
	jr $ra

# helper function
# (int) get_one_adfgvx_char( char )
get_one_adfgvx_char:
	li $t0, 'A'
	li $t1, 0
	beq $a0, $t0, get_one_adfgvx_char_return
	li $t0, 'D'
	li $t1, 1
	beq $a0, $t0, get_one_adfgvx_char_return
	li $t0, 'F'
	li $t1, 2
	beq $a0, $t0, get_one_adfgvx_char_return
	li $t0, 'G'
	li $t1, 3
	beq $a0, $t0, get_one_adfgvx_char_return
	li $t0, 'V'
	li $t1, 4
	beq $a0, $t0, get_one_adfgvx_char_return
	li $t0, 'X'
	li $t1, 5
	beq $a0, $t0, get_one_adfgvx_char_return
	li $t1, -1	# not found
	get_one_adfgvx_char_return:
	move $v0, $t1
	jr $ra
#####################################################################
# Part IX
# void string_sort(String str)
string_sort:

	li $t0, 0	# length n of str
	move $t1, $a0

string_sort_length:
	lbu $t2, ($t1)
	beqz $t2, string_sort_length_exit
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j string_sort_length
	
string_sort_length_exit:
	li $t1, 0	# $t1 = i
	
string_sort_loop:
	beq $t1, $t0, string_sort_exit
	
	move $t4, $a0	# reset array
	li $t2, 0	# $t2, j
	string_sort_loop_two:
		move $t3, $t0		# $t3 = n
		sub $t3, $t3, $t1	# n - i
		addi $t3, $t3, -1	# n - i - 1
		bge $t2, $t3, string_sort_loop_resume
		
		# get key[j] and key[j+1]
		lb $t5, ($t4)
		addi $t4, $t4, 1
		lb $t6, ($t4)
	
		ble $t5, $t6, string_sort_loop_two_increment
		# swap pos in key
		sb $t5, ($t4)
		addi $t4, $t4, -1
		sb $t6, ($t4)
		addi $t4, $t4, 1
		
		string_sort_loop_two_increment:
		addi $t2, $t2, 1
		j string_sort_loop_two
	
	string_sort_loop_resume:
	
	addi $t1, $t1, 1
	j string_sort_loop
	
string_sort_exit:
	jr $ra


#####################################################################
# Part X
# void decrypt(char[][] adfgvx_grid, String ciphertext, String keyword, String plaintext)
decrypt:
	# store stack
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	
	# store all args in s registers
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	#  use sbrk to copy keyword, heap_keyword
	li $t0, 0	# length n of str
	move $t1, $s2

decrypt_keyword_length:
	lb $t2, ($t1)
	beqz $t2, decrypt_keyword_length_exit
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j decrypt_keyword_length
	
decrypt_keyword_length_exit:
	move $a0, $t0
	li $v0, 9
	syscall
	move $s4, $v0	# set $s4 to heap_keyword
	
	move $t1, $s2
decrypt_keyword_copy_loop:
	lbu $t2, 0($t1)
	beqz $t2, decrypt_keyword_copy_exit
	sb $t2, 0($s4)
	addi $t1, $t1, 1
	addi $s4, $s4, 1
	j decrypt_keyword_copy_loop

decrypt_keyword_copy_exit:
	move $s7, $t0	# store keyword length
	# reset
	sub $s4, $s4, $s7
	
	# call string_sort on heap_keyword
	move $a0, $s4
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal string_sort
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# use sbrk to create heap_keyword_indices
	move $a0, $t0
	li $v0, 9
	syscall
	move $s5, $v0	# $s5 = heap_keyword_indices = new int[size]
	
	li $s6, 0	# counter
# 'undo' heap sorting
decrypt_heap_keyword_indices_fill_loop:
	beq $s6, $s7, decrypt_heap_keyword_indices_fill_exit
	lbu $t1, ($s4)
	# call index_of
	move $a0, $s2
	move $a1, $t1
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal index_of
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	sb $v0, ($s5)
	
	# increment
	addi $s6, $s6, 1
	addi $s4, $s4, 1
	addi $s5, $s5, 1
	j decrypt_heap_keyword_indices_fill_loop
		
decrypt_heap_keyword_indices_fill_exit:	
	# reset $s4, $s5
	sub $s4, $s4, $s7
	sub $s5, $s5, $s7
	
# get size of ciphertext (to get num cols... num rows = size keyword = $s7)
	li $t0, 0	# length n of str
	move $t1, $s1

decrypt_ciphertext_length:
	lbu $t2, ($t1)
	beqz $t2, decrypt_ciphertext_length_exit
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j decrypt_ciphertext_length
	
decrypt_ciphertext_length_exit:
	div $t0, $s7	# length of ciphertext / rows
	mflo $s6	# set $s6 to quotient
	# check for remainder
	mfhi $t2
	beqz $t2, decrypt_ciphertext_transpose
	addi $s6, $s6, 1
	
# transpose the ciphertext
decrypt_ciphertext_transpose:
	# create heap_ciphertext_array
	move $a0, $t0
	li $v0, 9
	syscall
	# call transpose
	move $a0, $s1
	move $a2, $s7
	move $a3, $s6
	
	move $s2, $s7	# $s2 = num_rows (num_cols after transpose)
	
	move $s7, $v0	# replace num_rows with heap_ciphertext_array
	move $a1, $s7
	
	move $s1, $s6	# $s1 = num_cols (num_rows after transpose)
	
	move $s6, $t0	# replace num_cols with length of ciphertext
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal transpose
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# "unsort" the matrix
	move $a0, $s7	# key_sort_matrix
	move $a1, $s1
	move $a2, $s2
	move $a3, $s5	# heap_keyword_indices
	addi $sp, $sp, -8
	li $t0, 1	# elem_size
	sw $t0, 0($sp)
	sw $ra, 4($sp)
	jal key_sort_matrix
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	li $s1, 0
	
# decode heap_ciphertext_array
decrypt_decode_loop:
	beq $s1, $s6, decrypt_exit
	# read out the ADFGVX characters as pair
	lbu $a1, ($s7)
	lbu $a2, 1($s7)
	li $t2, '*'
	beq $t2, $a1, decrypt_exit	# check if finished
	
	# decode using lookup_char
	move $a0, $s0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal lookup_char
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	# append to plaintext
	sb $v1, ($s3)
	
	addi $s1, $s1, 2
	addi $s7, $s7, 2
	addi $s3, $s3, 1
	j decrypt_decode_loop
	
decrypt_exit:
	# append null terminator
	li $t0, '\0'
	sb $t0, 0($s3)
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	addi $sp, $sp, 32
	# exit
	jr $ra
	
# helper function
# (int) index_of( String keyword, char target )
index_of:
	li $t0, 0	# ctr
	
index_of_loop:
	lbu $t1, ($a0)
	beq $t1, $a1, index_of_exit
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	j index_of_loop
	
index_of_exit:
	move $v0, $t0
	# exit
	jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
