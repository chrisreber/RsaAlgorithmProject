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
    # computes and returns the greatest common divisor of two integers
	# uses Euclidean algorithm: https://www.geeksforgeeks.org/euclidean-algorithms-basic-and-extended/#
	# args: r0, r1 -> integers between which to compute GCD
	# returns: gcd on r0

	# push the stack
	SUB sp, sp, #8
	STR lr, [sp]
	STR r4, [sp, #4]

	# check if r0 is 0
	CMP r0, #0
	BEQ gcdReturn

	# else, compute mod and start new recursive call
	CMP r0, r1  // compare the args first, higher arg MUST be in r0
	BGE computeMod

	# r1 is bigger than r0, swap the arguments so the modulo function works
	MOV r2, r0
	MOV r0, r1
	MOV r1, r2

	computeMod:
		MOV r4, r1  // stash r1 in r4 for safety
		BL modulo   // returns modulo on r0
		MOV r1, r4  // put r4 back in r1 for recursive call
		BL gcd      // recrsively restart function

	gcdReturn:
		MOV r0, r1 // GCD will be in r1 after recursive calls

		# pop the stack and return
		LDR lr, [sp, #0]
		LDR r4, [sp, #4]
		ADD sp, sp, #8
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

# end pow

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

# end modulo

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

# Function: cpubexp
# Contributor: Kevin Chandran
# Purpose: to prompt for and determine a valid public key exponent
# Inputs: the totient in r0, user input while function is running
# outputs: public key exponent in r0

.text
cpubexp:
    #push stack
    SUB sp, sp, #12
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]

    MOV r4, r0 //moving totient to r4
    
    startLoop:
        LDR r0, =promptEx
        BL printf

        LDR r0, =formatEx
        LDR r1, =pubKeyExp
        BL scanf

    
        LDR r5, =pubKeyExp
        LDR r5, [r5]
        
        CMP r5, #0
        BLEQ invalidExp

        CMP r5, r4
        BGT invalidExp

        MOV r1, r4
        MOV r0, r5
        BL gcd
        CMP r0, #1
        BNE invalidExp

        B validExp

    invalidExp:
        MOV r1, r5
        LDR r0, =promptInv
        BL printf
        B startLoop

    validExp:
        LDR r0, =promptV
        MOV r1, r5
        BL printf
        MOV r0, r5
        
    #pop stack
    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    ADD sp, sp, #12
    MOV pc, lr

.data
    promptEx: .asciz "Please enter a public key exponent: \n"
    promptInv: .asciz "%d does not fit the criteria of a public key exponent, please try again: \n"
    promptV: .asciz "%d is a valid public key exponent, it has been stored.\n"
    formatEx: .asciz "%d"
    pubKeyExp: .word 0
    
# end cpubexp

# Function: cprivexp
# Contributor: Kevin Chandran
# Purpose: to generate a private key exponent given a public key exponent and totient 
# Inputs: r0 should store the public key exponent, r1 should store the totient
# outputs: private key exponent in r0
.text
cprivexp:
    SUB sp, sp, #20
    STR lr, [sp, #0]
    STR r4, [sp, #4]
    STR r5, [sp, #8]
    STR r6, [sp, #12]
    STR r7, [sp, #16]

    MOV r4, r0 //moving public key exp into r4
    MOV r5, r1 //move totient into r5
    MOV r6, #0

    startPrivExLoop:
        ADD r6, r6, #1
        MUL r7, r4, r6
        MOV r0, r7
        MOV r1, r5
        BL modulo

        CMP r0, #1
        BNE startPrivExLoop
  
    #found valid private key exponent
    MOV r0, r6

    LDR lr, [sp, #0]
    LDR r4, [sp, #4]
    LDR r5, [sp, #8]
    LDR r6, [sp, #12]
    LDR r7, [sp, #16]
    ADD sp, sp, #20
    MOV pc, lr
  
.data

# end cprivexp

# Function: encrypt
# Contributor: Andrea Henry
# Purpose: Encrypts an input string
# Inputs: r0 - String to encrypt
#		  r1 - Public key (e)
#		  r2 - pq (n)
# Output: No return value. Outputs a file called "encrypted.txt"

.text
encrypt:
	# Push the stack
    SUB sp, sp, #32
    STR lr, [sp]
    STR r4, [sp, #4]
	STR r5, [sp, #8]
	STR r6, [sp, #12]
	STR r7, [sp, #16]
	STR r8, [sp, #20]
	STR r9, [sp, #24]
	STR r10, [sp, #28]

	# Code to loop through string from textbook p. 201-202
	
	# Save input string and modulus to register
	MOV r4, r0  // input string
	MOV r6, r1  // e
	MOV r7, r2	// n
	
	# Iterate over array and encrypt each character	
	# r4 - Array base
	# r5 - Loop index
	MOV r10, #0
	MOV r5, #0
	EncryptLoopStart:
		# Load one character from array
		LDRB r1, [r4, r5]
	
		# If 0, reached end of string
		CMP r1, #0
		BEQ EncryptLoopEnd
			# Calculate m^e
			MOV r0, r1  // m (plaintext character)
			MOV r1, r6  // e (public key)
			BL pow  // result in r0
			
			# Calculate m^e mod n
			MOV r1, r7  // n (modulus)
			BL modulo
			
			MOV r1, r10			
			BL writeIntToBuffer	
    		MOV r10, r0

			# Increment counter
			ADD r5, r5, #1

			B EncryptLoopStart

	EncryptLoopEnd:
		# Write buffer to file
		LDR r0, =encryptFileName
		LDR r1, =encryptOutBuffer
		LDR r2, =encryptBufferSize
		LDR r2, [r2]
		BL writeBufferToFile
		
	    # Pop stack and exit
        LDR lr, [sp, #0]
        LDR r4, [sp, #4]
		LDR r5, [sp, #8]
		LDR r6, [sp, #12]
		LDR r7, [sp, #16]
		LDR r8, [sp, #20]
		LDR r9, [sp, #24]
		LDR r10, [sp, #28]
        ADD sp, sp, #32
        MOV pc, lr


.data
	encryptPrompt: .asciz "\nEnter a short phrase: "
	encryptInputFormat: .asciz "%d"
	encryptInput: .space 40
	encryptFileName: .asciz "encrypted.txt"
	encryptOutBuffer: .space 255
	encryptBufferSize: .word 255
	testEncCalc: .asciz "The encrypted calculation is: %d\n"
	
# end encrypt

# Function: writeIntToBuffer
# Contributor: Andrea Henry
# Purpose: Converts a number to a string and writes it to the buffer 
# that is printed to the encrypted file
# Inputs: r0 - Numebr to write
#		  r1 - The position in the buffer to start writing the number
# Output: No output. Additions are saved in the buffer variable

.text
writeIntToBuffer:

	# Push to the stack
	SUB sp, sp, #20
	STR lr, [sp]
	STR r4, [sp, #4]
	STR r5, [sp, #8]
	STR r6, [sp, #12]
	STR r7, [sp, #16]
	STR r8, [sp, #20]
	
	MOV r4, r0  // The number to write (n)
	MOV r5, #0  // The index of the divArray to pull dividend from
	LDR r6, =arrSize  // Size of divArray
	LDR r6, [r6]
	MOV r7, r1  // The starting index to print n to
	LDR r8, =divArray  // The array with dividends

	DivLoopStart:

		# If current index is at end of divArray, stop
		CMP r5, r6
		BEQ DivLoopEnd

			# Divide n by a power of 10 to get each digit
			MOV r0, r4
			ADD r1, r8, r5, LSL #2  // Value at index r5 from divArray
			LDR r1, [r1]
			BL __aeabi_idiv

			# If the dividend was too big, go to next value
			CMP r0, #0
			BEQ NextVal

				# Get rid of first digit by getting remainder 
				MUL r3, r0, r1
				SUB r3, r4, r3
 
				# Convert digit to ASCII equivalent
				ADD r0, r0, #'0'

				# Save encrypted byte to buffer
			   	LDR r1, =encryptOutBuffer
        		STRB r0, [r1, r7] 
				MOV r4, r3
				ADD r7, r7, #1

			NextVal:
				ADD r5, r5, #1  // Increment index for divArray
				B DivLoopStart

	DivLoopEnd:
		# Add a space after each number
		MOV r0, #32
		LDR r1, =encryptOutBuffer
		STRB r0, [r1, r7]
		
		# Save the index to the buffer to print the next value
		# Add one so there is a space in between
		MOV r0, r7
		ADD r0, r0, #1

		# Pop the stack
		LDR lr, [sp]
		LDR r4, [sp, #4]
		LDR r5, [sp, #8]
		LDR r6, [sp, #12]
		LDR r7, [sp, #16]
		ADD sp, sp, #20
		MOV pc, lr

.data
divArray: .word 10000
		  .word 1000
		  .word 100
		  .word 10
		  .word 1 
arrSize: .word 5

.text
decrypt:
    # Contributor: Chris Reber
    # decrypts a .txt file
    # args: r0 - private key | r1 - modulus (p * q)
    # return: no return, outputs file 'plaintext.txt'
    # assumes input file name is 'encrypted.txt'

    # push the stack
    SUB sp, sp, #8
    STR lr, [sp]
    STR r4, [sp, #4]

    # move the keys into safe registers
    MOV r11, r0
    MOV r12, r1

    # open the file
    LDR r0, =fileName // file name in first arg
    MOV r1, #0  // no flags
    MOV r2, #0  // open read-only
    MOV r7, #5  // syscall number for 'open'
    SWI #0      // invoke syscall

    # error check
    CMP r0, #0
    BLE openFileError

    # move file descriptor to r6
    MOV r6, r0
    
    # no error -> read file contents to buffer
    MOV r3, #0  // use r3 as loop counter
    readFileLoopStart:
        MOV r0, r6
        LDR r1, =readBuffer
        MOV r2, #1      // read one byte (character) at a time
        MOV r7, #3      // read file syscall
        SWI #0

        # error check
        CMP r0, #0
        BLT readFileError
        BEQ endOfFile

        # process the read character
        # reference:
        # Using our private key values (n, d) for the equation m = 𝒄^𝒅 mod n we have the following:
            # • m is the decrypted individual plaintext character of our message
            # • c is our cipher text (encrypted text) value
            # • d is our private key exponent from step 2
            # • n is the calculated modulus from step 2 for our public and private keys
        LDRB r5, [r1]       // load the encrypted byte from the read buffer

		# NOTE FOR CHRIS: Andrea added this line
		SUB r5, r5, #'0'

        # do c^d first
        MOV r0, r5          // move encrypted byte to r0 (exponent base)
        MOV r1, r11         // move private key to r1 (exponent power)
        BL pow              // do exponentiation, result on r0

        MOV r1, r12         // move n (that is, p * q) to r1
        BL modulo           // perform modulus
        MOV r5, r0          // move resulting character to r5

        LDR r4, =outBuffer
        STRB r5, [r4, r3]   // save the decrypted byte to the output buffer
        ADD r3, #1          // increment loop counter
        B readFileLoopStart // restart loop
    # end read file loop

    readFileError:
        LDR r0, =readFileErrMsg
        BL printf
        B closeInputFile

    openFileError:
        LDR r0, =openFileErrMsg
        BL printf

    endOfFile:
        LDR r0, =outputFile
        LDR r1, =outBuffer
        LDR r2, =bufferSize
        LDR r2, [r2]
        BL writeBufferToFile

    closeInputFile:
        MOV r0, r6  // file handle to r0
        MOV r7, #6  // file close syscall
        SWI #0      // invoke syscall
        B decryptReturn

    decryptReturn:
        # pop the stack and return
        LDR lr, [sp, #0]
        LDR r4, [sp, #4]
        ADD sp, sp, #8
        MOV pc, lr 

.data
    fileName:       .asciz  "encrypted.txt"
    outputFile:     .asciz  "plaintext.txt"
    openFileErrMsg: .asciz  "Error opening file 'encrypted.txt'\n"
    readFileErrMsg: .asciz  "Error reading file contents\n"
    writeFileErrMsg:.asciz  "Error writing plaintext file\n"
    readBuffer:     .space  255
    outBuffer:      .space  255
    bufferSize:     .word   255

# end decrypt function

.text
writeBufferToFile:
    # Contributor: Chris Reber
    # Writes contents of a .space buffer to a .txt output file
    # args: r0 - output file name|r1 - .space buffer reference containing content to write|r2 - buffer size (word)
    # return: no return, outputs file with name provided on r0

    # push the stack
    SUB sp, sp, #4
    STR lr, [sp]

    # save output buffer reference to r4 for later
    MOV r4, r1

    # save buffer size for later
    MOV r5, r2

    # open file for writing
    MOV r1, #0x42
    LDR r2, =#0777              // file is globally read/write-able
    MOV r7, #5                  // syscall for file write
    SWI #0                      // invoke syscall

    # error check
    CMP r0, #0
    BLE writeFileError

    # write the file
    MOV r1, r4                 // move the output buffer back
    MOV r2, r5                 // move buffer size back
    writeLoopStart:
        CMP r2, #0
        BEQ closeOutFile
        MOV r7, #4              // syscall write
        SWI #0                  // invoke syscall
        SUB r2, r2, #1
        B writeLoopStart        // restart loop to write the next byte
    # write loop end
    B closeOutFile

    writeFileError:
        LDR r0, =writeFileErrMsg
        BL printf
        B writeFileReturn

    closeOutFile:
        MOV r0, r4              // move file handle to r0
        MOV r7, #6              // syscall close
        SWI #0                  // invoke syscall
        B writeFileReturn

    writeFileReturn:
        # pop the stack and return
        LDR lr, [sp, #0]
        ADD sp, sp, #4
        MOV pc, lr 

# end function writeBufferToFile

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
