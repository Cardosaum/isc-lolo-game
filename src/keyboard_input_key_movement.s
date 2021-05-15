#=====================================================================================================
    # general procedure to move any dynamic sprite to any direction
    # at least this is the initial intetion
KEYBOARD_INPUT_KEY_MOVEMENT:
    # a0: x_rel
    # a1: y_rel
    # a2: movement_code (W=0, A=1, S=2, D=3)
    # a3: sprite_address (something like lolo_n)
    # a4: sleep_time

    # save return address
    store_word(t0,ra,RETURN_ADDRESS_KEYBOARD_INPUT_KEY_MOVEMENT)

    # save parameters for later use
    store_word(t0,a0,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A0)
    store_word(t0,a1,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A1)
    store_word(t0,a2,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A2)
    store_word(t0,a3,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A3)
    store_word(t0,a4,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A4)

    # init counter to zero
    li t1,0
    store_word(t0,t1,KEYBOARD_INPUT_KEY_MOVEMENT_COUNTER)

    # reset its animation sprite
    load_word(a0,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A2)
    jal RESET_SPRITE_ANIMATION

KEYBOARD_INPUT_KEY_MOVEMENT_LOOP:
    # increment counter
    load_word(t0,KEYBOARD_INPUT_KEY_MOVEMENT_COUNTER)
    addi t0,t0,1
    store_word(t1,t0,KEYBOARD_INPUT_KEY_MOVEMENT_COUNTER)

    # check if we performed all needed loops
    li t1,4 # this is how many times we will loop
    bgt t0,t1,KEYBOARD_INPUT_KEY_MOVEMENT_EXIT

    # check if dynamic sprite can actualy move
    load_word(a1,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A0)
    load_word(a2,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A1)
    load_word(a3,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A2)
    jal CAN_LOLO_MOVE
    beqz a1,KEYBOARD_INPUT_KEY_MOVEMENT_EXIT

    # update sprite animation
    load_word(a0,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A2)
    jal UPDATE_SPRITE_ANIMATION

    # move dynamic sprite
    load_word(a0,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A3)
    load_word(a1,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A0)
    load_word(a2,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A1)
    li a4,1
    jal MOVE_LOLO

    # sleep
    load_word(a0,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A4)
    li a7,32
    ecall

    # restart loop
    j KEYBOARD_INPUT_KEY_MOVEMENT_LOOP

KEYBOARD_INPUT_KEY_MOVEMENT_EXIT:
    # print dynamic sprite static again
    load_word(a0,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A3)
    li a1,0
    li a2,0
    li a4,0
    jal MOVE_LOLO

    # reset its animation sprite again, just for sure
    load_word(a0,KEYBOARD_INPUT_KEY_MOVEMENT_ARG_A2)
    jal RESET_SPRITE_ANIMATION

    # return to caller
    load_word(ra,RETURN_ADDRESS_KEYBOARD_INPUT_KEY_MOVEMENT)
    ret
#=====================================================================================================
