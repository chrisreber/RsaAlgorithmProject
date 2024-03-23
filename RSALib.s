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
  LDR lr, [sp, #0]
  LDR r4, [sp, #4]
  LDR r5, [sp, #8]
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
  LDR lr, [sp, #0]
  LDR r4, [sp, #4]
  LDR r5, [sp, #8]
  ADD sp, sp, #12

  MOV pc, lr 

# End modulo

.text
isPrime:
  # Contributor: Andrea Henry
  # Purpose: Determines whether the input number is prime
  # Inputs: r0 - Number to check primality for (num)
  # Output: r0 - 0 if number is not prime, 1 if number is prime

  SUB sp, sp, #20
  STR lr, [sp, #0]
  STR r4, [sp, #4]
  STR r5, [sp, #8]
  STR r6, [sp, #12]
  STR r7, [sp, #16]

  # Save base array and size
  LDR r4, =primeArray
  LDR r5, =primeArraySize
  LDR r5, [r5]

  MOV r7, r0  // Store num in preserved register
  
  # Initialize loop for checking primes
  # r4 - Array base
  # r5 - End loop index
  # r6 - Counter

  MOV r6, #0
  startCheckLoop:

    # If counter >= array size, end loop
    CMP r6, r5
    BGE endCheckLoop
    
    # Set up inputs for mod: r0 = num, r1 = prime
    MOV r0, r7
    ADD r1, r4, r6, LSL #2
    LDR r1, [r1, #0]
    BL mod

    # num mod prime == 0 --> return 0 (false, not prime)
    CMP r0, #0
    BEQ return
    ADD r6, r6, #1  // Otherwise, increment counter
    B startCheckLoop

  endCheckLoop:

  MOV r0, #1  // No number was divisible, set r0 = 1 (true, prime)
    
  return:
    # Restore all original values
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    ADD sp, sp, #20

    MOV pc, lr

.data
   primeArray:  .word 2
                .word 3
                .word 5
                .word 7
   primeArraySize:  .word 4  

# end isPrime 

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

