.text
.global gcd
.global pow
.global modulo
.global cpubexp
.global cprivexp
.global encrypt
.global decrypt


gcd:
  # Contributor: 
  # computes and returns the greatest common divisor of two integers

pow:
  # Contributor: Andrea
  # Purpose: Performs exponentiation of two integers
  # Inputs: r0 - Number to raise to a power (num)
  #	    r1 - Power to raise to (pow)
  # Output: r0 - Product

  # Internal Note: number and pow should be nonnegative integers 
  # (error checking should happen before passing to this function)

  # Push link register to stack, store all reg vals
  # so original vals are restored when function ends
  SUB sp, sp, #12
  STR lr, [sp, #0]
  STR r4, [sp, #4]
  STR r5, [sp, #8]
   
  # Initialize counter and product
  MOV r4, #0
  MOV r5, #1

  StartMultLoop:

    # If counter >= loop max, end loop
    CMP r4, r1
    BGE EndMultLoop

    # Multiply num by itself and increment counter
    MUL r5, r5, r0
    ADD r4, r4, #1

    B StartMultLoop

  EndMultLoop:
  
  # Restore original values
  LDR r5, [sp, #8]
  LDR r4, [sp, #4]
  LDR lr, [sp, #0]
  ADD sp, sp, #12

  MOV pc, lr
  # End pow

modulo:
  # Contributor: Andrea
  # Purpose: Function to perform modulo operation
  # Inputs: r0 - Dividend (num)
  # 	    r1 - Divisor (mod)
  # Output: r0 - Remainder

  # Internal Note: num and mod should be nonnegative integers 
  # (error checking should happen before passing to this function)
  
  # Push link register to stack, store all reg vals
  # so original vals are restored when function ends
  SUB sp, sp, #12
  STR lr, [sp, #0]
  STR r4, [sp, #4]
  STR r5, [sp, #8]
    
  MOV r4, r0      // Store num in r4 (r0 gets overwritten)
  BL __aeabi_idiv // r0 = num//mod (integer division)
  MUL r5, r0, r1  // r5 = (num//mod) * mod
  SUB r0, r4, r5  // r0 = remainder
  
  # Restore original values
  LDR r5, [sp, #8]
  LDR r4, [sp, #4]
  LDR lr, [sp, #0]
  ADD sp, sp, #12

  MOV pc, lr 
  # End modulo

cpubexp:
  # Contributor:
  # generates the public key

cprivexp:
  # Contributor:
  # generates the private key

encrypt:
  # Contributor:
  # encrypts an input string

decrypt:
  # Contributor:
  # decrypts a .txt file

.data
