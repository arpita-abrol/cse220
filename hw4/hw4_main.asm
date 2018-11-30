.data
map_filename: .asciiz "map3.txt"

# num words for map: 45 = (num_rows * num_cols + 2) // 4 
# map is random garbage initially
.asciiz "Don't touch this region of memory"
map: .word 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 

.asciiz "Don't touch this"
# player struct is random garbage initially
player: .word 0x2912FECD

.asciiz "Don't touch this either"
# visited[][] bit vector will always be initialized with all zeroes
# num words for visited: 6 = (num_rows * num*cols) // 32 + 1
visited: .word 0 0 0 0 0 0 
.asciiz "Really, please don't mess with this string"

welcome_msg: .asciiz "Welcome to MipsHack! Prepare for adventure!\n"
pos_str: .asciiz "Pos=["
health_str: .asciiz "] Health=["
coins_str: .asciiz "] Coins=["
your_move_str: .asciiz " Your Move: "
you_won_str: .asciiz "Congratulations! You have defeated your enemies and escaped with great riches!\n"
you_died_str: .asciiz "You died!\n"
you_failed_str: .asciiz "You have failed in your quest!\n"

.text
j main # idk is this correct?????????????????????????????????????????????????

print_map: # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TO DO
    la $t0, map  # the function does not need to take arguments
        
    
    lbu $t1, 0($t0)
    addi $t0, $t0, 1
    lbu $t2, 0($t0)
    addi $t0, $t0, 1
    
    move $a0, $t1
    li $v0, 1
    syscall
    
    li $a0, '\n'
    li $v0, 11
    syscall
    
    move $a0, $t2
    li $v0, 1
    syscall
    
    li $a0, '\n'
    li $v0, 11
    syscall
    
    mult $t1, $t2
    mflo $t3
    
    move $t9, $t0
    move $t8, $t3
    li $t4, 0	# new line ctr
    print_map_loop:
    	bne $t4, $t2, print_map_loop_cont
	###### new line
	li $a0, '\n'
    	li $v0, 11
    	syscall
    	li $t4, 0
	###### new line
	li $t7, 0	# reset
	print_map_loop_cont:
	beqz $t3, print_map_loop_exit
	lbu $t5, 0($t0)
	
	li $t7, 0x80
	and $t5, $t5, $t7
	bnez $t5, print_map_char
	lbu $t5, 0($t0)
	
	# print ln
	move $a0, $t5
    	li $v0, 11
    	syscall
    	
    	addi $t4, $t4, 1
    	addi $t0, $t0, 1
    	addi $t3, $t3, -1
    	j print_map_loop
	
	print_map_char:
	lbu $t5, 0($t0)
	li $t7, 0x80
	xor $t5, $t5, $t7
	
	# print ln
	move $a0, $t5
    	li $v0, 11
    	syscall
    	
    	addi $t4, $t4, 1
    	addi $t0, $t0, 1
    	addi $t3, $t3, -1
    	j print_map_loop
    print_map_loop_exit:
    	
    	move $t0, $t9
    	move $t3, $t8
    	li $t4, 0
    print_map_two_loop:
    	bne $t4, $t2, print_map_two_loop_cont
	###### new line
	li $a0, '\n'
    	li $v0, 11
    	syscall
    	li $t4, 0
	###### new line
	li $t7, 0	# reset
	print_map_two_loop_cont:
	beqz $t3, print_map_loop_two_exit
	lbu $t5, 0($t0)
	
	li $t9, 0x80
	and $t5, $t5, $t9
	
	bnez $t5, print_map_two_space
	lbu $t5, 0($t0)
	
	# print ln
	move $a0, $t5
    	li $v0, 11
    	syscall
    	
    	addi $t4, $t4, 1
    	addi $t0, $t0, 1
    	addi $t3, $t3, -1
    	j print_map_two_loop
	
	print_map_two_space:
	# print ln
	li $a0, ' '
    	li $v0, 11
    	syscall
    	
    	addi $t4, $t4, 1
    	addi $t0, $t0, 1
    	addi $t3, $t3, -1
    	j print_map_two_loop
    	
    print_map_loop_two_exit:
        jr $ra

print_player_info: # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TO DO
#the idea: print something like "Pos=[3,14] Health=[4] Coins=[1]"
	la $t0, player
	lbu $a0, 0($t0)
	li $v0, 1
	syscall
    	###### new line
	li $a0, '\n'
    	li $v0, 11
    	syscall
	###### new line
	lbu $a0, 1($t0)
	li $v0, 1
	syscall
	###### new line
	li $a0, '\n'
    	li $v0, 11
    	syscall
	###### new line
	lbu $a0, 2($t0)
	li $v0, 1
	syscall
	###### new line
	li $a0, '\n'
    	li $v0, 11
    	syscall
	###### new line
	lbu $a0, 3($t0)
	li $v0, 1
	syscall
	###### new line
	li $a0, '\n'
    	li $v0, 11
    	syscall
	###### new line
	
	jr $ra


##########################################################################################
.globl main
main:
la $a0, welcome_msg
li $v0, 4
syscall

# fill in arguments
la $a0, map_filename
la $a1, map
la $a2, player
jal init_game

# testing... part II---------------------------------
la $a0, map
li $a1, 7
li $a2, 24
jal is_valid_cell

#move $a0, $v0
#li $v0, 1
#syscall

# testing... part III---------------------------------
la $a0, map
li $a1, 4
li $a2, 6
jal get_cell

#move $a0, $v0
#li $v0, 1
#syscall

# testing... part IV---------------------------------
la $a0, map
li $a1, 6
li $a2, 24
li $a3, 0x2E
jal set_cell

#move $a0, $v0
#li $v0, 1
#syscall

# testing part V---------------------------------
la $a0, map
li $a1, 3
li $a2, 2
jal reveal_area

# testing part VI---------------------------------
la $a0, map
la $a1, player
li $a2, 'D'
jal get_attack_target

#move $a0, $v0
#li $v0, 1
#syscall

# fill in arguments part V---------------------------------
#jal reveal_area

li $s0, 0  # move = 0

game_loop:  # while player is not dead and move == 0:

#jal print_map # takes no args

#jal print_player_info # takes no args

# print prompt
la $a0, your_move_str
li $v0, 4
syscall

li $v0, 12  # read character from keyboard
syscall
move $s1, $v0  # $s1 has character entered
li $s0, 0  # move = 0

li $a0, '\n'
li $v0 11
syscall

# handle input: w, a, s or d
# map w, a, s, d  to  U, L, D, R and call player_turn()

# if move == 0, call reveal_area()  Otherwise, exit the loop.

j game_loop

game_over:
#jal print_map
#jal print_player_info
li $a0, '\n'
li $v0, 11
syscall

# choose between (1) player dead, (2) player escaped but lost, (3) player escaped and won

won:
la $a0, you_won_str
li $v0, 4
syscall
j exit

failed:
la $a0, you_failed_str
li $v0, 4
syscall
j exit

player_dead:
la $a0, you_died_str
li $v0, 4
syscall

exit:
li $v0, 10
syscall

.include "hw4.asm"
