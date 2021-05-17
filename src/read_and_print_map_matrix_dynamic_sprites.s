#====================================================================================================
READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES:
    # this function parses the map represented by an array in 'a0' and print all needed dynamic sprites

    # a0: map_matrix_array // something similar to MAP_1_MATRIX
    # a1: size of map_matrix_array // something similar to 300 (for MAP_1_MATRIX for instance)

    # save return address for later use
    la t0,RETURN_ADDRESS_READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES
    sw ra,(t0)

    store_word(t0,a0,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_A0)
    store_word(t0,a1,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_A1)

READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_LOOP:
    blez a1,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_EXIT
    lb t0,(a0) # read which byte is stored in this matrix
    addi a0,a0,1 # now we will go to next position in a0 in next read
    beqz t0,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_LOOP # if it's 0, do nothing
    li t1,1
    beq t0,t1,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_LOOP # do nothing here too
    li t1,2
    beq t0,t1,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_LOOP # do nothing here too

READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_PRINT_DESIRED_SPRITE_AND_LOOP:
    li t0,WIDTH_MATRIX
    div t2,a0,t0
    div t2,a0,t0
    print_sprite()
    store_word(a0,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_A0)
    store_word(a1,READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_A1)
    j READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_LOOP

READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES_EXIT:
    # get return address
    la t0,RETURN_ADDRESS_READ_AND_PRINT_MAP_MATRIX_DYNAMIC_SPRITES
    lw ra,(t0)
    ret
#====================================================================================================
