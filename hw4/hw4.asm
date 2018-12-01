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
# int set_cell(Map *map_ptr, int row, int col, char ch)
set_cell:
	# store stack
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	# store args
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	# call is_valid_cell
	sw $ra, 16($sp)
	jal is_valid_cell
	lw $ra, 16($sp)
	bltz $v0, set_cell_exit
	
	# call is valid
	lbu $t0, 1($s0)	# $t0 = col length
	mult $t0, $s1	# col length * target row
	mflo $t0
	add $t0, $t0, $a2	# col length * target row + target col
	
	addi $s0, $s0, 2
	
	set_cell_loop:
		beqz $t0,  set_cell_loop_exit
		addi $t0, $t0, -1
		addi $s0, $s0, 1
		j set_cell_loop
	
	set_cell_loop_exit:
	sb $s3, 0($s0)
	li $v0, 0

set_cell_exit:
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 20
	jr $ra


#####################################################################
# Part V
# void reveal_area(Map *map_ptr, int row, int col)
reveal_area:
	# store stack
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	# store args
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	# set row, col to top left of 3x3
	addi $s1, $s1, -2
	addi $s2, $s2, 2
    	
    	li $s3, 9	# ctr
    	reveal_area_loop:
    		beqz $s3, reveal_area_exit
    		li $t0, 3
    		div $s3, $t0
    		mfhi $t0
    		bnez $t0, reveal_loop_cont
    		addi $s1, $s1, 1
    		addi $s2, $s2, -3
    		
    		reveal_loop_cont:
    		# call get_cell
    		move $a0, $s0
    		move $a1, $s1
    		move $a2, $s2
    		sw $ra, 16($sp)
		jal get_cell
		lw $ra, 16($sp)
		bltz $v0, reveal_loop_next
		move $t0, $v0
		
	
		li $t1, 0x80
		and $t2, $t0, $t1
		beqz $t2, reveal_loop_next
		
		xor $t0, $t0, $t1
		
		# call set_cell
		move $a0, $s0
    		move $a1, $s1
    		move $a2, $s2
    		move $a3, $t0
    		sw $ra, 16($sp)
		jal set_cell
		lw $ra, 16($sp)
			
    		reveal_loop_next:
    		addi $s2, $s2, 1
    		addi $s3, $s3, -1
    		j reveal_area_loop
    		

reveal_area_exit:
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 20
	jr $ra

#####################################################################
# Part VI
# int get_attack_target(Map *map_ptr, Player *player_ptr, char direction)
get_attack_target:
	# store stack
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	# store args
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	lbu $t0, 0($s1)	# row
	lbu $t1, 1($s1)	# col
	
	beq $s2, 'U', get_attack_target_up
	beq $s2, 'D', get_attack_target_down
	beq $s2, 'L', get_attack_target_left
	beq $s2, 'R', get_attack_target_right
	# if program comes here, direction is invalid
	li $v0, -1
	j get_attack_target_exit
	
get_attack_target_up:
	addi $t0, $t0, -1
	j get_attack_target_get
get_attack_target_down:
	addi $t0, $t0, 1
	j get_attack_target_get
get_attack_target_left:
	addi $t1, $t1, -1
	j get_attack_target_get
get_attack_target_right:
	addi $t1, $t1, 1
	j get_attack_target_get

get_attack_target_get:
	move $a0, $s0
	move $a1, $t0
	move $a2, $t1
	sw $ra, 12($sp)
	jal get_cell
	lw $ra, 12($sp)
	
	# check if valid...
	beq $v0, 'm', get_attack_target_exit
	beq $v0, 'B', get_attack_target_exit
	beq $v0, '/', get_attack_target_exit
	
	# if program comes here, cell is invalid or not m B /
	li $v0, -1

get_attack_target_exit:
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 16
	jr $ra

#####################################################################
# Part VII
# void complete_attack(Map *map_ptr, Player *player_ptr, int target_row, int target_col)
complete_attack:
	# store stack
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	# store args
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	# call get_cell
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	sw $ra, 16($sp)
	jal get_cell
	lw $ra, 16($sp)
	
	# case 1 -- 'm'
	bne $v0, 'm', complete_attack_check_two
	# call set_cell
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	li $a3, '$'
	sw $ra, 16($sp)
	jal set_cell
	lw $ra, 16($sp)
	# update player health
	lbu $t0, 2($s1)
	addi $t0, $t0, -1
	sb $t0, 2($s1)
	
	j complete_attack_check_dead
	
	# case 2 -- 'B'
	complete_attack_check_two:
	bne $v0, 'B', complete_attack_check_three
	# call set_cell
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	li $a3, '*'
	sw $ra, 16($sp)
	jal set_cell
	lw $ra, 16($sp)
	# update player health
	lbu $t0, 2($s1)
	addi $t0, $t0, -2
	sb $t0, 2($s1)
	
	j complete_attack_check_dead
	
	# case 3 -- '/'
	complete_attack_check_three:
	# call set_cell
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	li $a3, '.'
	sw $ra, 16($sp)
	jal set_cell
	lw $ra, 16($sp)
	j complete_attack_exit
	
	complete_attack_check_dead:
	lbu $t0, 2($s1)
	bgtz $t0, complete_attack_exit
	# player is dead... update location on map
	lbu $t0, 0($s1)
	lbu $t1, 1($s1)
	# call set_cell
	move $a0, $s0
	move $a1, $t0
	move $a2, $t1
	li $a3, 'X'
	sw $ra, 16($sp)
	jal set_cell
	lw $ra, 16($sp)
	
complete_attack_exit:
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 20
	jr $ra

#####################################################################
# Part VIII
# int monster_attacks(Map *map_ptr, Player *player_ptr)
monster_attacks:
	# store stack
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)

	# preserve args
	move $s0, $a0
	move $s1, $a1
	
	# counter
	li $s2, 0

	# check up
	lbu $t0, 0($s1)
	lbu $t1, 1($s1)
	addi $t0, $t0, -1
	# call get_cell
	move $a0, $s0
	move $a1, $t0
	move $a2, $t1
	sw $ra, 12($sp)
	jal get_cell
	lw $ra, 12($sp)
	# call monster_attacks_get_damage
	move $a0, $v0
	sw $ra, 12($sp)
	jal monster_attacks_get_damage
	lw $ra, 12($sp)
	# add damage
	add $s2, $s2, $v0
	
	# check down
	lbu $t0, 0($s1)
	lbu $t1, 1($s1)
	addi $t0, $t0, 1
	# call get_cell
	move $a0, $s0
	move $a1, $t0
	move $a2, $t1
	sw $ra, 12($sp)
	jal get_cell
	lw $ra, 12($sp)
	# call monster_attacks_get_damage
	move $a0, $v0
	sw $ra, 12($sp)
	jal monster_attacks_get_damage
	lw $ra, 12($sp)
	# add damage
	add $s2, $s2, $v0
	
	# check left
	lbu $t0, 0($s1)
	lbu $t1, 1($s1)
	addi $t1, $t1, -1
	# call get_cell
	move $a0, $s0
	move $a1, $t0
	move $a2, $t1
	sw $ra, 12($sp)
	jal get_cell
	lw $ra, 12($sp)
	# call monster_attacks_get_damage
	move $a0, $v0
	sw $ra, 12($sp)
	jal monster_attacks_get_damage
	lw $ra, 12($sp)
	# add damage
	add $s2, $s2, $v0
	
	# check right
	lbu $t0, 0($s1)
	lbu $t1, 1($s1)
	addi $t1, $t1, 1
	# call get_cell
	move $a0, $s0
	move $a1, $t0
	move $a2, $t1
	sw $ra, 12($sp)
	jal get_cell
	lw $ra, 12($sp)
	# call monster_attacks_get_damage
	move $a0, $v0
	sw $ra, 12($sp)
	jal monster_attacks_get_damage
	lw $ra, 12($sp)
	# add damage
	add $s2, $s2, $v0
	
	# edit return value
	move $v0, $s2
	
monster_attacks_exit:
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 16
	jr $ra

# helper function...
monster_attacks_get_damage:
	li $v0, 1
	beq $a0, 'm', monster_attacks_get_damage_exit
	li $v0, 2	
	beq $a0, 'B', monster_attacks_get_damage_exit
	li $v0, 0
monster_attacks_get_damage_exit:
	jr $ra

#####################################################################
# Part IX
# int player_move(Map *map_ptr, Player *player_ptr, int target_row, int target_col)
player_move:
	# store stack
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	
	# store args
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	# call monster_attacks
	sw $ra, 20($sp)
	jal monster_attacks
	lw $ra, 20($sp)
	
	# update health; check if player dead
	lbu $t0, 2($s1)
	sub $t0, $t0, $v0
	sb $t0, 2($s1)
	blez $t0, player_move_dead
	
	# player does not die... check cell
	# get target cell
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	sw $ra, 20($sp)
	jal get_cell
	lw $ra, 20($sp)
	move $s4, $v0
	
	# ./$/*/> = target---------------------------------------
	
	# get player coords
	lbu $t0, 0($s1)
	lbu $t1, 1($s1)
	
	move $a0, $s0
	move $a1, $t0
	move $a2, $t1
	li $a3, '.'
	sw $ra, 20($sp)
	jal set_cell
	lw $ra, 20($sp)
	
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	li $a3, '@'
	sw $ra, 20($sp)
	jal set_cell
	lw $ra, 20($sp)
	
	# store new coords
	sb $s2, 0($s1)
	sb $s3, 1($s1)
	
	li $v0, 0
	
	bne $s4, '$', player_move_check_four
	lbu $t0, 3($s1)
	addi $t0, $t0, 1
	sb $t0, 3($s1)
	j player_move_exit
	
	player_move_check_four:
	bne $s4, '*', player_move_check_five
	lbu $t0, 3($s1)
	addi $t0, $t0, 5
	sb $t0, 3($s1)
	j player_move_exit
	
	player_move_check_five:
	bne $s4, '>', player_move_exit
	li $v0, -1
	j player_move_exit

# player is dead	
player_move_dead:
	lbu $t0, 0($s1)
	lbu $t1, 1($s1)
	# call set_cell
	move $a0, $s0
	move $a1, $t0
	move $a2, $t1
	li $a3, 'X'
	sw $ra, 20($sp)
	jal set_cell
	lw $ra, 20($sp)
	
	li $v0, 0

player_move_exit:
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	addi $sp, $sp, 24
	jr $ra

#####################################################################
# Part X
# int player_turn(Map *map_ptr, Player *player_ptr, char direction)
player_turn:
	# store stack
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	
	# store args
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	# step 1: check if direction is valid
	li $v0, -1
	lbu $s3, 0($s1)
	lbu $s4, 1($s1)
	bne $s2, 'U', player_turn_check_down
	addi $s3, $s3, -1
	j player_turn_valid_direction
	player_turn_check_down:
	bne $s2, 'D', player_turn_check_left
	addi $s3, $s3, 1
	j player_turn_valid_direction
	player_turn_check_left:
	bne $s2, 'L', player_turn_check_right
	addi $s4, $s4, -1
	j player_turn_valid_direction
	player_turn_check_right:
	bne $s2, 'R', player_turn_exit
	addi $s4, $s4, 1
	
	player_turn_valid_direction:
	# step 3: get_cell
	move $a0, $s0
	move $a1, $s3
	move $a2, $s4
	sw $ra, 20($sp)
	jal get_cell
	lw $ra, 20($sp)
	
	# step 2: check if target index valid
	move $t0, $v0
	li $v0, 0
	bltz $t0, player_turn_exit
	
	# step 3 con't
	beq $t0, '#', player_turn_exit
	
	# step 4
	# call get_attack_target
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	sw $ra, 20($sp)
	jal get_attack_target
	lw $ra, 20($sp)
	
	# check if it is attackable
	bltz $v0, player_turn_move
	# call complete_attack
	move $a0, $s0
	move $a1, $s1
	move $a2, $s3
	move $a3, $s4
	sw $ra, 20($sp)
	jal complete_attack
	lw $ra, 20($sp)
	
	li $v0, 0
	j player_turn_exit
	
	# not attackable--move
	player_turn_move:
	# call player_move
	move $a0, $s0
	move $a1, $s1
	move $a2, $s3
	move $a3, $s4
	sw $ra, 20($sp)
	jal player_move
	lw $ra, 20($sp)
	
player_turn_exit:
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	addi $sp, $sp, 24
	jr $ra

#####################################################################
# Part XI
# int flood_fill_reveal(Map *map_ptr, int row, int col, bit[][] visited)
flood_fill_reveal:
	# store stack
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	
	# store args
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	# check if row, col are valid
	# call get_cell
	li $v0, -1
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
		sw $ra, 16($sp)
		jal get_cell
		lw $ra, 16($sp)
	bltz $v0, flood_fill_reveal_exit
	
	# store $sp
	move $fp, $sp
	sb $s1, 0($fp)	# row
	sb $s2, 1($fp)	# col
	addi $fp, $fp, 2
	
	
	move $a0, $s3
	move $a1, $s1
	move $a2, $s2
	lbu $a3, 1($s0)
		sw $ra, 16($sp)
		jal flood_fill_reveal_set
		lw $ra, 16($sp)
	
	flood_fill_reveal_loop:
		beq $sp, $fp, flood_fill_reveal_loop_exit
		lbu $s2, -1($fp)	# col
		lbu $s1, -2($fp)	# row
		addi $fp, $fp, -1
		
		
		# make visible
		# call: set_cell
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		li $a3, '.'
		sw $ra, 16($sp)
		jal set_cell
		lw $ra, 16($sp)
		
		# check up
		addi $s1, $s1, -1
		# call: get_cell
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		sw $ra, 16($sp)
		jal get_cell
		lw $ra, 16($sp)
		beq $v0, '.', flood_fill_reveal_down_pre
		bne $v0, 174, flood_fill_reveal_down
		flood_fill_reveal_down_pre:
		# call: is visited
		move $a0, $s3
		move $a1, $s1
		move $a2, $s2
		lbu $a3, 1($s0)
		sw $ra, 16($sp)
		jal flood_fill_reveal_set
		lw $ra, 16($sp)
		bnez $v0, flood_fill_reveal_down
		# push new
		sb $s1, 0($fp)	# row
		sb $s2, 1($fp)	# col
		addi $fp, $fp, 2
		
		flood_fill_reveal_down:
		# check down
		addi $s1, $s1, 2
		# call: get_cell
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		sw $ra, 16($sp)
		jal get_cell
		lw $ra, 16($sp)
		beq $v0, '.', flood_fill_reveal_left_pre
		bne $v0, 174, flood_fill_reveal_left
		flood_fill_reveal_left_pre:
		# call: is visited
		move $a0, $s3
		move $a1, $s1
		move $a2, $s2
		lbu $a3, 1($s0)
		sw $ra, 16($sp)
		jal flood_fill_reveal_set
		lw $ra, 16($sp)
		bnez $v0, flood_fill_reveal_left
		# push new
		sb $s1, 0($fp)	# row
		sb $s2, 1($fp)	# col
		addi $fp, $fp, 2
		
		flood_fill_reveal_left:
		# check left
		addi $s2, $s2, -1
		addi $s1, $s1, -1
		# call: get_cell
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		sw $ra, 16($sp)
		jal get_cell
		lw $ra, 16($sp)
		beq $v0, '.', flood_fill_reveal_right_pre
		bne $v0, 174, flood_fill_reveal_right
		flood_fill_reveal_right_pre:
		# call: is visited
		move $a0, $s3
		move $a1, $s1
		move $a2, $s2
		lbu $a3, 1($s0)
		sw $ra, 16($sp)
		jal flood_fill_reveal_set
		lw $ra, 16($sp)
		bnez $v0, flood_fill_reveal_right
		# push new
		sb $s1, 0($fp)	# row
		sb $s2, 1($fp)	# col
		addi $fp, $fp, 2
		
		flood_fill_reveal_right:
		# check right
		addi $s2, $s2, 2
		# call: get_cell
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		sw $ra, 16($sp)
		sw $ra, 16($sp)
		jal get_cell
		lw $ra, 16($sp)
		lw $ra, 16($sp)
		beq $v0, '.', flood_fill_reveal_done_pre
		bne $v0, 174, flood_fill_reveal_done
		flood_fill_reveal_done_pre:
		# call: is visited
		move $a0, $s3
		move $a1, $s1
		move $a2, $s2
		lbu $a3, 1($s0)
		sw $ra, 16($sp)
		jal flood_fill_reveal_set
		lw $ra, 16($sp)
		bnez $v0, flood_fill_reveal_done
		# push new
		sb $s1, 0($fp)	# row
		sb $s2, 1($fp)	# col
		addi $fp, $fp, 2
		
		flood_fill_reveal_done:
		j flood_fill_reveal_loop
		
	flood_fill_reveal_loop_exit:	
	li $v0, 0
	
flood_fill_reveal_exit:
	# restore stack
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	
	addi $sp, $sp, 20
	jr $ra
	
# $a0 = bit vector, $a1 = row, $a2 = col, $a3 = col_length, return = original value
flood_fill_reveal_set:
	li $t0, 0	# ctr
	mult $a1, $a3
	mflo $t0
	add $t0, $t0, $a2
	li $t1, 8
	div $t0, $t1
	mflo $t0
	mfhi $t1
	flood_fill_reveal_set_loop:
		beqz $t0,  flood_fill_reveal_set_exit
		addi $t0, $t0, -1
		addi $a0, $a0, 1
		j flood_fill_reveal_set_loop
flood_fill_reveal_set_exit:
	lb $t0, ($a0)
	
	bne $t1, 0, flood_fill_num_one
	andi $t2, $t0, 0x01
	move $v0, $t2
	ori $t2, $t0, 0x01
	j flood_fill_num_done
	
	flood_fill_num_one:
	bne $t1, 1, flood_fill_num_two
	andi $t2, $t0, 0x02
	move $v0, $t2
	ori $t2, $t0, 0x02
	j flood_fill_num_done
	
	flood_fill_num_two:
	bne $t1, 2, flood_fill_num_three
	andi $t2, $t0, 0x04
	move $v0, $t2
	ori $t2, $t0, 0x04
	j flood_fill_num_done
	
	flood_fill_num_three:
	bne $t1, 3, flood_fill_num_four
	andi $t2, $t0, 0x08
	move $v0, $t2
	ori $t2, $t0, 0x08
	j flood_fill_num_done
	
	flood_fill_num_four:
	bne $t1, 4, flood_fill_num_five
	andi $t2, $t0, 0x10
	move $v0, $t2
	ori $t2, $t0, 0x10
	j flood_fill_num_done
	
	flood_fill_num_five:
	bne $t1, 5, flood_fill_num_six
	andi $t2, $t0, 0x20
	move $v0, $t2
	ori $t2, $t0, 0x20
	j flood_fill_num_done
	
	flood_fill_num_six:
	bne $t1, 6, flood_fill_num_seven
	andi $t2, $t0, 0x40
	move $v0, $t2
	ori $t2, $t0, 0x40
	j flood_fill_num_done
	
	flood_fill_num_seven:
	andi $t2, $t0, 0x80
	move $v0, $t2
	ori $t2, $t0, 0x80
	
	flood_fill_num_done:
	sb $t2, 0($a0)
	jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
