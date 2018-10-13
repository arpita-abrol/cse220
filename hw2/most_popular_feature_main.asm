.include "data.asm"
.include "hw2.asm"

.data
nl: .asciiz "\n"
most_popular_feature_output: .asciiz "most_popular_feature output: "

.text
.globl main
main:
# print most_popular_features
la $a0, most_popular_feature_output
li $v0, 4
syscall
# load args and call function
la $a0, all_cars
li $a1, 6
li $a2, 15
jal most_popular_feature
# print return val
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
