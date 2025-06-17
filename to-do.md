# Forge Assembler

## To-Do
    
### Tokenizer

#### Needed

- [x] Support Comments.
- [ ] Document it better (add more and better comments).

#### Optional/Minor

- [x] Change %r11, %r12 from a "bool" to a ZF simulator

## To-Fix

### Tokenizer

- [x] The address of the start of the 2nd argument isn't stored correctly (instead the address of the delimiter before it is being stored). Solved 06/16/25
- [x] Empty lines are treated as normal lines instead of as delimiters. Solved 06/16/25
- [x] If \n is alone (without a non-null byte before it), then it will be treated as a null byte. Solved 06/16/25  
