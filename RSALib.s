.text
.global gcd
.global pow
.global modulo
.global cpubexp
.global cprivexp
.global encrypt
.global decrypt

gcd:
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

pow:
  # Contributor:
  # performs exponentiation of two integers

modulo:
  # Contributor:
  # function to perform modulo operation

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
