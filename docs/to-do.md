# Forge Assembler

## To Do

### Tokenizer

- [ ] Read input from a file line-by-line.
- [ ] Divide it into tokens and chose one by one.
- [ ] Categorize the token.
- [ ] Null-terminate the last byte of the line (\n).
- [ ] Call the parser and send the token to it.
- [ ] Reset token_buffer when it comes back.

### Parser

- [ ] Receive categorized token.
- [ ] Validate the instruction format.
- [ ] Handle label definitions.
- [ ] Validate directives.
- [ ] Determine operand size.
- [ ] Prepare instruction structure for the encoder.

### Symbol Table

- [ ] Data structure each entry.
- [ ] Add labels during first pass.
- [ ] Lookup label references.
- [ ] Support forward-referenced labels.
- [ ] Handle errors.

### EnCoder

- [ ] Receive parsed instructions.
- [ ] Lookup code in instruction table.
- [ ] Emit prefixes.
- [ ] Encode ModR/M, SIB if needed.
- [ ] Insert immediate and/or displacement.
- [ ] Calculate instruction length.
- [ ] Store encoded bytes in output buffer.

### Output Generator

- [ ] Create raw binary output buffer.
- [ ] Write machine code from encoder.
- [ ] Insert data from directives.
- [ ] Handle .org correctly.
- [ ] Dump final output to .bin file.

### Error Handler

- [ ] Track line number.
- [ ] Store filename and current line in memory.
- [ ] Report errors.
- [ ] Exit on fatal errors.
- [ ] Add a warning system.

### Testing

- [ ] Write a basic test program.
- [ ] Compare output with other assemblers.
- [ ] 
- [ ] 
- [ ] 
