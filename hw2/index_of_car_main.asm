.include "data.asm"
.include "hw2.asm"

.data
nl: .asciiz "\n"
index_of_car_output: .asciiz  "index_of_car output: "
.text

.globl main
main:
# print index_of_car_output
la $a0, index_of_car_output
li $v0, 4
syscall

# define args, call function
la $a0, all_cars
li $a1, 6
li $a2, 2
li $a3, 2017
jal index_of_car

# print output
move $a0, $v0
li $v0, 1
syscall

# print newline
la $a0, nl
li $v0, 4
syscall

# exit
li $v0, 10
syscall


