.include "hw2.asm"

.data
nl: .asciiz "\n"
strcmp_output: .asciiz "strcmp output: "
str1: .asciiz "StonyB"
str2: .asciiz "Stony"

.text
.globl main
main:
la $a0, strcmp_output
li $v0, 4
syscall

# load args, call function
la $a0, str1
la $a1, str2
jal strcmp

# print function call result
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
