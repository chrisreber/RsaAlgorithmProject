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
  # Performs exponentiation of two integers

  # r4 - Counter
  # r5 - number (input): The number to raise to a power
  # r6 - pow (input): The power to raise the number to (aka loop max)
  # r0 - Product (output)
  
  # Internal Note 1: number and pow should be nonnegative integers 
  # (error checking should happen before passing to this function)
  # Internal Note 2: Need to make sure I 1) didn't mix up registers 
  # in the code and 2) didn't mix up CMP r4, r6 (order matters)

  # Initialize counter and product
  MOV r4, #0
  MOV r0, #1

  StartMultLoop:

    # If counter >= loop max, end loop
    CMP r4, r6
    BGE EndMultLoop

    MUL r0, r0, r5  # Multiply number by itself

    ADD r4, r4, #1  # Increment counter

    B StartMultLoop

  EndMultLoop:
  MOV pc, lr

  # End pow

modulo:
  # Contributor: Andrea
  # Function to perform modulo operation

  # r0 (input) - number, the dividend (I think it has to be r0)
  # r1 (input) - mod, the divisor (I think it has to be r1)
  # r0 (output) - Remainder (Ouptuts have to be r0?)

  # Internal Note 1: number and mod should be nonnegative integers 
  # (error checking should happen before passing to this function)
  # Internal Note 2: Need to make sure I 1) didn't mix up registers 
  # (lots of overwriting happening)
    
  MOV r4, r0      # Copy r0 to r4 (r0 gets overwritten)
  BL __aeabi_idiv # r0 = number//mod (integer division)
  MUL r5, r0, r1  # r5 = (number//mod) * mod (<= original number)
  SUB r0, r4, r5  # Subtract to get remainder
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
