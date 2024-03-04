.text
.global main

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
