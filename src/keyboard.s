#=====================================================================================================
    # perform all needed tasks for one key press event
    # return a0 = 1 if user wants to quit game, a0 = 0 otherwise
KEYBOARD_INPUT:
    # save return address for later
    store_word(t0,ra,RETURN_ADDRESS_KEYBOARD_INPUT)

KEYBOARD_INPUT_LOOP_POOL:
    # check if we has an input in keyboard
    li t0,MMIO_set # t0 = keyboard_flag
    lb t1,(t0)
    # set a0 to 0 to guarantee that if we have no input
    # we say to caller that user didn't ask to quit the program
    li a0,0
    beqz t1,KEYBOARD_INPUT_EXIT

    # actualy get which key was pressed
    li a0,MMIO_add
    lw a0,(a0)

    # perform conditional actions
    li t1,EXIT_KEY
    beq a0,t1,KEYBOARD_INPUT_KEY_EXIT
    li t1,KEY_W
    beq a0,t1,KEYBOARD_INPUT_KEY_W
    li t1,KEY_A
    beq a0,t1,KEYBOARD_INPUT_KEY_A
    li t1,KEY_S
    beq a0,t1,KEYBOARD_INPUT_KEY_S
    li t1,KEY_D
    beq a0,t1,KEYBOARD_INPUT_KEY_D

    # user didn't ask for quit the program
    li a0,0
    j KEYBOARD_INPUT_EXIT

KEYBOARD_INPUT_KEY_W:
    keyboard_input_key_v2(0,-4,0,lolo_u,90)
KEYBOARD_INPUT_KEY_A:
    keyboard_input_key_v2(-4,0,1,lolo_l,90)
KEYBOARD_INPUT_KEY_S:
    keyboard_input_key_v2(0,4,2,lolo_n,90)
KEYBOARD_INPUT_KEY_D:
    keyboard_input_key_v2(4,0,3,lolo_r,90)
KEYBOARD_INPUT_KEY_EXIT:
    # user wants to quit game loop
    li a0,1
    j KEYBOARD_INPUT_EXIT

KEYBOARD_INPUT_EXIT:
    load_word(ra,RETURN_ADDRESS_KEYBOARD_INPUT)
    ret
#=====================================================================================================
