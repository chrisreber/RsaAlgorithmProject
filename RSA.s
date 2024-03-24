.text
.global main

main:
    # Push the stack
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Prompt for and receive input for p and q
    # Contributor: Andrea Henry
  
    # While p is not prime, get user input
    # r4 - Desired output (1=True for prime)
    # r5 - Primality of p (initialize as 0)
    MOV r4, #0
    MOV r5, #0
    StartGetPLoop:
        # If p is prime, end loop
        CMP r4, r5
        BNE EndGetPLoop
            # Print prompt
            LDR r0, =pInputPrompt
            BL printf

            # Get input
            LDR r0, =pInput
            LDR r1, =p
            BL scanf

            # Check primality of p
            LDR r0, =p
            LDR r0, [r0]
            BL isPrime 

            # If p is prime, end loop
            MOV r5, r0
            CMP r4, r5
            BNE EndGetPLoop
                # Print error message
                LDR r0, =pqErrorMsg
                BL printf
                B StartGetPLoop
      
    EndGetPLoop:            
        # While q is not prime, get user input
        # r4 - Desired output (1=True for prime)
        # r5 - Primality of q (initialize as 0)
        MOV r4, #0
        MOV r5, #0
        StartGetQLoop:
        # If q is prime, end loop
            CMP r4, r5
            BNE EndGetQLoop
                # Print prompt
                LDR r0, =qInputPrompt
                BL printf

                # Get input
                LDR r0, =pInput
                LDR r1, =q
                BL scanf

                # Check primality of q
                LDR r0, =q
                LDR r0, [r0]
                BL isPrime 

                # If q is prime, end loop
                MOV r5, r0
                CMP r4, r5
                BNE EndGetQLoop
                    # Print error message
                    LDR r0, =pqErrorMsg
                    BL printf
                    B StartGetQLoop
      
    EndGetQLoop:           
        # Calculate modulus n for public and private keys
        # Contributor: Andrea Henry

        MOV r5, r1  // Save q
        MUL r6, r4, r5  // r0 = n = pq

        # Calculate totient, T = (p-1)(q-1)
        # Contributor: Andrea Henry

        SUB r4, r4, #1
        SUB r5, r5, #1
        MUL r7, r4, r5
     
  # For future operations, T is in r7. Other regs can be overwritten
  
  
  # pop the stack and return
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr

.data
    # Variables needed for getting p and q from user
    # Prompts
    pInputPrompt: .asciz "Enter a positive integer less than 50 (p): "
    qInputPrompt: .asciz "Enter a postive integer less than 50 (q): "
    # Formatting
    pInput: .asciz "%d"
    qInput: .asciz "%d"
    # User-input values
    p: .word 0
    q: .word 0
    # Error message
    pqErrorMsg: .asciz "Invalid entry.\n"

