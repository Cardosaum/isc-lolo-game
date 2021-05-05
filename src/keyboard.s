KEYBOARD_INPUT:
.eqv MMIO_set 0xff200000
.eqv MMIO_add 0xff200004
.eqv EXIT_KEY 113 # ascii value for 'q' (ie. if you press 'q' the program exits)
# ascii code for the controller keys 'wasd'
.eqv KEY_W 119
.eqv KEY_A 97
.eqv KEY_S 115
.eqv KEY_D 100


KEYBOARD_INPUT_LOOP_POOL:
    li t0,MMIO_set # t0 = keyboard_flag
    li t2,EXIT_KEY # t2 = ascii('q')
    li s4,KEY_W
    li s5,KEY_A
    li s6,KEY_S
    li s7,KEY_D
    lb t1,(t0)
    beqz t1,KEYBOARD_INPUT_LOOP_POOL
    li a0,MMIO_add
    lw a0,(a0)
    beq a0,t2,KEYBOARD_INPUT_EXIT
    li a7, 1
    ecall
    li a7, 11
    ecall
    beq a0,s4,KEYBOARD_INPUT_KEY_W
    beq a0,s5,KEYBOARD_INPUT_KEY_A
    beq a0,s6,KEYBOARD_INPUT_KEY_S
    beq a0,s7,KEYBOARD_INPUT_KEY_D
    j KEYBOARD_INPUT_LOOP_POOL

KEYBOARD_INPUT_EXIT:
    ret
KEYBOARD_INPUT_KEY_W:
    la a0,lolo_u
    li a1,0
    li a2,-2
    jal MOVE_LOLO
    j KEYBOARD_INPUT_LOOP_POOL
KEYBOARD_INPUT_KEY_A:
    la a0,lolo_l
    li a1,-2
    li a2,0
    jal MOVE_LOLO
    j KEYBOARD_INPUT_LOOP_POOL
KEYBOARD_INPUT_KEY_S:
    la a0,lolo_n
    li a1,0
    li a2,2
    jal MOVE_LOLO
    j KEYBOARD_INPUT_LOOP_POOL
KEYBOARD_INPUT_KEY_D:
    la a0,lolo_r
    li a1,2
    li a2,0
    jal MOVE_LOLO
    j KEYBOARD_INPUT_LOOP_POOL
