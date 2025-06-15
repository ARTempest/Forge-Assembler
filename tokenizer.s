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

token_type_buffer:
  .space 4096       # enough space for up to 1024 token type integers

.section .text
.globl _start


_start:
  
open_file:
  movq $2, %rax
  movq $FILE_NAME, %rdi
  movq $0, %rsi
  syscall

  xor %r14, %r14    # Will hold the amount of characters read from the file
  xor %r15, %r15    # Will hold the file descriptor

  movq %rax, %r15   # save the file descriptor in %r15

read_loop:
  movq $0, %rax
  movq %r15, %rdi
  leaq input_buffer(%rip), %rsi
  addq %r14, %rsi
  movq $65536, %rdx

  syscall

  test %rax, %rax
  je done_reading
  js exit

  addq %rax, %r14
  jmp read_loop

end_reading:


token_loop:

end_token:

check_token_type:

print_tokens:

exit:

