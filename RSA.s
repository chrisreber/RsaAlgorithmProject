.text
.global main

main:

	# Display prompts for user actions
	# Contributor: Andrea Henry

    # Push the stack
    SUB sp, sp, #4
    STR lr, [sp, #0]
	
	# Initialize r10 to hold Boolean for whether keys were generated
	MOV r10, #0

	MainMenu:
		# Display user actions
		LDR r0, =userActions
		BL printf

		# Get user's choice
		LDR r0, =selectionFormat
		LDR r1, =selectionInput
		BL scanf
		LDR r4, =selectionInput
		LDR r4, [r4]

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

	    # T is in r7. Other regs can be overwritten

                #STARTING GENERATION OF KEYS
  	        MOV r0, r7
                BL cpubexp

                MOV r1, r0
                MOV r4, r0
                LDR r0, =publicKeyDisplay
                BL printf

                MOV r0, r4
                MOV r1, r7
                BL cprivexp

                MOV r1, r0
                MOV r5, r0
                LDR r0, =privateKeyDisplay
                BL printf
                	
		# Update r10 to True; keys are created
		MOV r10, #1  

		# Print success message and go to menu
		LDR r0, =keysGeneratedMsg
		BL printf
		B MainMenu		

	EncryptMessage:
		
		# See if keys have been generated
		CMP r10, #0
		BNE ContinueEncrypt

			# Notify user that they have to generate keys first
			LDR r0, =needKeysMsg
			BL printf
			B GenKeys

		ContinueEncrypt:
			# Prompt user for string to encrypt
			LDR r0, =encryptPrompt
			BL printf

			# Get input string from user
			SUB sp, sp, #40
			LDR r0, =encryptInputFormat
			ADD r1, sp, #4
			BL scanf

			# Load e and n into r1, r2
			MOV r1, r4
			MOV r2, r6 

			# Encrypt the string
			ADD r0, sp, #4
            MOV r1, r4
			BL encrypt
			ADD sp, sp, #40

			# Return to main menu
			B MainMenu

	DecryptMessage:
  
		# See if keys have been generated
		CMP r10, #0
		BNE ContinueDecrypt

			# Notify user that they have to generate keys first
			LDR r0, =needKeysMsg
			BL printf
			B GenKeys

		ContinueDecrypt:
			MOV r0, r5  // d (private key)
			MOV r1, r6  // n (modulus)			
			BL decrypt

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
	userActions: .asciz "\nChoose an option:\n[1] Generate private and public keys\n[2] Encrypt a message\n[3] Decrypt a message\n[4] Exit\n\nYour Selection: "
	selectionFormat: .asciz "%d"
	selectionInput: .word 0
	selectionErrorMsg: .asciz "Invalid selection.\n"
	needKeysMsg: .asciz "Invalid: Keys not generated. Generating now...\n\n"
        publicKeyDisplay: .asciz "The public key generated is: %d\n"
        privateKeyDisplay: .asciz "The private key generated is: %d\n"
	keysGeneratedMsg: .asciz "Keys generated.\n\n----------\n"
	newLine: .asciz "\n"

	# For encrypt function
	encryptPrompt: .asciz "\nEnter a short phrase: "
	encryptInputFormat: .asciz "%s"

    # For testing
    testTotient: .asciz "Totient is: %d\n\n"
    moduloTest:  .asciz "Modulo is: %d\n"
    gcdTest:     .asciz "GCD is: %d\n"
	testN1: .asciz "N is: %d\n"
	testN2: .asciz "Before encrypt, N is: %d\n"
