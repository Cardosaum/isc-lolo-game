KEYBOARD_INPUT:
.eqv MMIO_set 0xff200000
.eqv MMIO_add 0xff200004
.eqv EXIT_KEY 113 # ascii value for 'q' (ie. if you press 'q' the program exits)
# ascii code for the controller keys 'wasd'
.eqv KEY_W 119
.eqv KEY_A 97
.eqv KEY_S 115
.eqv KEY_D 100

    # save return address for later
    la t0,RETURN_ADDRESS_KEYBOARD_INPUT
    sw ra,(t0)

KEYBOARD_INPUT_LOOP_POOL:
    li t0,MMIO_set # t0 = keyboard_flag
    lb t1,(t0)
    beqz t1,KEYBOARD_INPUT_LOOP_POOL
    li t2,EXIT_KEY # t2 = ascii('q')
    li s4,KEY_W
    li s5,KEY_A
    li s6,KEY_S
    li s7,KEY_D
    li a0,MMIO_add
    lw a0,(a0)
    beq a0,t2,KEYBOARD_INPUT_EXIT
    beq a0,s4,KEYBOARD_INPUT_KEY_W
    beq a0,s5,KEYBOARD_INPUT_KEY_A
    beq a0,s6,KEYBOARD_INPUT_KEY_S
    beq a0,s7,KEYBOARD_INPUT_KEY_D
    j KEYBOARD_INPUT_LOOP_POOL

KEYBOARD_INPUT_EXIT:
    la t0,RETURN_ADDRESS_KEYBOARD_INPUT
    lw ra,(t0)
    ret
KEYBOARD_INPUT_KEY_W:
    keyboard_input_key_v2(0,-4,0,lolo_u,90)
KEYBOARD_INPUT_KEY_A:
    keyboard_input_key_v2(-4,0,1,lolo_l,90)
KEYBOARD_INPUT_KEY_S:
    keyboard_input_key_v2(0,4,2,lolo_n,90)
KEYBOARD_INPUT_KEY_D:
    keyboard_input_key_v2(4,0,3,lolo_r,90)
