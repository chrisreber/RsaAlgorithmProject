.text
.global gcd
.global pow
.global modulo
.global isPrime
.global cpubexp
.global cprivexp
.global encrypt
.global decrypt


gcd:
    # Contributor: 
    # computes and returns the greatest common divisor of two integers


# Function: pow
# Contributor: Andrea
# Purpose: Performs exponentiation of two integers
# Inputs: r0 - Number to raise to a power (num)
#         r1 - Power to raise to (pow)
# Output: r0 - Product

.text
pow:
    # Push lr to stack, store original preserved reg vals
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
   
    # Initialize counter and product
    MOV r4, #0
    MOV r5, #1
    StartMultLoop:
        # If counter >= pow, end loop
        CMP r4, r1
        BGE EndMultLoop
            # Multiply num by itself
            MUL r5, r5, r0

            # Increment counter
            ADD r4, r4, #1
            B StartMultLoop
   
    EndMultLoop:
        # Pop stack and exit
        LDR lr, [sp, #0]
        LDR r4, [sp, #4]
        LDR r5, [sp, #8]
        ADD sp, sp, #12
        MOV pc, lr

# End OF pow

# Function: modulo
# Contributor: Andrea
# Purpose: Function to perform modulo operation
# Inputs: r0 - Dividend (num)
#         r1 - Divisor (mod)
# Output: r0 - Remainder

.text
modulo:
    # Push lr to stack, store original preserved reg vals
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    
    MOV r4, r0      // Store num in r4

    # Calculate modulo
    BL __aeabi_idiv // r0 = num//mod (integer division)
    MUL r5, r0, r1  // r5 = (num//mod) * mod
    SUB r0, r4, r5  // r0 = remainder
  
    # Pop stack and exit
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr 

# END OF modulo

# Function: isPrime
# Contributor: Andrea Henry
# Purpose: Determines whether the input number is prime
# Inputs: r0 - Number to check primality for (num)
# Output: r0 - 0 if number is not prime, 1 if number is prime

.text
isPrime:  
    # Push lr to stack, store original preserved reg vals
    SUB sp, sp, #20
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]

    # num <> 0?
    MOV r1, #0
    CMP r0, #0
    MOVNE r1, #1

    # num <> 1?
    MOV r2, #0
    CMP r0, #1
    MOVNE r2, #1

    # num <> 0 and num <> 1?
    AND r1, r1, r2

    # If false, num = 0 or 1 -> not prime
    MOV r3, #0
    CMP r1, r3
    BEQ SetNotPrime
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
        StartCheckLoop:
            # If counter >= array size, end loop
            CMP r6, r5
            BGE EndCheckLoop

                # Set up inputs for mod: r0 = num, r1 = prime
                MOV r0, r7
                ADD r1, r4, r6, LSL #2
                LDR r1, [r1, #0]

                # num = prime -> isPrime
                CMP r0, r1
                BEQ EndCheckLoop
                    # Calculate num mod prime
                    BL modulo

                    # Divisible by prime -> Not prime
                    CMP r0, #0
                    BEQ SetNotPrime 
                        # Increment counter
                        ADD r6, r6, #1 
                        B StartCheckLoop

        EndCheckLoop:
            # No prime factor or is prime factor -> isPrime
            MOV r0, #1
            B ExitIsPrime
    
    SetNotPrime:
        # Divisible by prime or is 0, 1 -> not isPrime
        MOV r0, #0 
        
    ExitIsPrime:
        # Pop stack and exit
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

