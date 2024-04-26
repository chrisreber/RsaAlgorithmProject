.text
.global main

main:

	# Display prompts for user actions
	# Contributor: Andrea Henry

    # Push the stack
    SUB sp, sp, #4
    STR lr, [sp, #0]
	
	# Display user actions
	LDR r0, =userActions
	BL printf

	# Get user's choice (fgets avoids loop caused if string is input)
	LDR r0, =inputBuffer
	MOV r1, #40
	LDR r2, =stdin
	LDR r2, [r2]
	BL fgets

	# Parse and store the integer
	BL atoi
	MOV r4, r0

	# Branch to other parts of the function based on selection
	CMP r4, #1
	BEQ GenKeys

		CMP r4, #2
		BEQ EncryptMessage

			CMP r4, #3
			BEQ DecryptMessage

				CMP r4, #4
				BEQ ExitProgram

					# Print invalid input message
					LDR r0, =selectionErrorMsg
					BL printf
					B ExitProgram

	GenKeys:
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

		MOV r0, #252
		MOV r1, #18
		BL gcd
		MOV r1, r0
		LDR r0, =gcdTest
		BL printf
		# -----End Chris testing-----

		# Prompt for and receive input for p and q
		# Contributor: Andrea Henry
	   
		# Call function to get p
		MOV r0, #1  // input parameter = 1 for p
		BL getPrime
		MOV r4, r0  // Save p

		# Call function to get q
		MOV r0, #2  // input parameter = 2 for q
		BL getPrime
		MOV r5, r0  // Save q
	  
		# Calculate modulus n for public and private keys
		# Contributor: Andrea Henry

		MUL r6, r4, r5  // r6 = n = pq

		# Calculate totient, T = (p-1)(q-1)
		# Contributor: Andrea Henry

		SUB r4, r4, #1  // p-1
		SUB r5, r5, #1  // q-1
		MUL r7, r4, r5
			
		# FOR TESTING: Display totient 
		LDR r0, =testTotient
		MOV r1, r7
		BL printf

	  # For future operations, T is in r7. Other regs can be overwritten
  	
	EncryptMessage:

	DecryptMessage:
  
	ExitProgram:
		# Print newline for formatting
		LDR r0, =newLine
		BL printf
		
		# Pop the stack and return
		LDR lr, [sp, #0]
		ADD sp, sp, #4
		MOV pc, lr

.data
	# Starting menu
	userActions: .asciz "\nWelcome to the RSA Algorithm.\n\nChoose an option:\n[1] Generate private and public keys\n[2] Encrypt a message\n[3] Decrypt a message\n[4] Exit\n\nYour Selection: "
	inputBuffer: .space 40
	selectionErrorMsg: .asciz "Invalid selection.\n"
	newLine: .asciz "\n"

    # For testing
    testTotient: .asciz "Totient is: %d\n\n"
    moduloTest:  .asciz "Modulo is: %d\n"
    gcdTest:     .asciz "GCD is: %d\n"
