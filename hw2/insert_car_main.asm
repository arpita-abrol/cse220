.include "data.asm"
.include "hw2.asm"

.data
nl: .asciiz "\n"
insert_car_output: .asciiz  "insert_car output: "
test_vin: .asciiz "AAAAABBBBBBBBBBCC"
test_car: .word test_vin
.word make_A
.word model_D
.byte 255, 255
.byte 12, 0

.align 2
expected_all_cars:
.word vin_00
.word make_A
.word model_A
.byte 110, 7
.byte 8
.byte 0

.word vin_01
.word make_D
.word model_B
.byte 115, 7
.byte 8
.byte 0

.word vin_02
.word make_A
.word model_C
.byte 225, 7
.byte 12
.byte 0

.word test_vin
.word make_A
.word model_D
.byte 255, 255
.byte 12, 0

.word vin_03
.word make_E
.word model_D
.byte 175, 7
.byte 10
.byte 0

.word vin_04
.word make_A
.word model_E
.byte 122, 7
.byte 5
.byte 0

.word vin_05
.word make_C
.word model_F
.byte 150, 7
.byte 10
.byte 0

.text
.globl main

main:
# print insert_car_output
la $a0, insert_car_output
li $v0, 4
syscall

# load args and call function
la $a0, all_cars
li $a1, 6
la $a2, test_car
li $a3, 1
jal insert_car

# print return value, 0/-1
move $a0, $v0
li $v0, 1
syscall

# print newline
la $a0, nl
li $v0, 4
syscall

la, $a0, all_cars
li $a1, 7	# NOTE: CHANGE THIS TO 7 ONCE TEST IS COMPLETE
jal print_car_array

la, $a0, expected_all_cars
li $a1, 7
jal print_car_array

# exit
li $v0, 10
syscall

# print_car_array( car cars[], int length)
print_car_array:
	# preserve registers...
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	li $s1, 0	# ctr

print_car_array_loop:
	beq $s1, $a1, print_car_array_done
	move $s0, $a0
	jal print_a_car
	move $a0, $s0
	addi $a0, $a0, 16	# advance array pointer to next element
	addi $s1, $s1, 1	# i = i + 1
	j print_car_array_loop

print_car_array_done:
	li $v0, 0	# return 0
	# print newline
	la $a0, nl
	li $v0, 4
	syscall
	# restore registers
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra # return to caller function
	
# print_a_car( car car )
print_a_car:
	lw $t0, 0($a0)
	lw $t1, 4($a0)
	lw $t2, 8($a0)
	
	lbu $t3, 12($a0)
	lbu $t4, 13($a0)
	# convert to correct year format
	li $t5, 256
	mult $t4, $t5
	mflo $t4
	add $t3, $t3, $t4
	lbu $t4, 14($a0)
	
	move $a0, $t0
	li $v0, 4
	syscall
	# print newline
	la $a0, nl
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 4
	syscall
	# print newline
	la $a0, nl
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 4
	syscall
	# print newline
	la $a0, nl
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall
	# print newline
	la $a0, nl
	li $v0, 4
	syscall
	move $a0, $t4
	li $v0, 1
	syscall
	# print newline
	la $a0, nl
	li $v0, 4
	syscall
	
	jr $ra
	
	







