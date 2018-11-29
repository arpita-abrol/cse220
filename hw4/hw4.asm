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
# int init_game(string map_filename, Map *map_ptr, Player *player_ptr)
init_game:
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	
	# allocate memory on heap
	li $a0, 1	# buffer size = 1 character
	li $v0, 9
	syscall
	move $t6, $v0
	
	# open a file
	li $v0, 13
	move $a0, $t0
	li $a1, 0
	li $a2, 0
	syscall
	move $t4, $v0
	bltz $v0, init_game_exit
	
	# read a file... get NUM_ROWS---------------------------------
	li $t3, 0	# $t3 = value
	
	li $v0, 14
	move $a0, $t4	# curr location
	move $a1, $t6	# input buffer
	li $a2, 1
	syscall
	
	lbu $t8, 0($t6)
	addi $t8, $t8, -48
	
	li $t7, 10
	mult $t8, $t7
	mflo $t3
	
	li $v0, 14
	move $a0, $t4	# curr location
	move $a1, $t6	# input buffer
	li $a2, 1
	syscall
	
	lbu $t8, 0($t6)
	addi $t8, $t8, -48
	
	add $t3, $t3, $t8	# NUM_ROWS
	
	# add to byte 0 of map
	sb $t3, 0($t1)
	
	
	# read a file... get NUM_COLS---------------------------------
	###### skip next char... new line
	li $v0, 14
	move $a0, $t4	# curr location
	move $a1, $t6	# input buffer
	li $a2, 1
	syscall
	###### end skip
	
	li $t8, 0	# $t3 = value
	
	li $v0, 14
	move $a0, $t4	# curr location
	move $a1, $t6	# input buffer
	li $a2, 1
	syscall
	
	lbu $t8, 0($t6)
	addi $t8, $t8, -48
	
	li $t7, 10
	mult $t8, $t7
	mflo $t9
	
	li $v0, 14
	move $a0, $t4	# curr location
	move $a1, $t6	# input buffer
	li $a2, 1
	syscall
	
	lbu $t8, 0($t6)
	addi $t8, $t8, -48
	
	add $t8, $t9, $t8	# NUM_COLS
	
	# add to byte 1 of map
	addi $t1, $t1, 1
	sb $t8, 0($t1)
	addi $t1, $t1, -1
	
	###### skip next char... new line
	li $v0, 14
	move $a0, $t4	# curr location
	move $a1, $t6	# input buffer
	li $a2, 1
	syscall
	###### end skip
	
	# read a file... get MAP_DATA---------------------------------
	move $t0, $t1
	addi $t0, $t0, 2
	mult $t3, $t8
	mflo $t9	# max
	#li $t9, 0	# ctr
	li $t7, 0	# ctr--new line
	init_game_loop:
		bne $t7, $t8, init_game_loop_cont
		###### skip next char... new line
		li $v0, 14
		move $a0, $t4	# curr location
		move $a1, $t6	# input buffer
		li $a2, 1
		syscall
		###### end skip
		li $t7, 0	# reset
		
		init_game_loop_cont:
		beqz $t9, init_game_loop_end
		# read a file
		li $v0, 14
		move $a0, $t4	# curr location
		move $a1, $t6	# input buffer
		li $a2, 1
		syscall
	
		lbu $t5, 0($t6)
		
		# flip MSB
		li $t3, 0x80
		xor $t3, $t5, $t3
	
		# print char---tmp
		#move $a0, $t5
		#li $v0, 11
		#syscall
		
		# add char to map
		sb $t3, 0($t0)
		
		# check if char == @
		li $t3, '@'
		bne $t5, $t3, init_game_loop_checked
		sb $t9, 0($t2)	# tmp... pos = rows*cols - $t9
		
		init_game_loop_checked:
		lbu $t3, 0($t1)
		addi $t0, $t0, 1
		addi $t9, $t9, -1
		addi $t7, $t7, 1
		j init_game_loop
		
	init_game_loop_end:
	
	# Calculate player position
	lbu $t0, 0($t2)
	mult $t3, $t8
	mflo $t9
	
	sub $t0, $t9, $t0	# position
	div $t0, $t8
	
	mflo $t0
	mfhi $t9
	sb $t0, 0($t2)
	addi $t2, $t2, 1
	sb $t9, 0($t2)
	addi $t2, $t2, 1
	
	
	# read a file... get STARTING_HEALTH---------------------------------
	li $t3, 0	# $t3 = value
	
	li $v0, 14
	move $a0, $t4	# curr location
	move $a1, $t6	# input buffer
	li $a2, 1
	syscall
	
	lbu $t8, 0($t6)
	addi $t8, $t8, -48
	
	li $t7, 10
	mult $t8, $t7
	mflo $t3
	
	li $v0, 14
	move $a0, $t4	# curr location
	move $a1, $t6	# input buffer
	li $a2, 1
	syscall
	
	lbu $t8, 0($t6)
	addi $t8, $t8, -48
	
	add $t3, $t3, $t8	# HEALTH
	
	sb $t3, 0($t2)
	
	# byte 4 = 0
	addi $t2, $t2, 1
	li $t0, 0
	sb $t0, 0($t2)
	
	# add to byte 3 of player
	move $t2, $t3
	
	# close a file---------------------------------
	li $v0, 16
	move $a0, $t4
	syscall
	
	li $v0, 0
	
init_game_exit:
	jr $ra


#####################################################################
# Part II
is_valid_cell:
# int is_valid_cell(Map *map_ptr, int row, int col
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	
	lbu $t3, 0($a0)
    	lbu $t4, 1($a0)
    	
    	
	li $v0, -1
	# error checking
	bltz $t1, is_valid_call_exit
	bge $t1, $t3, is_valid_call_exit
	bltz $t2, is_valid_call_exit
	bge $t2, $t4, is_valid_call_exit
	
	
	# error checking complete... is valid
	li $v0, 0
	
is_valid_call_exit:
	jr $ra


#####################################################################
# Part III
# int get_cell(Map *map_ptr, int row, int col
get_cell:
	# store stack
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	# store args
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	# call is_valid_cell
	sw $ra, 12($sp)
	jal is_valid_cell
	lw $ra, 12($sp)
	bltz $v0, get_cell_exit
	
	# call is valid
	lbu $t0, 1($s0)	# $t0 = col length
	mult $t0, $s1	# col length * target row
	mflo $t0
	add $t0, $t0, $a2	# col length * target row + target col
	
	addi $s0, $s0, 2
	
	get_cell_loop:
		beqz $t0,  get_cell_loop_exit
		addi $t0, $t0, -1
		addi $s0, $s0, 1
		j get_cell_loop
	
	get_cell_loop_exit:
	lbu $v0, 0($s0)

get_cell_exit:
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 16
	jr $ra


#####################################################################
# Part IV
set_cell:
li $v0, -200
li $v1, -200
jr $ra


#####################################################################
# Part V
reveal_area:
li $v0, -200
li $v1, -200
jr $ra

#####################################################################
# Part VI
get_attack_target:
li $v0, -200
li $v1, -200
jr $ra

#####################################################################
# Part VII
complete_attack:
li $v0, -200
li $v1, -200
jr $ra

#####################################################################
# Part VIII
monster_attacks:
li $v0, -200
li $v1, -200
jr $ra

#####################################################################
# Part IX
player_move:
li $v0, -200
li $v1, -200
jr $ra

#####################################################################
# Part X
player_turn:
li $v0, -200
li $v1, -200
jr $ra

#####################################################################
# Part XI
flood_fill_reveal:
li $v0, -200
li $v1, -200
jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
