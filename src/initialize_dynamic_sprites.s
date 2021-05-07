#====================================================================================================
INITIALIZE_DYNAMIC_SPRITE:
    # add dynamic_sprite to array of struct and print it to map
    # a0: dynamic_sprite_x
    # a1: dynamic_sprite_y
    # a2: dynamic_sprite_index_in_struct_array
    # a5: address_to_dynamic_sprite.data

    la t0,RETURN_ADDRESS_INITIALIZE_DYNAMIC_SPRITE
    sw ra,(t0)

    # save variables to later use
    la t0,INITIALIZE_DYNAMIC_SPRITE_POSITION_CURRENT_X
    sh a0,(t0)
    la t0,INITIALIZE_DYNAMIC_SPRITE_POSITION_CURRENT_Y
    sh a1,(t0)
    la t0,INITIALIZE_DYNAMIC_SPRITE_DYNAMIC_SPRITE_INDEX_IN_STRUCT_ARRAY
    sw a2,(t0)
    la t0,INITIALIZE_DYNAMIC_SPRITE_ADDRESS_TO_DYNAMIC_SPRITE_DATA
    sw a5,(t0)

    # we will use the function ADD_STRUCT_TO_VECTOR
    # to add dynamic_sprite into the array of structs, but
    # the coordinates X and Y must be in the same
    # 32bits memory addres, where X is in the first 2 bytes
    # and Y on the last 2. So we need to make those shifts and
    # masks.
    slli a0,a0,16 # send X to the first 2 bytes
    li t0,0xFFFF0000
    and a0,a0,t0 # mask X
    li t0,0x0000FFFF
    and a1,a1,t0 # mask Y
    add a0,a0,a1 # merge X and Y

    addi a5,a5,8 # skip the first 2 words of dynamic_sprite. we only need the address of the first dynamic_sprite's pixel

    add_struct_to_vector(DYN_VECT_STRUCT,0,a0,a0,a5)

    la t0,INITIALIZE_DYNAMIC_SPRITE_POSITION_CURRENT_X
    lhu a0,(t0)
    la t0,INITIALIZE_DYNAMIC_SPRITE_POSITION_CURRENT_Y
    lhu a1,(t0)
    load_word(a2,INITIALIZE_DYNAMIC_SPRITE_ADDRESS_TO_DYNAMIC_SPRITE_DATA)
    load_word(a5,INITIALIZE_DYNAMIC_SPRITE_DYNAMIC_SPRITE_INDEX_IN_STRUCT_ARRAY)
    print_sprite(a0,a1,a2,DYN_BLOCK,a5)

    la t0,RETURN_ADDRESS_INITIALIZE_DYNAMIC_SPRITE
    lw ra,(t0)
    ret
#====================================================================================================
