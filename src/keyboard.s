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
    la t0,RETURN_ADDRESS_KEYBOARD_INPUT
    lw ra,(t0)
    ret
KEYBOARD_INPUT_KEY_W:
    li t0,0 # we will reset all the other position movements
    la t1,LOLO_L
    sw t0,4(t1)
    la t1,LOLO_N
    sw t0,4(t1)
    la t1,LOLO_R
    sw t0,4(t1)

    la t1,LOLO_U
    lw t0,4(t1)
    li t2,4 # we have only 4 states for dynamic move
    rem a2,t0,t2
    la a0,LOLO_U
    la a1,lolo_u
    jal UPDATE_SPRITE_ANIMATION

    keyboard_input_key(0,-4,0,lolo_u,LOLO_U)
KEYBOARD_INPUT_KEY_A:
    #li t0,0 # we will reset all the other position movements
    #la t1,LOLO_U
    #sw t0,4(t1)
    #la t1,LOLO_N
    #sw t0,4(t1)
    #la t1,LOLO_R
    #sw t0,4(t1)
#
    #la t1,LOLO_L
    #lw t0,4(t1)
    #li t2,4 # we have only 4 states for dynamic move
    #rem a2,t0,t2
    #la a0,LOLO_L
    #la a1,lolo_l
    #jal UPDATE_SPRITE_ANIMATION

    keyboard_input_key(-4,0,1,lolo_l,LOLO_L)
KEYBOARD_INPUT_KEY_S:
    #li t0,0 # we will reset all the other position movements
    #la t1,LOLO_U
    #sw t0,4(t1)
    #la t1,LOLO_L
    #sw t0,4(t1)
    #la t1,LOLO_R
    #sw t0,4(t1)
#
    #la t1,LOLO_N
    #lw t0,4(t1)
    #li t2,4 # we have only 4 states for dynamic move
    #rem a2,t0,t2
    #la a0,LOLO_N
    #la a1,lolo_n
    #jal UPDATE_SPRITE_ANIMATION

    keyboard_input_key(0,4,2,lolo_n,LOLO_N)
KEYBOARD_INPUT_KEY_D:
    #li t0,0 # we will reset all the other position movements
    #la t1,LOLO_U
    #sw t0,4(t1)
    #la t1,LOLO_L
    #sw t0,4(t1)
    #la t1,LOLO_N
    #sw t0,4(t1)
#
    #la t1,LOLO_R
    #lw t0,4(t1)
    #li t2,4 # we have only 4 states for dynamic move
    #rem a2,t0,t2
    #la a0,LOLO_R
    #la a1,lolo_r
    #jal UPDATE_SPRITE_ANIMATION

    keyboard_input_key(4,0,3,lolo_r,LOLO_R)
