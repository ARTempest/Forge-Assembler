.section .rodata

FILE_NAME:
  .asciz "test_file"

MAX_TOKENS:
  .long 1024        # declare max number of tokens

.section .bss

input_buffer:
  .space 65536      # enough space for 64kib of information

token_ptrs_buffer:
  .space 8192       # enough space for up to 1024 token addresses

.section .text
.globl _start

_start:
  
open_file:
  movq $2, %rax
  movq $FILE_NAME, %rdi
  movq $0, %rsi
  syscall

  xor %r14, %r14    # Will hold the amount of bytes read from the file
  xor %r15, %r15    # Will hold the file descriptor

  movq %rax, %r15   # save the file descriptor in %r15

read_loop:
  movq $0, %rax
  movq %r15, %rdi
  movq $input_buffer, %rsi
  addq %r14, %rsi
  movq $65536, %rdx
  subq %r14, %rdx

  syscall

  test %rax, %rax
  je end_reading
  js exit

  addq %rax, %r14
  jmp read_loop

end_reading:
  # Clean used registers
  xor %rax, %rax
  xor %r13, %r13              # will point to the end of the buffer
  xor %r8, %r8                # will be used to hold the amount of bytes of a token
  xor %r9, %r9                # will be used to count the amount of tokens
  xor %r11, %r11              # will simulate a ZF of if the next byte is part of a comment where 0 = false and 1 = true
  xor %r12, %r12              # will simulate a ZF of if it is an empty line where 0 = false and 1 = true
  movb $1, %r12b              # Set first line empty as default

  xor %r10, %r10              # will point to token_ptrs
  leaq token_ptrs_buffer(%rip), %r10

  movq $input_buffer, %rsi   # point to the beggining of the buffer
  leaq (%rsi, %r14), %r13    # point to the end of the buffer  
  
token_loop:
  cmpq %r13, %rsi           # Check if reached the end of bytes readen
  je close_file

  movb (%rsi), %al

  cmpb $0, %al
  je close_file
  
  jmp scan_byte

scan_byte:        # If char is a separation char just subtitute it for a delimiter \0
  
  cmpb $10, %al     # Check if the byte is a  \n (new line)
  je check_empty_line

  cmpb $1, %r11b
  je add_delimiter

  cmpb $32, %al     # Check if byte is ' ' (a space)
  je add_delimiter

  cmpb $9, %al      # Check if byte is a \t (tab)
  je add_delimiter

   cmpb $59, %al     # Check if the byte is a ';' (semi-colon)
  je comment_token

 
  jmp add_byte

add_byte: 
  incq %r8        # increase offset
  jmp next_byte

check_empty_line:
  cmpb $1, %r12b     # Check if is an empty line
  je empty_line

  jmp end_token

empty_line:
  movb $0, %r11b    # next line is not a comment
  jmp add_delimiter

next_byte:     
  incq %rsi         # Increase the index in one
  jmp token_loop

add_delimiter:
  movb $0, (%rsi)
  jmp end_line

end_line:
  cmpq $0, %r8      # If the token has at least one byte readen jmp end_token
  jne end_token

  jmp next_byte

end_token:
  movl MAX_TOKENS(%rip), %ecx
  cmpl %ecx, %r9d
  je exit_overflow

  # Move beginning of the token address to token_ptrs_buffer closest available spot
  xor %rax, %rax
  movq %rsi, %rax
  subq %r8, %rax
  movq %rax, (%r10)

  addq $8, %r10 # point to the next available spot in token_ptrs_buffer
  incl %r9d
  xor %r8, %r8 # reset amount of bytes of the token

  xor %rax, %rax
  movb (%rsi), %al
  
 # If the token's last byte is a \n the next one will be an empty line
  cmpb $'\n', %al
  je new_line_token

  movb $0, %r12b    # Confirm the line isnt empty
  jmp next_byte

new_line_token:
  movb $1, %r12b      # Set next line as empty
  movb $0, %r11b      # Set next line as not a comment
  jmp next_byte

comment_token:
  movb $1, %r11b   # set the rest of the line as a comment
  jmp token_loop

close_file:
  movq $3, %rax
  movq %r15, %rdi

  syscall

  xor %r13, %r13    # clear %r13
  jmp print_tokens

print_tokens:
  movq $1, %rax
  movq $1, %rdi
  
  leaq input_buffer(%rip), %rsi

  movq %r14, %rdx

  syscall
  jmp exit

exit_overflow:
  movq $60, %rax
  movq $1, %rdi

  syscall

exit:
  movq $60, %rax
  movq $0, %rdi

  syscall


