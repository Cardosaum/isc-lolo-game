COPY_VECTOR:
    # a0: source vector
    # a1: dest vector
    # a2: size
    # copy src to dest. size must obey (size <= min(len(src), len(dest)))
COPY_VECTOR_EXIT_LOOP:
    blez a2,COPY_VECTOR_EXIT
    lb t0,(a0)
    sb t0,(a1)
    addi a0,a0,1
    addi a1,a1,1
    addi a2,a2,-1
    j COPY_VECTOR_EXIT_LOOP
COPY_VECTOR_EXIT:
    ret

ALLOCATE_STRUCT_VECTOR:
    # in this function we create an array to store structs in order to save information
    # needed to move dynamic sprites
    # for a better visual comprehension of what we are doing here, check this link
    # https://i.imgur.com/OaNWzRN.png

    # a0: vector size in bytes
    # a1: dest_var to store pointer to allocated memory

    # first of all, we allocate memory
    li a7,9
    ecall

    # now we store the pointer to allocated memory in variable passed by user
    sw a0,(a1)
    ret

CREATE_STRUCT_VECTOR:
    # in this function we calculate how many bytes will be needed to store N
    # sprite structs in a vector

    # the structs will obey the following organization:
      # struct sprite_vectors {
      #         sprite_id = 32_bytes // used to identify if the sprite is lolo, a specific mob, a shoot, etc... (need to be 32 bytes in order to avoid alignment errors)
      #         current_position = 32_bytes // store (X,Y) coordinates for where the sprite is current in on map. Both X and Y are half (ie. 16 bytes)
      #         next_position = 32_bytes // store (X,Y) coordinates for where the sprite wants to go in map. Both X and Y are half (ie. 16 bytes)
      #         sprite_image = 300_bytes // store all the pixels that were hidden when the sprite moved to current position. we use it to restore the sprite when the sprite move to elsewhere
      # }
    # taking into account this struct organization, we can see that one struct store a total of 396 bytes.

    # a0: how_many_structs
    # a1: dest_var to store pointer to allocated memory

    mv s10,ra # we use this to remember where to go after execute the function. (ra register will be overriden when we call jal to execute other function inside this one)
    li t0,SPRITE_STRUCT_SIZE # how many bytes we need to a single struct
    mul a0,a0,t0 # now we compute how many bytes in total we need to use in order to store 'a0' structs inside an array.

    jal ALLOCATE_STRUCT_VECTOR
    mv ra,s10
    ret

UPDATE_STRUCT_VECTOR:
    # in this function we update a single struct inside the array of structs

    # a0: array_address // array of structs' address
    # a1: struct_position // goes from 0 to (how_many_structs - 1)
    # a2: sprite_id
    # a3: current_position
    # a4: next_position
    # a5: sprite_image // address of first sprite_image pixel

    # we calcule how many bytes we need to skip in current array in order to reach struct_position
    li t0,SPRITE_STRUCT_SIZE
    mul a1,a1,t0
    add a0,a0,a1

    # now we store the values in the desired struct
    sw a2,(a0) # store sprite_id
    sw a3,32(a0) # store current_position
    sw a4,64(a0) # store next_position

    # we need to loop 300/4 times to store the 300 bytes of the sprite_image (note that we perform 300/4 because we store one word at a time rather than byte a byte)
    li t0,0
    li t1,SPRITE_IMAGE_SIZE_STRUCT_SIZE
    addi a0,a0,96 # we skip 96 bytes (ie. 3 * 32, 3 words) to reach the first byte where sprite_image start

UPDATE_STRUCT_VECTOR_LOOP:
    lw t2,(a5) # save to 't2' 4 pixels of the sprite
    sw a5,(a0) # store 4 bytes of sprite_image at a time
    addi t0,t0,4
    bge t0,t1,UPDATE_STRUCT_VECTOR_EXIT
    addi a0,a0,4
    addi a5,a5,4
    j UPDATE_STRUCT_VECTOR_LOOP

UPDATE_STRUCT_VECTOR_EXIT:
    ret
