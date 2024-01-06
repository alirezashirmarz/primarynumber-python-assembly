.data
prompt:     .asciiz     "\nEnter an upper bound > "
primes1:     .asciiz    "\nPrime numbers between 2 and "
primes2:    .asciiz     " are: "
nl:         .asciiz     "\n"
comma:      .asciiz     ", "


.text
# Register Legend
# $a0 - Syscall info
# $v0 - Opcodes
# $s0 - User input
# $s1 - Array of booleans
# $s2 - Boolean array initializer counter
main:
    li      $v0     4                   # Load print string opcode
    la      $a0     prompt              # Load prompt
    syscall                             # Print prompt

    li      $v0     5                   # Load read int opcode
    syscall                             # Read int input
    move    $s0     $v0                 # Store user input in $s0

    mul     $a0     $s0     4           # Get the number of bytes to allocate
    li      $v0     9                   # Load the heap-allocate opcode
    syscall                             # Allocate space on the heap
    move    $s1     $v0                 # Move the array of booleans


    # Initialize the boolean array to False
    li      $s2     0                   # Initialize counter

    bool_loop:
    sb      $zero,    0($s1)            # Set it to False
    beq     $s0     $s2     endbool     # If the max number has been reached
    addi    $s1     $s1     1           # Increase array pointer
    addi    $s2     $s2     1           # Increase counter
    j       bool_loop                   # Repeat the initialization loop

    endbool:


    # Sieve prime numbers
    # Register Legend
    # $a0 - Syscall info
    # $v0 - Opcodes
    # $s0 - User input
    # $s1 - Array of booleans
    # $s2 - Outer loop counter
    # $s3 - Current counter index squared
    # $s4 - Value at current outer loop index of the boolean array
    # $s5 - Inner loop counter
    # $s6 - Value at current inner loop index of boolean array
    li      $s2     1                   # Initialize counter

    outer_loop:
    addi    $s2     $s2     1           # Increase the counter
    mult    $s2     $s2                 # Square the counter
    mflo    $s3                         # Store the squared counter
    bgt     $s3     $s0     exit        # If the counter is greater than the user input

    # `if prime[counter] == 0`
    lb      $s4     0($s1)              # Load the current index of the boolean array
    bnez    $s4     outer_loop          # If the value is not 0 (untouched), do nothing
    mul     $s5     $s2     $s2         # Initialize inner counter to outer counter squared

    inner_loop:
    bgt     $s5     $s0     outer_loop  # If the inner counter passes the user input, done looping
    add     $s6     $s5     $s1         # Calculate the current index of the bool array
    sb      $s2     0($s6)              # Set current index to anything not False
    add     $s5     $s5     $s2         # inner counter += outer counter     
    j       inner_loop                  # Redo inner loop


    j       outer_loop                  # Repeat the loop
    exit:

    li      $v0     4                   # Load the print string opcode
    la      $a0     primes1             # Load the prime display
    syscall                             # Print the display

    li      $v0     1                   # Load the print int opcode
    move    $a0     $s0                 # Load the user input
    syscall                             # Print the display

    li      $v0     4                   # Load the print string opcode
    la      $a0     primes2             # Load the prime display
    syscall                             # Print the display

    # Print all primes
    # Register Legend
    # $a0 - Syscall info
    # $v0 - Opcodes
    # $s0 - User input
    # $s1 - Array of booleans
    # $s2 - Loop counter
    # $s3 - Boolean array offset
    # $s4 - Value at current index of the boolean array
    li      $s2     1                   # Initialize counter
    print:
    addi    $s2     $s2     1           # Increment boolean array
    bgt     $s2     $s0     done        # If counter is greater than user input, exit
    add     $s3     $s1     $s2         # Calculate boolean array offset
    lb      $s4     0($s3)              # Load current value in boolean array


    bnez    $s4     print               # If current byte is not zero, reloop
                                        # Else print the prime
    li      $v0     1                   # Load the print int opcode
    move    $a0     $s2                 # Load the current prime number
    syscall                             # Print the prime

    li      $v0     4                   # Load the print string opcode
    la      $a0     comma               # Load the comma and space
    syscall                             # Print `, `

    j print                             # Repeat the print loop

    done:                               # Done looping

    li      $v0     4                   # Load the print string opcode
    la      $a0     nl                  # Load the newline
    syscall                             # Print `\n`

    li      $v0     10                  # Load exit opcode
    syscall                             # Exit program