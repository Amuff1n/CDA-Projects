.data #this is our array, we only need bytes because we are using decimal numbers under 100
array: .byte 89 19 91 23 31 96 3 67 17 11 43 75
#strings to print later when we have found the max
string1: .asciiz "Index of the largest number: "
string2: .asciiz "\nThe largest number: "

.text
main:
la $a0,array #a0 equals address of array
li $a1,11 #last index is 11
li $t0,0 #$t0 will be our counter, starts at 0
li $s0,0 #s0 will store our max value
li $s1,0 #s1 will store our max value's index
loop:
bgt $t0,$a1 end #when our counter gets to 9, branch to the end
lb $a0,array($t0) #load the byte from array($t0), where $t0 is the index
bgt $a0,$s0 max #if the value at that index is greater than max, branch to max
addi $t0,$t0,1 #add 1 to counter 
j loop

max: 
move $s0,$a0 #save value
move $s1,$t0 #save index
addi $t0,$t0,1 #add 1 to counter
j loop

end:
li $v0,4 #sys call for print_string
la $a0,string1
syscall

li $v0,1 #sys call for print_int
move $a0,$s1
syscall

li $v0,4
la $a0,string2
syscall

li $v0,1
move $a0,$s0
syscall 

li $v0, 10 #syscall for exit
syscall
