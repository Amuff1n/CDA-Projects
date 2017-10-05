.data
string1: .asciiz "\nEnter the first integer n1: " 
string2: .asciiz "\nEnter second integer n2: "
string3: .asciiz "\nThe greatest common divisor of n1 and n2 is "
string4: .asciiz "\nThe least common multiple of n1 and n2 is "
string5: .asciiz "\nInvalide input! Please try again." 

.text
main:
li $s0,0 #s0 stores first int
li $s1,0 #s1 stores second int
li $s2,0 #s2 will store the result of gcd

li $v0,4 #syscall for print_string
la $a0,string1
syscall

li $v0,5 #syscall for read_int
syscall
move $s0, $v0 #store value in s0

li $v0,4 #syscall for print_string
la $a0,string2
syscall 

li $v0,5 #syscall for read_int
syscall
move $s1,$v0 #store value in s1

#check if values are within range, branch to early end if not
bltz $s0,invalid
bltz $s1,invalid
add $t0,$s0,$s1 #add arguments togther, will be 0 only if both are 0
beq $t0,$zero,invalid #branch to early end if both are 0
li $t0,256 #range is [0,255], set $t0 to out of range value
div $s0,$t0 #get quotient of first argument
mflo $t1
bgtz $t1,invalid #if quotient > 0, branch to early end because input is greater than 255
div $s1,$t0
mflo $t1
bgtz $t1,invalid

#store items on stack
addi $sp,$sp,-8
sw $s0,4($sp)
sw $s1,0($sp)

jal gcd #jump to gcd, result will be in #s0
add $s2,$s0,$zero #gcd will be stored in $s3

li $v0,4 #syscall for print_string
la $a0,string3
syscall

li $v0,1 #syscall for print_int
move $a0,$s2
syscall

#load words from stack again for lcm
lw $s1,0($sp)
lw $s0,4($sp)
addi $sp,$sp,8

jal lcm #result stored in $s0

li $v0,4 #syscall for print_string
la $a0,string4
syscall

li $v0,1 #syscall for print_int
move $a0,$s0
syscall

li $v0,10 #terminate
syscall


gcd:
addi $sp,$sp,-4 #make space for $ra
sw $ra,0($sp)

beq $s1,0,R1 #return if int 2 ($s1) is equal to 0
div $s0,$s1 #divide the two numbers, remainder stored in $HI
add $s0,$s1,$zero #move int 2 to int 1
mfhi $s1 #move from $HI into int 2 ($s1)
jal gcd #jump back to gcd again with new arguments (recursive)

R1:
lw $ra, 0($sp)
addi $sp,$sp,4 #add 4 back to stack pointer
jr $ra

lcm:
addi $sp,$sp,-4 #make space for $ra
sw $ra,4($sp)

mult $s0,$s1 #multiply arguments, result stored in $LO
mflo $t0 #move from $LO into $t0
div $t0,$s2 #divide, quotient stored in $L0, remainder should be 0
mflo $s0 #move result into $s0
addi $sp,$sp,4 #move stack pointer back up
jr $ra

invalid:
li $v0,4 #syscall for print_string
la $a0,string5
syscall
j main
