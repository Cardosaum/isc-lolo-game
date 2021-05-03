#=====================================================================================================
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
#=====================================================================================================


#=====================================================================================================
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
#=====================================================================================================

#=====================================================================================================
CREATE_STRUCT_VECTOR:
    # in this function we calculate how many bytes will be needed to store N
    # sprite structs in a vector

    # the structs will obey the following organization:
      # struct sprite_vectors {
      #         sprite_id = 4_bytes // used to identify if the sprite is lolo, a specific mob, a shoot, etc... (need to be 4 bytes in order to avoid alignment errors)
      #         current_position = 4_bytes // store (X,Y) coordinates for where the sprite is current in on map. Both X and Y are half (ie. 2 bytes)
      #         next_position = 4_bytes // store (X,Y) coordinates for where the sprite wants to go in map. Both X and Y are half (ie. 2 bytes)
      #         hidden_sprite = 300_bytes // store all the pixels that were hidden when the sprite moved to current position. we use it to restore the sprite when the sprite move to elsewhere
      #         next_dyn_sprite = 300_bytes // store all the pixels that we will print for this character/mob/(dyn_sprite)
      # }
    # taking into account this struct organization, we can see that one struct store a total of 312 bytes.

    # a0: how_many_structs
    # a1: dest_var to store pointer to allocated memory

    sw zero,4(a1) # initialize length to zero
    sw a0,8(a1) # initialize capacity to 'how_many_structs'

    mv s10,ra # we use this to remember where to go after execute the function. (ra register will be overriden when we call jal to execute other function inside this one)
    li t0,SPRITE_STRUCT_SIZE # how many bytes we need to a single struct
    mul a0,a0,t0 # now we compute how many bytes in total we need to use in order to store 'a0' structs inside an array.

    jal ALLOCATE_STRUCT_VECTOR # actually allocate memory for the vector
    mv ra,s10
    ret
#=====================================================================================================

#=====================================================================================================
UPDATE_STRUCT_VECTOR:
    # in this function we update a single struct inside the array of structs

    # a0: array_address // address of variable that store info about array of structs'. ie. some variable similar to DYN_VECT_STRUCT
    # a1: struct_position // goes from 0 to (how_many_structs - 1)
    # a2: sprite_id
    # a3: current_position
    # a4: next_position
    # a5: hidden_sprite // address of first new hidden_sprite pixel
    # a6: next_dyn_sprite // address of first new next_dyn_sprite pixel

    # we calcule how many bytes we need to skip in current array in order to reach struct_position
    li t0,SPRITE_STRUCT_SIZE
    mul a1,a1,t0
    lw a0,(a0)
    add a0,a0,a1

    # now we store the values in the desired struct
    sw a2,(a0) # store sprite_id
    sw a3,4(a0) # store current_position
    sw a4,8(a0) # store next_position

    # we need to loop 300/4 times to store the 300 bytes of the hidden_sprite (note that we perform 300/4 because we store one word at a time rather than byte a byte)
    li t0,0
    li t1,SPRITE_IMAGE_SIZE_STRUCT_SIZE
    addi a0,a0,12 # we skip 12 bytes (ie. 3 * 4, 3 words) to reach the first byte where hidden_sprite start

UPDATE_STRUCT_VECTOR_LOOP:
    lw t2,(a5) # save to 't2' 4 pixels of the sprite
    sw a5,(a0) # store 4 bytes of hidden_sprite at a time
    addi t0,t0,4
    bge t0,t1,UPDATE_STRUCT_VECTOR_EXIT
    addi a0,a0,4
    addi a5,a5,4
    j UPDATE_STRUCT_VECTOR_LOOP

UPDATE_STRUCT_VECTOR_EXIT:
    ret
#=====================================================================================================

#=====================================================================================================
ADD_STRUCT_TO_VECTOR:
    # in this function we add a single struct to vector's tail
    # this function is very similar to UPDATE_STRUCT_VECTOR

    # a0: array_address // address of variable that store info about array of structs'. ie. some variable similar to DYN_VECT_STRUCT
    # a1: sprite_id
    # a2: current_position
    # a3: next_position
    # a4: hidden_sprite // address of first new hidden_sprite pixel
    # a5: next_dyn_sprite // address of first new next_dyn_sprite pixel

    # t3: struct_position // we will use this variable to find the last position in array_address
    lw t3,4(a0) # read the current length of struct_vector
    addi t3,t3,1 # increment the length by one (so we can add new data into a fresh struct)
    sw t3,4(a0) # store incremented vector's length by one


    # we calculate how many bytes we need to skip in current array in order to reach struct_position
    li t0,SPRITE_STRUCT_SIZE
    addi t3,t3,-1
    mul t3,t3,t0
    lw a0,(a0)
    add a0,a0,t3

    # now we store the values in the desired struct
    sw a1,(a0) # store sprite_id
    sw a2,4(a0) # store current_position
    sw a3,8(a0) # store next_position

    # we need to loop 300/4 times to store the 300 bytes of the hidden_sprite (note that we perform 300/4 because we store one word at a time rather than byte a byte)
    li t0,0
    li t1,SPRITE_IMAGE_SIZE_STRUCT_SIZE
    addi a0,a0,12 # we skip 12 bytes (ie. 3 * 4, 3 words) to reach the first byte where hidden_sprite start

    # initialize some variables to use when querying canvas info
    load_word(s0,SELECTED_FRAME)
    load_half(s1,CANVAS_WIDTH)
    # go to pixel that correspond to (X,Y) coordinates
    add s0,s0
    # some more vars
    li t2,16 # t2 = sprite_width
    mul t4,t2,t2 # t4 = image_area
    srli t4,t4,2 # t4 /= 4
    li t5,0 # t5 = actual_column


ADD_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP:
    sw s0,()
    j ADD_STRUCT_TO_VECTOR_LOOP_HIDDEN_SPRITE

ADD_STRUCT_TO_VECTOR_NEXT_DYN_SPRITE_LOOP:
    sw a4,(a0) # store 4 bytes of hidden_sprite at a time
    addi t0,t0,4
    bge t0,t1,ADD_STRUCT_TO_VECTOR_EXIT
    addi a0,a0,4
    addi a4,a4,4
    j ADD_STRUCT_TO_VECTOR_LOOP

ADD_STRUCT_TO_VECTOR_EXIT:
    ret
#=====================================================================================================
