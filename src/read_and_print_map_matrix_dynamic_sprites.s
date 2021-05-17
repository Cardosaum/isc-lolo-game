#====================================================================================================
READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES:
    # this function parses the map represented by an array in 'a0' and print all needed dynamic sprites

    # a0: map_matrix_array // something similar to MAP_1_MATRIX
    # a1: size of map_matrix_array // something similar to 300 (for MAP_1_MATRIX for instance)

    # save return address for later use
    store_word(t0,ra,RETURN_ADDRESS_READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES)

    # store parameters passed to function
    store_word(t0,a0,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_A0)
    store_word(t0,a1,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_A1)

    # counter
    li s0,-1
    store_word(t0,s0,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_COUNTER)

READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_LOOP:
    # handle counters
    load_word(s0,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_COUNTER)
    load_word(a0,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_A0)
    load_word(a1,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_A1)
    bge s0,a1,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_EXIT
    lb t0,(a0) # read which byte is stored in this matrix
    addi a0,a0,1 # now we will go to next position in a0 in next read
    addi s0,s0,1 # increment counter
    store_word(t1,s0,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_COUNTER)
    store_word(t1,a0,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_A0)

    # conditional treatment
    beqz t0,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_LOOP # if it's 0, do nothing
    li t1,1
    beq t0,t1,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_LOOP # ground. do nothing here too
    li t1,2
    beq t0,t1,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_PRINT_HEART
    li t1,3
    beq t0,t1,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_PRINT_CHEST_CLOSED

    j READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_LOOP

READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_PRINT_HEART:
    li a3,1
    la a5,heart
    j READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_PRINT_DESIRED_SPRITE_AND_LOOP

READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_PRINT_CHEST_CLOSED:
    li a3,0
    la a5,chest_closed
    j READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_PRINT_DESIRED_SPRITE_AND_LOOP

READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_PRINT_DESIRED_SPRITE_AND_LOOP:
    # get absolute X and Y values
    li t0,WIDTH_MATRIX
    rem a0,s0,t0
    div a1,s0,t0
    li t1,16
    mul a0,a0,t1
    mul a1,a1,t1

    # add dynamic_sprite to array of struct and print it to map
    # a0: dynamic_sprite_x
    # a1: dynamic_sprite_y
    # a3: dynamic_sprite_collide
    # a5: address_to_dynamic_sprite.data
    jal INITIALIZE_DYNAMIC_SPRITE

    j READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_LOOP

READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_EXIT:
    # get return address
    la t0,RETURN_ADDRESS_READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES
    lw ra,(t0)
    ret
#====================================================================================================
