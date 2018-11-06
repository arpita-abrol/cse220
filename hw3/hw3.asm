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
search_adfgvx_grid:
li $v0, -200
li $v1, -200

jr $ra


#####################################################################
# Part III
map_plaintext:
li $v0, -200
li $v1, -200

jr $ra


#####################################################################
# Part IV
swap_matrix_columns:
li $v0, -200
li $v1, -200

jr $ra


#####################################################################
# Part V
key_sort_matrix:
li $v0, -200
li $v1, -200

jr $ra


#####################################################################
# Part IV
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
