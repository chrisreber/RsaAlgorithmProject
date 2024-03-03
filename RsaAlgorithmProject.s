.text
.global main

gcd:
  # Contributor: 
  # computes and returns the greatest common divisor of two integers

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

main:
  # push the stack
  SUB sp, sp, #4
  STR lr, [sp, #0]

  # main code starts here

  # pop the stack and return
  LDR lr, [sp, #0]
  ADD sp, sp, #4
  MOV pc, lr
.data
