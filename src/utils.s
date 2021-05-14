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
      #         collide = 4_bytes // boolean; will this dynamic sprite collide with something else?
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
HOW_MANY_BYTES_SKIP_TO_REACH_ITH:
    # a0: array_struct_index

    # we calcule how many bytes we need to skip in current array in order to reach struct_position
    li t0,SPRITE_STRUCT_SIZE
    mul a0,a0,t0
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
    # // actually, it's not a needed parameter for the function; a4: hidden_sprite // address of first new hidden_sprite pixel
    # a5: next_dyn_sprite // address of first new next_dyn_sprite pixel
    # a6: collide // boolean to check if dynamic sprite will or not collide with something else

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
    li t2,0xFFFF0000
    and t2,t2,a3 # mask (X,Y) to get X value
    srli t2,t2,16 # return X to a half word
    add s0,s0,t2 # sum position 0 of canvas with X
    li t2,0x0000FFFF
    and t2,t2,a3 # mask (X,Y) to get Y value
    mul t2,t2,s1 # jump Y lines
    add s0,s0,t2 # go to position (X,Y)

    # some more vars
    li t2,16 # t2 = sprite_width
    mul t4,t2,t2 # t4 = image_area
    srli t4,t4,2 # t4 /= 4
    li t5,0 # t5 = actual_column


ADD_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP:
    lw t6,(s0) # get pixels
    sw t6,(a0) # save pixels in canvas to hidden_sprite
    addi t5,t5,4 # actual_column += 4
    addi a0,a0,4 # hidden_sprite_address += 4
    addi t4,t4,-1 # image_area -= 1
    beqz t4,ADD_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP_EXIT
    bge t5,t2,ADD_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP_NEXT_LINE
    addi s0,s0,4 # next 4 pixels from canvas
    j ADD_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP

ADD_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP_NEXT_LINE:
    add s0,s0,s1 # go to new line
    mv t5,t2
    addi t5,t5,-4 # (we ignore the last printed address)
    sub s0,s0,t5
    li t5,0
    j ADD_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP

ADD_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP_EXIT:

    # prepare to copy next_dyn_sprite
    # note that now a0 correspond to the first pixel in next_dyn_sprite
    li t5,SPRITE_IMAGE_SIZE_STRUCT_SIZE # we will need to iterate this much
ADD_STRUCT_TO_VECTOR_NEXT_DYN_SPRITE_LOOP:
    blez t5,ADD_STRUCT_TO_VECTOR_EXIT
    lw t0,(a5) # read 4 pixels from next_dyn_sprite
    sw t0,(a0) # store it in next_dyn_sprite struct field
    addi a5,a5,4
    addi a0,a0,4
    addi t5,t5,-4
    j ADD_STRUCT_TO_VECTOR_NEXT_DYN_SPRITE_LOOP

ADD_STRUCT_TO_VECTOR_EXIT:
    # save collide information and return
    sw a6,(a0)
    ret
#=====================================================================================================


#=====================================================================================================
UPDATE_STRUCT_TO_VECTOR:
    # in this function we add a single struct to vector's tail
    # this function is very similar to UPDATE_STRUCT_VECTOR

    # a0: array_address // address of variable that store info about array of structs'. ie. some variable similar to DYN_VECT_STRUCT
    # a1: sprite_id
    # a2: current_position
    # a3: next_position
    # // actually, it's not a needed parameter for the function; a4: hidden_sprite // address of first new hidden_sprite pixel
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
    li t2,0xFFFF0000
    and t2,t2,a3 # mask (X,Y) to get X value
    srli s2,s2,16 # return X to a half word
    add s0,s0,t2 # sum position 0 of canvas with X
    li t2,0x0000FFFF
    and t2,t2,a3 # mask (X,Y) to get Y value
    mul t2,t2,s1 # jump Y lines
    add s0,s0,t2 # go to position (X,Y)

    # some more vars
    li t2,16 # t2 = sprite_width
    mul t4,t2,t2 # t4 = image_area
    srli t4,t4,2 # t4 /= 4
    li t5,0 # t5 = actual_column


UPDATE_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP:
    lw t6,(s0) # get pixels
    sw t6,(a0) # save pixels in canvas to hidden_sprite
    addi t5,t5,4 # actual_column += 4
    addi a0,a0,4 # hidden_sprite_address += 4
    addi t4,t4,-1 # image_area -= 1
    beqz t4,UPDATE_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP_EXIT
    bge t5,t2,UPDATE_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP_NEXT_LINE
    addi s0,s0,4 # next 4 pixels from canvas
    j UPDATE_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP

UPDATE_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP_NEXT_LINE:
    add s0,s0,s1 # go to new line
    mv t5,t2
    addi t5,t5,-4 # (we ignore the last printed address)
    sub s0,s0,t4
    li t5,0
    j UPDATE_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP

UPDATE_STRUCT_TO_VECTOR_HIDDEN_SPRITE_LOOP_EXIT:

    # prepare to copy next_dyn_sprite
    # note that now a0 correspond to the first pixel in next_dyn_sprite
    li t5,SPRITE_IMAGE_SIZE_STRUCT_SIZE # we will need to iterate this much
UPDATE_STRUCT_TO_VECTOR_NEXT_DYN_SPRITE_LOOP:
    blez t5,UPDATE_STRUCT_TO_VECTOR_EXIT
    lw t0,(a5) # read 4 pixels from next_dyn_sprite
    sw t0,(a0) # store it in next_dyn_sprite struct field
    addi a5,a5,4
    addi a5,a0,4
    addi t5,t5,-4
    j UPDATE_STRUCT_TO_VECTOR_NEXT_DYN_SPRITE_LOOP

UPDATE_STRUCT_TO_VECTOR_EXIT:
    ret
#=====================================================================================================

#=====================================================================================================
UPDATE_SPRITE_ANIMATION:
    # update variable that store the next sprite animation to be printed

    # a0: direction_identifier // one of [0,1,2,3], indicating direction (ie. WASD)

    la s0,lolo_combined
    la s1,UPDATE_SPRITE_ANIMATION_NEXT_SPRITE_ADDRESS
    load_word(s2,UPDATE_SPRITE_ANIMATION_CURRENT_DIRECTION)

    bne a0,s2,UPDATE_SPRITE_ANIMATION_UPDATE_DIRECTION

UPDATE_SPRITE_ANIMATION_UPDATE_DIRECTION_PROCEED:
    load_word(s3,UPDATE_SPRITE_ANIMATION_CURRENT_FRAME)
    li t0,4 # we have 4 animation sprites for each direction
    addi s3,s3,1 # increment current frame
    rem s3,s3,t0 # make sure we always have a valid value
    la t0,UPDATE_SPRITE_ANIMATION_CURRENT_FRAME
    sw s3,(t0) # save it for later use

    # set first pixel of next sprite to print

    li t1,16 # width of each sprite
    mul t2,t1,s3
    add t3,s0,t2


UPDATE_SPRITE_ANIMATION_UPDATE_DIRECTION:
    # update direction variable to same as the variable passed
    la t0,UPDATE_SPRITE_ANIMATION_CURRENT_DIRECTION
    sw a0,(t0)
    # reset current_frame to 3
    la t0,UPDATE_SPRITE_ANIMATION_CURRENT_FRAME
    li t1,3
    sw t1,(t0)
    j UPDATE_SPRITE_ANIMATION_UPDATE_DIRECTION_PROCEED

    li t0,308 # size of an sprite 16x16 plus the the two words
    add a1,a1,t0 # go to first sprite movement // something similar to lolo_u_1. Note that this only works if the import sequence is correct. ie: include the files in this order: lolo_u,lolo_u_1,lolo_u_2...
    mul t0,t0,a2
    add a1,a1,t0
    sw a1,(a0)
    addi a2,a2,1 # update next index
    sw a2,4(a0)
    ret
#=====================================================================================================
