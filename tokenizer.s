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
  cmpb $' ', %al
  je add_delimiter

  cmpb $'\t', %al
  je add_delimiter

  jmp add_byte

add_byte: 
  incq %r8        # increase offset
 
  cmpb $'\n', %al
  je end_line

next_byte:      # Increase the index in one
  incq %rsi
  jmp token_loop

add_delimiter:
  movb $0, (%rsi)
  jmp end_line

end_line:
  cmpq $0, %r8
  jne end_token

  jmp next_byte


end_token:
  movl MAX_TOKENS(%rip), %ecx
  cmpl %ecx, %r9d
  je exit_overflow

  # Move beginning of the token address to token_ptrs_buffer closest available spot
  movq %rsi, %rax
  subq %r8, %rax
  movq %rax, (%r10)


  addq $8, %r10 # point to the next available spot in token_ptrs_buffer
  incl %r9d
  xor %r8, %r8 # reset amount of bytes of the token

  jmp next_byte

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


