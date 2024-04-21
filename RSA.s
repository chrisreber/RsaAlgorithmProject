.text
.global main

main:
    # Push the stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # -----Chris testing-----
    # double check modulo function
    MOV r0, #4
    MOV r1, #3
    BL modulo
    MOV r1, r0
    LDR r0, =moduloTest
    BL printf

    MOV r0, #4
    MOV r1, #1
    BL modulo
    MOV r1, r0
    LDR r0, =moduloTest
    BL printf

    # test greatest common factor function
    MOV r0, #16
    MOV r1, #12
    BL gcd
    MOV r1, r0
    LDR r0, =gcdTest
    BL printf

    MOV r0, #16
    MOV r1, #11
    BL gcd
    MOV r1, r0
    LDR r0, =gcdTest
    BL printf
    # -----End Chris testing-----

    @ # Prompt for and receive input for p and q
    @ # Contributor: Andrea Henry
   
    @ # Call function to get p
    @ MOV r0, #1  // input parameter = 1 for p
    @ BL getPrime
    @ MOV r4, r0  // Save p

    @ # Call function to get q
    @ MOV r0, #2  // input parameter = 2 for q
    @ BL getPrime
    @ MOV r5, r0  // Save q
  
    @ # Calculate modulus n for public and private keys
    @ # Contributor: Andrea Henry

    @ MUL r6, r4, r5  // r6 = n = pq

    @ # Calculate totient, T = (p-1)(q-1)
    @ # Contributor: Andrea Henry

    @ SUB r4, r4, #1  // p-1
    @ SUB r5, r5, #1  // q-1
    @ MUL r7, r4, r5
        
    @ # FOR TESTING: Display totient 
    @ LDR r0, =testTotient
    @ MOV r1, r7
    @ BL printf

  # For future operations, T is in r7. Other regs can be overwritten
  
  
  # pop the stack and return
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
    # For testing
    testTotient: .asciz "Totient is: %d\n\n"
    moduloTest:  .asciz "Modulo is: %d\n"
    gcdTest:     .asciz "GCD is: %d\n"