# Forge Assembler Syntax

## Labels

### Local Labels:

Begin with a dot `(.)` and end with a colon `(:)`.

**Example:**

    .local_label:

### Global Labels:

No prefix, end with a colon `(:)`.

**Example:**

    global_label:

## Registers

### Accessing a register:

Registers are used without any prefix.

**Example:**

    rax

## Memory Access

### Accessing memory via register:

Use an at sign `(@)` before the register name.

**Example:**

    @rax

### Accessing memory with offset:

Use an add sign `(+)` to add offset after the register.

**Example:**

    @rax+offset

### Accessing memory with offset and multiplier:

Use an asterisk `(*)` after the offset (the multiplier can only be: 1, 4, or 8)

**Example:**

    @rax+offset*multiplier

## Instructions

### Instruction syntax:

Operand order is source first and destination last.
Instructions do not require suffixes for operand sizes.
Operands are space-separated.

**Example:**

    mov rax rax

## Immediates

### Immediate values:

Immediates do not require a prefix (like `$`) or a suffix.

**Example:**

    mov 1 rax
