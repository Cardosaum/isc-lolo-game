#====================================================================================================
INITIALIZE_LOLO:
    # add lolo to array of struct and print it to map
    # a0: lolo_x
    # a1: lolo_y

    la t0,RETURN_ADDRESS_INITIALIZE_LOLO
    sw ra,(t0)

    # save variables to later use
    la t0,LOLO_POSITION_CURRENT_X
    sh a0,(t0)
    la t0,LOLO_POSITION_LAST_X
    sh a0,(t0)
    la t0,LOLO_POSITION_CURRENT_Y
    sh a1,(t0)
    la t0,LOLO_POSITION_LAST_Y
    sh a1,(t0)

    # we will use the function ADD_STRUCT_TO_VECTOR
    # to add lolo into the array of structs, but
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

    la a5,lolo_n
    addi a5,a5,8 # skip the first 2 words of lolo_n. we only need the address of the first lolo_n's pixel

    add_struct_to_vector(DYN_VECT_STRUCT,0,a0,a0,a5)

    la t0,LOLO_POSITION_CURRENT_X
    lhu a0,(t0)
    la t0,LOLO_POSITION_CURRENT_Y
    lhu a1,(t0)
    la a2,lolo_n
    li a5,0
    print_sprite(a0,a1,a2,DYN_BLOCK,a5)


    la t0,RETURN_ADDRESS_INITIALIZE_LOLO
    lw ra,(t0)
    ret
#====================================================================================================

#====================================================================================================
MOVE_LOLO:
    # this function takes next address_to_.data, x_relative and y_relative and perform all the steps to move lolo to (X,Y)

    # parameters
    # a0: address_to_.data
    # a1: x_relative
    # a2: y_relative

    # save return address for later use
    la t0,RETURN_ADDRESS_MOVE_LOLO
    sw ra,(t0)

    # save address_to_.data
    la t0,MOVE_LOLO_ADDRESS_TO_DATA
    sw a0,(t0)

    li a0,0 # lolo is always index 0
    jal CONVERT_RELATIVE_TO_ABSOLUTE_MOVE

    mv a0,a1
    mv a1,a2
    li a2,0
    la t0,MOVE_LOLO_ADDRESS_TO_DATA
    lw a3,(t0)
    jal MOVE_DYNAMIC_SPRITE

    la t0,RETURN_ADDRESS_MOVE_LOLO
    lw ra,(t0)
    ret
#====================================================================================================

#====================================================================================================
CONVERT_RELATIVE_TO_ABSOLUTE_MOVE:
    # this function takes array_struct_index, x_relative and y_relative and convert it to
    # absolute values of X and Y

    # parameters
    # a0: array_struct_index
    # a1: x_relative
    # a2: y_relative

    # outputs
    # a1: x_absolute
    # a2: y_absolute

    # save return address for later use
    la t0,RETURN_ADDRESS_CONVERT_RELATIVE_TO_ABSOLUTE_MOVE
    sw ra,(t0)

    # go to I'th position in array
    jal HOW_MANY_BYTES_SKIP_TO_REACH_ITH
    la t0,DYN_VECT_STRUCT
    lw t0,(t0)
    add t0,t0,a0

    # get current X and Y values
    lw t1,4(t0) # read (X,Y)
    li t2,0xFFFF0000
    and t3,t1,t2 # mask X
    srli t3,t1,16 # return X to a half word
    li t2,0x0000FFFF
    and t4,t1,t2 # mask Y

    # add relative values to X and Y
    add a1,a1,t3 # x_absolute
    add a2,a2,t4 # y_absolute

    # get return address
    la t0,RETURN_ADDRESS_CONVERT_RELATIVE_TO_ABSOLUTE_MOVE
    lw ra,(t0)
    ret
#====================================================================================================

#====================================================================================================
MOVE_DYNAMIC_SPRITE:
    # this function takes one sprite that already is present in array_struct and move it to a new
    # location, performing all the necessary steps to update array_struct and restore the hidden
    # pixels when it move out.

    # a0: x_new
    # a1: y_new
    # a2: array_struct_index
    # a3: address_to_.data

    # save arguments for later use
    la t0,MOVE_DYNAMIC_SPRITE_ARG_A0
    sw a0,(t0)
    la t0,MOVE_DYNAMIC_SPRITE_ARG_A1
    sw a1,(t0)
    la t0,MOVE_DYNAMIC_SPRITE_ARG_A2
    sw a2,(t0)
    la t0,MOVE_DYNAMIC_SPRITE_ARG_A3
    sw a3,(t0)

    # save return address for later use
    la t0,RETURN_ADDRESS_MOVE_DYNAMIC_SPRITE
    sw ra,(t0)

    # print hidden_sprite
    load_word(a0,MOVE_DYNAMIC_SPRITE_ARG_A2)
    jal DYNAMIC_SPRITE_PRINT_HIDDEN_SPRITE

    # update next_position
    load_word(a1,MOVE_DYNAMIC_SPRITE_ARG_A0)
    load_word(a2,MOVE_DYNAMIC_SPRITE_ARG_A1)
    load_word(a0,MOVE_DYNAMIC_SPRITE_ARG_A2)
    jal DYNAMIC_SPRITE_UPDATE_NEXT_POSITION

    # save next_dyn_sprite
    # there seems to be an error, we are not
    # saving dyn sprite correctly
    load_word(a0,MOVE_DYNAMIC_SPRITE_ARG_A2)
    jal DYNAMIC_SPRITE_SAVE_NEXT_DYN_SPRITE

    # print dynamic_sprite in new position
    load_word(a0,MOVE_DYNAMIC_SPRITE_ARG_A0)
    load_word(a1,MOVE_DYNAMIC_SPRITE_ARG_A1)
    load_word(a2,MOVE_DYNAMIC_SPRITE_ARG_A3)
    load_word(a5,MOVE_DYNAMIC_SPRITE_ARG_A2)
    print_sprite(a0,a1,a2,DYN_BLOCK,a5)

    # update current_position
    load_word(a1,MOVE_DYNAMIC_SPRITE_ARG_A0)
    load_word(a2,MOVE_DYNAMIC_SPRITE_ARG_A1)
    load_word(a0,MOVE_DYNAMIC_SPRITE_ARG_A2)
    jal DYNAMIC_SPRITE_UPDATE_CURRENT_POSITION

    # get return address
    la t0,RETURN_ADDRESS_MOVE_DYNAMIC_SPRITE
    lw ra,(t0)
    ret

#====================================================================================================

#====================================================================================================
DYNAMIC_SPRITE_UPDATE_CURRENT_POSITION:
    # a0: array_struct_index

    # save return address for later use
    la t0,RETURN_ADDRESS_DYNAMIC_SPRITE_UPDATE_CURRENT_POSITION
    sw ra,(t0)

    # go to I'th position in array
    jal HOW_MANY_BYTES_SKIP_TO_REACH_ITH
    la t0,DYN_VECT_STRUCT
    lw t0,(t0)
    add t0,t0,a0

    # get next_position and make it current_position
    lw t1,8(t0)
    # save current_position
    sw t1,4(t0)

    # get return address
    la t0,RETURN_ADDRESS_DYNAMIC_SPRITE_UPDATE_CURRENT_POSITION
    lw ra,(t0)
    ret
#====================================================================================================

#====================================================================================================
DYNAMIC_SPRITE_UPDATE_NEXT_POSITION:
    # a0: array_struct_index
    # a1: x
    # a2: y

    # save return address for later use
    la t0,RETURN_ADDRESS_DYNAMIC_SPRITE_UPDATE_NEXT_POSITION
    sw ra,(t0)

    # go to I'th position in array
    jal HOW_MANY_BYTES_SKIP_TO_REACH_ITH
    la t0,DYN_VECT_STRUCT
    lw t0,(t0)
    add t0,t0,a0

    # merge X and Y
    slli a1,a1,16
    li t1,0xFFFF0000
    and a1,a1,t1 # mask X
    li t1,0x0000FFFF
    and a2,a2,t1 # mask Y
    add a1,a1,a2

    # save next_position
    sw a1,8(t0)

    # get return address
    la t0,RETURN_ADDRESS_DYNAMIC_SPRITE_UPDATE_NEXT_POSITION
    lw ra,(t0)
    ret
#====================================================================================================

#====================================================================================================
DYNAMIC_SPRITE_SAVE_NEXT_DYN_SPRITE:
    # a0: array_struct_index

    # save return address for later use
    la t0,RETURN_ADDRESS_DYNAMIC_SPRITE_SAVE_NEXT_DYN_SPRITE
    sw ra,(t0)

    # go to I'th position in array
    jal HOW_MANY_BYTES_SKIP_TO_REACH_ITH
    la t0,DYN_VECT_STRUCT
    lw t0,(t0)
    add t0,t0,a0

    # save X and Y current coordinates for later
    li t2,0xFFFF0000
    lw s2,4(t0)
    and s2,s2,t2 # mask (X,Y) to get X value
    srli s2,s2,16 # return X to a half word
    li t2,0x0000FFFF
    lw s3,8(t0)
    and s3,s3,t2 # mask (X,Y) to get Y value

    # skip the first 4 struct fields in order to reach hidden_sprite
    addi t0,t0,312

    # print sprite
    load_word(s0,SELECTED_FRAME)
    load_half(s1,CANVAS_WIDTH)
    li t1,16 # (t0) image_width
    mul t2,t1,t1 # (t2) image_area
    srli t2,t2,2 # t2 /= 4
    li t5,0 # (t0) actual_column

    # go to (X,Y) position in canvas
    add s0,s0,s2
    mul t3,s3,s1
    add s0,s0,t3

DYNAMIC_SPRITE_SAVE_NEXT_DYN_SPRITE_LOOP:
    lw t3,(s0) # load pixel from canvas struct field
    sw t3,(t0) # print it to next_dyn_sprite
    addi t5,t5,4
    addi t0,t0,4
    addi t2,t2,-1
    blez t2,DYNAMIC_SPRITE_SAVE_NEXT_DYN_SPRITE_LOOP_EXIT
    bge t5,t1,DYNAMIC_SPRITE_SAVE_NEXT_DYN_SPRITE_LOOP_NEXT_LINE
    addi s0,s0,4
    j DYNAMIC_SPRITE_SAVE_NEXT_DYN_SPRITE_LOOP

DYNAMIC_SPRITE_SAVE_NEXT_DYN_SPRITE_LOOP_NEXT_LINE:
    addi s3,s3,1
    add s0,s0,s1
    mv t5,t1
    addi t5,t5,-4
    sub s0,s0,t5
    li t5,0
    j DYNAMIC_SPRITE_SAVE_NEXT_DYN_SPRITE_LOOP

DYNAMIC_SPRITE_SAVE_NEXT_DYN_SPRITE_LOOP_EXIT:
    # get return address
    la t0,RETURN_ADDRESS_DYNAMIC_SPRITE_SAVE_NEXT_DYN_SPRITE
    lw ra,(t0)
    ret

#====================================================================================================


#====================================================================================================
DYNAMIC_SPRITE_PRINT_HIDDEN_SPRITE:
    # a0: array_struct_index

    # save return address for later use
    la t0,RETURN_ADDRESS_DYNAMIC_SPRITE_PRINT_HIDDEN_SPRITE
    sw ra,(t0)

    # go to I'th position in array
    jal HOW_MANY_BYTES_SKIP_TO_REACH_ITH
    la t0,DYN_VECT_STRUCT
    lw t0,(t0)
    add t0,t0,a0

    # save X and Y current coordinates for later
    li t2,0xFFFF0000
    lw s2,8(t0)
    and s2,s2,t2 # mask (X,Y) to get X value
    srli s2,s2,16 # return X to a half word
    li t2,0x0000FFFF
    lw s3,8(t0)
    and s3,s3,t2 # mask (X,Y) to get Y value

    # skip the first 3 struct fields in order to reach hidden_sprite
    addi t0,t0,12

    # print sprite
    load_word(s0,SELECTED_FRAME)
    load_half(s1,CANVAS_WIDTH)
    li t1,16 # (t0) image_width
    mul t2,t1,t1 # (t2) image_area
    srli t2,t2,2 # t2 /= 4
    li t5,0 # (t0) actual_column

    # go to (X,Y) position in canvas
    add s0,s0,s2
    mul t3,s3,s1
    add s0,s0,t3

DYNAMIC_SPRITE_PRINT_HIDDEN_SPRITE_LOOP:
    lw t3,(t0) # load pixel from hidden_sprite struct field
    sw t3,(s0) # print it to canvas
    addi t5,t5,4
    addi t0,t0,4
    addi t2,t2,-1
    blez t2,DYNAMIC_SPRITE_PRINT_HIDDEN_SPRITE_LOOP_EXIT
    bge t5,t1,DYNAMIC_SPRITE_PRINT_HIDDEN_SPRITE_LOOP_NEXT_LINE
    addi s0,s0,4
    j DYNAMIC_SPRITE_PRINT_HIDDEN_SPRITE_LOOP

DYNAMIC_SPRITE_PRINT_HIDDEN_SPRITE_LOOP_NEXT_LINE:
    addi s3,s3,1
    add s0,s0,s1
    mv t5,t1
    addi t5,t5,-4
    sub s0,s0,t5
    li t5,0
    j DYNAMIC_SPRITE_PRINT_HIDDEN_SPRITE_LOOP

DYNAMIC_SPRITE_PRINT_HIDDEN_SPRITE_LOOP_EXIT:
    # get return address
    la t0,RETURN_ADDRESS_DYNAMIC_SPRITE_PRINT_HIDDEN_SPRITE
    lw ra,(t0)
    ret

#====================================================================================================









#MOVE_LOLO:
    ## a0: x_base_pixel
    ## a1: y_base_pixel
    #mv s10,ra
#
    #store_half(t0,a0,LOLO_POSITION_CURRENT_X)
    #store_half(t0,a1,LOLO_POSITION_CURRENT_Y)
    #load_half(a0,LOLO_POSITION_LAST_X)
    #load_half(a1,LOLO_POSITION_LAST_Y)
    #la a3,HIDDEN_SPRITE
    #li a4,STC_BLOCK
    #jal PRINT_SPRITE
    #load_half(a0,LOLO_POSITION_CURRENT_X)
    #load_half(a1,LOLO_POSITION_CURRENT_Y)
    #store_half(t0,a0,LOLO_POSITION_LAST_X)
    #store_half(t0,a1,LOLO_POSITION_LAST_Y)
    #la a3,lolo_n
    #li a4,DYN_BLOCK
    #jal PRINT_SPRITE
    #mv ra,s10
    #ret

GENERATE_MAP_MATRIX:
    # a0: map_matrix_address
    lh t0,0(a0) # t0 = map_width
    lh t1,2(a0) # t0 = map_height
    ret

RELATIVE_MOVE_DYN_BLOCK:
    # a0: x_current
    # a1: y_current
    # a2: x_next
    # a3: y_next
    # a4: sprite_address
    mv s10,ra

    store_half(t0,a2,DYN_BLOCK_SPRITE_NEXT_X)
    store_half(t0,a3,DYN_BLOCK_SPRITE_NEXT_Y)
    store_half(t0,a0,DYN_BLOCK_SPRITE_CURR_X)
    store_half(t0,a1,DYN_BLOCK_SPRITE_CURR_Y)
    store_half(t0,a4,DYN_BLOCK_SPRITE_ADDRESS)

    load_half(a0,DYN_BLOCK_SPRITE_CURR_X)
    load_half(a1,DYN_BLOCK_SPRITE_CURR_Y)
    la a3,DYN_BLOCK_SPRITE
    li a4,STC_BLOCK
    jal PRINT_SPRITE

    load_half(a0,DYN_BLOCK_SPRITE_NEXT_X)
    load_half(a1,DYN_BLOCK_SPRITE_NEXT_Y)
    save_current_pixels_to_var(a0,a1,16,16,DYN_BLOCK_SPRITE)

    load_half(a0,DYN_BLOCK_SPRITE_NEXT_X)
    load_half(a1,DYN_BLOCK_SPRITE_NEXT_Y)
    load_half(a3,DYN_BLOCK_SPRITE_ADDRESS)
    li a4,DYN_BLOCK
    jal PRINT_SPRITE
    mv ra,s10
    ret

#####
# store all the pixels in coordinates (x,y) with size (width,height)
# in the variable 'variable_address (a4)'
SAVE_CURRENT_PIXELS_TO_VAR:
    # a0: x
    # a1: y
    # a2: width
    # a3: height
    # a4: variable_address

    load_word(s0,SELECTED_FRAME)
    load_half(s1,CANVAS_WIDTH)

    mul t0,a2,a3 # (t0) total pixels to store
    srli t0,t0,2 # (t0) total words to store

    # now we get the first pixel that we need
    # to store
    # we are basically applying this rule:
    # first_pixel = base_pixel + y*width + x
    add s0,s0,a0
    mul t1,a1,a2
    add s0,s0,t1

    # we initialize the column_counter to 0
    li t1,0

    # now we save width and height to the variable_address
    # and set variable_address to the address of the first
    # actual pixel to store
    sw a2,(a4)
    sw a3,4(a4)
    addi a4,a4,8

SAVE_CURRENT_PIXELS_TO_VAR_LOOP:
    lw t2,(s0) # load pixel from RAM
    sw t2,(a4) # save pixel to variable_address
    addi t0,t0,-1 # image_area -= 1
    addi t1,t1,4 # actual_column += 4
    addi a4,a4,4 # variable_address += 4
    beqz t0,SAVE_CURRENT_PIXELS_TO_VAR_EXIT # if thereis no more pixel to save, exit.
    bge t1,a2,SAVE_CURRENT_PIXELS_TO_VAR_NEXT_LINE # if actual_column >= image_width: goto SAVE_CURRENT_PIXELS_TO_VAR_NEXT_LINE
    addi s0,s0,4 # pixel_address += 4
    j SAVE_CURRENT_PIXELS_TO_VAR_LOOP

SAVE_CURRENT_PIXELS_TO_VAR_NEXT_LINE:
    addi a1,a1,1 # y_base_pixel += 1
    add s0,s0,s1 # frame_address += canvas_width
    mv t1,a2 # actual_column = image_width
    addi t1,t1,-4 # t1 -= 4 (we ignore the last printed address)
    sub s0,s0,t1 # s0 -= t1
    li t1,0 # actual_column = 0
    j SAVE_CURRENT_PIXELS_TO_VAR_LOOP

SAVE_CURRENT_PIXELS_TO_VAR_EXIT:
    ret
