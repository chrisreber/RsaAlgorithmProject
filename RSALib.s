.text
.global gcd
.global pow
.global modulo
.global isPrime
.global cpubexp
.global cprivexp
.global encrypt
.global decrypt
.global getPrime

gcd:
  # Contributor: Chris Reber
  # Contributor: Chris Reber
  # computes and returns the greatest common divisor of two integers
  # uses Euclidean algorithm: https://www.geeksforgeeks.org/euclidean-algorithms-basic-and-extended/#
  # args: r0, r1 -> integers between which to compute GCD
  # returns: gcd on r0

  # push the stack
  SUB sp, sp, #12
  STR lr, [sp]
  STR r4, [sp, #4]
  STR r5, [sp, #8]

  # check if r0 is 0
  CMP r0, #0
  BEQ gcdReturn

  # else, compute mod and start new recursive call
  MOV r4, r1  // stash r1 in r4 for safety
  BL modulo   // returns modulo on r0
  MOV r1, r4  // put r4 back in r1 for recursive call
  BL gcd      // recrsively restart function

  gcdReturn:
    MOV r1, r0 // GCD will be in r1 after recursive calls

    # pop the stack and return
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr 
# end gcd

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

# END OF modulo -------

# Function: isPrime
# Contributor: Andrea Henry
# Purpose: Determines whether the input number is prime
# Inputs: r0 - Number to check primality for (num)
# Output: r0 - 0 if num is not prime, 1 if num is prime

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
        # r > 1 - Save base array and array size
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


# END decrypt -------

# Function: getPrime
# Contributor: Andrea Henry
# Purpose: Prompts user for input until they enter positive prime p or q
# Inputs: r0 - 1 if prompting for p, 2 if prompting for q
# Output: r0 - User-input positive prime number

.text
getPrime:
    # Push lr to stack, store original preserved reg vals
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    # Adjust prompt depending on whether prompting for p or q
    CMP r0, #1
    LDREQ r4, =pPrompt
    CMP r0, #2
    LDREQ r4, =qPrompt

    StartGetPrimeLoop:
        # Print prompt
        LDR r0, =primeInputPrompt
        MOV r1, r4  // r4 is input parameter for p or q
        BL printf

        # Get input
        LDR r0, =primeInputFormat
        LDR r1, =inputNum
        BL scanf

        # Check primality
        LDR r0, =inputNum
        LDR r0, [r0]
        MOV r5, r0  // Save input

        # input >= 2?
        MOV r1, #0
        CMP r0, #2
        MOVGE r1, #1
        
        # input <= 50
        MOV r2, #0
        CMP r0, #50
        MOVLE r2, #1
        
        # If input < 2 or > 50, error
        AND r1, r1, r2
        CMP r1, #1
        BNE InvalidInputError

            # If 2 <= input <= 50, test primality
            BL isPrime

            # If input is prime, end loop
            CMP r0, #0
            BNE EndGetPrimeLoop

                # input not prime - Print error and prompt again
                LDR r0, =notPrimeErrorMsg
                BL printf
                B StartGetPrimeLoop

        InvalidInputError:
            # input < 2 or > 50 - Print error and prompt again
            LDR r0, =invalidInputMsg
            BL printf
            B StartGetPrimeLoop

    EndGetPrimeLoop:
        # Restore saved input prime
        MOV r0, r5

        # Pop stack and exit
        LDR lr, [sp, #0]
        LDR r4, [sp, #4]
        LDR r5, [sp, #8]
        ADD sp, sp, #12
        MOV pc, lr

.data
    # Prompt for user input
    primeInputPrompt: .asciz "\nEnter prime number between 2-50 (%s): "
    # Modify input prompt to be for p or q
    pPrompt: .asciz "p"
    qPrompt: .asciz "q"
    # User input and format
    primeInputFormat: .asciz "%d"
    inputNum: .word 0
    # Error messages
    notPrimeErrorMsg: .asciz "ERROR: Input not prime.\n"
    invalidInputMsg: .asciz "ERROR: Input must be >= 2 and <= 50.\n"
