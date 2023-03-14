
.data
	inputMessage: .asciiz "Enter string here: "
	string: .space 100	#reserve space in increment of 4, or else will mess up other words
	messageYes: .asciiz "The following string is a palindrome: "
	messageNo: .asciiz "The following string is not a palindrome: "
	max: .word 100  #max is 100 bytes,  100 characters 

.text
        li $v0, 4	       #load instruction for printing a string 
        la $a0, inputMessage  #put address of inputmessage into argument argument
        syscall		       #execute
        
	li $v0, 8   	 #load instruction for inputting a string
	la $a0, string  #load address of string
	lw $a1, max	 #load literal max to a1
	syscall		 #execute
	
	li $t0, 0	 #index
	li $t1, 10      #hex decimal for line feed (LF) is A or 10 in decimal;
	
#gets length of string
find_length: #label
	lb $t2, string($t0)     #load byte from string
	beq $t2, $t1, set_index #if string reaches new line(end of word) exit 
	addi $t0, $t0, 1        #increment value of letters
	j find_length	         #loop 

#intialize pointers/indices	
set_index: #this set indices of registers that will check front and back indices match
	li $t3, 0               #have a register equal start 
	addi $t4,$t0,-1         #have a register equal length of string index -1 (bc theres a '\n'
	j check			 #now check if palindrome
	
#checks if palindrome
check: 
	#if front and back index is the same (gone thru whole word) go to isPalindrome
	beq $t3,$t4,is_Palindrome	
	
	#load front byte of string
	lb $t5, string($t3)
	#load back byte of string
	lb $t6, string($t4)
	
	#if not equal, not palindrome, else continue
	bne $t5,$t6, not_Palindrome
		
	#this section is just for even words bc will never have the same index
	addi $s0,$t3,1 #set reg to one more than beginning index
	#if the beginning index + 1 is equal to ending index than it is a Palindrome
	beq $t4,$s0, is_Palindrome
	
	#these are ones (not 4) bc we are loading in bytes
	addi $t3,$t3,1   #increment front index
	addi $t4,$t4,-1  #increment back index
	j check		 #loop
	
#outputs message if not palindrome	
not_Palindrome: 
	li $v0, 4          #instruction to print string
	la $a0, messageNo	    #set address of message to argument reg
	syscall		    #execute
	
	li $v0, 4          #instruction to print string
	la $a0, string	    #set address of message to argument reg
	syscall		    #execute
	
	j loop_end	#exit

#outputs message if is palindrome
is_Palindrome:
		
	li $v0, 4          #instruction to print string
	la $a0, messageYes	    #set address of message to argument reg
	syscall		    #execute
	
	li $v0, 4          #instruction to print string
	la $a0, string	    #set address of message to argument reg
	syscall		    #execute
	
	j loop_end   #exit

#exits	
loop_end: #label			
 	li $v0, 10	    # Exit the program safely
	syscall		    #execute
