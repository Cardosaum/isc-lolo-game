KEYBOARD_INPUT:
.eqv MMIO_set 0xff200000
.eqv MMIO_add 0xff200004
.eqv EXIT_KEY 113 # ascii value for 'q' (ie. if you press 'q' the program exits)

    li t0,MMIO_set # t0 = keyboard_flag
    li t2,EXIT_KEY # t2 = ascii('q')
KEYBOARD_INPUT_LOOP_POOL:
    lb t1,(t0)
    beqz t1,KEYBOARD_INPUT_LOOP_POOL
    li a0,MMIO_add
    lw a0,(a0)
    beq a0,t2,KEYBOARD_INPUT_EXIT
    li a7, 1
    ecall
    li a7, 11
    ecall
    j KEYBOARD_INPUT_LOOP_POOL
KEYBOARD_INPUT_EXIT:
    ret
