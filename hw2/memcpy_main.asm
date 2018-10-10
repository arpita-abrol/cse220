.include "hw2.asm"

.data
nl: .asciiz "\n"
memcpy_output: .asciiz "memcpy output: "
src: .asciiz "ABCDEFGHIJ"
dest: .asciiz "XXXXXXX"

.text
.globl main
main:
# print asciiz
la $a0, memcpy_output
li $v0, 4
syscall

# define args, call function
la $a0, src
la $a1, dest
li $a2, 7
jal memcpy

# print return int
move $a0, $v0
li $v0, 1
syscall

# print space
li $a0, ' '
li $v0, 11
syscall

# print updated dest
la $a0, dest
li $v0, 4
syscall

# newline
la $a0, nl
li $v0, 4
syscall

# exit
li $v0, 10
syscall
