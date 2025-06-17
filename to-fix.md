# To-Fix

## Tokenizer

- [x] The address of the beginning of the second argument isnt stored correctly (instead the address of the delimiter before it is being stored)  Solved 06/16/25
- [x] Empty lines are treated as normal lines instead of as delimiters  Solved 006/16/25
- [x] If \n is alone (without a non-null byte before it), then it will be treated as a null byte 
