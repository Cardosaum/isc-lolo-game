########################################################################################################################
#######################################                                         ########################################
#######################################          PRINT_SPRITE function          ########################################
#######################################                                         ########################################
########################################################################################################################
    # used registers:
    # a0, a1, a3, a4, t0, t1, t2, t3, t4, t5, t6, s0, s1, s7, s8, s9

PRINT_SPRITE:
    # a0: x_base_pixel
    # a1: y_base_pixel
    # a3: sprite address
    # a4: is_dynamic
    # a5: array_struct index // if block is dynamic, we need to know it's index to update the array

    # first of all, we need to get the
    # canvas width and the frame that
    # need to be used to print the pixels
    load_word(s0,SELECTED_FRAME)
    load_half(s1,CANVAS_WIDTH)

    # now we initialize some variables
    lw t1,0(a3) # t1 = image_width
    lw t2,4(a3) # t2 = image_height
    mul t3,t1,t2 # t3 = t1*t2 (image area)
    srli t3,t3,2 # t3 /= 4
    addi t5,a3,8 # t5 = first 4 pixels
    mv t0,s0 # frame address copy
    add t0,t0,a0 # frame_address + x_base_pixel
    mul t4,s1,a1 # t4 = canvas_width * y_base_pixel
    add t0,t0,t4 # frame_address += t4
    li t4,0 # (t4) actual_column = 0
    bnez a4,STORE_SPRITE_HIDDEN_BY_DYN_BLOCK_INIT

PRINT_SPRITE_LOOP:
    bnez a4,STORE_SPRITE_HIDDEN_BY_DYN_BLOCK_LOOP
PROCEED_SPRITE_LOOP:
    lw t6,(t5) # load pixel from RAM
    sw t6,(t0) # print pixel to frame
    addi t4,t4,4 # actual_column += 4
    addi t3,t3,-1 # image_area -= 1
    addi t5,t5,4 # pixel_address += 4
    beqz t3,PRINT_SPRITE_LOOP_EXIT # if thereis no more pixel to print, exit.
    bge t4,t1,PRINT_SPRITE_NEXT_LINE # if actual_column >= image_width: goto PRINT_SPRITE_NEXT_LINE
    addi t0,t0,4 # frame_address += 4
    j PRINT_SPRITE_LOOP

PRINT_SPRITE_NEXT_LINE:
    addi a1,a1,1 # y_base_pixel += 1
    add t0,t0,s1 # frame_address += canvas_width
    mv t4,t1 # t4 = t1
    addi t4,t4,-4 # t4 -= 4 (we ignore the last printed address)
    sub t0,t0,t4 # t0 -= t4
    li t4,0 # actual_column = 0
    j PRINT_SPRITE_LOOP

STORE_SPRITE_HIDDEN_BY_DYN_BLOCK_INIT:
    la s8,DYN_VECT_STRUCT #HIDDEN_SPRITE
    lw s8,(s8) # go to actual address where array is stored
    li s7,SPRITE_STRUCT_SIZE
    mul s7,s7,a5
    add s8,s8,s7 # go to I'th struct in array
    # note that in this line we add only 8 rather than the expected 12 because
    # right in the first iteration we already add 4
    addi s8,s8,8 # go to 'hidden_sprite' field in struct
    j PRINT_SPRITE_LOOP

STORE_SPRITE_HIDDEN_BY_DYN_BLOCK_LOOP:
    addi s8,s8,4
    lw s9,(t0)
    sw s9,(s8)
    j PROCEED_SPRITE_LOOP

PRINT_SPRITE_LOOP_EXIT:
    ret

########################################################################################################################
#######################################                                         ########################################
#######################################          PRINT_SPRITE function          ########################################
#######################################                                         ########################################
########################################################################################################################

#====================================================================================================
INITIALIZE_LOLO:
    # add lolo to array of struct and print it to map
    # a0: lolo_x
    # a1: lolo_y

    la t0,INITIALIZE_LOLO_RETURN_ADDRESS
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
    add a0,a0,a1 # merge X and Y

    la a5,lolo_n
    addi a5,a5,8 # skip the first 2 words of lolo_n. we only need the address of the first lolo_n's pixel

    add_struct_to_vector(DYN_VECT_STRUCT,0,a0,a0,a5)

    la t0,LOLO_POSITION_CURRENT_X
    lhu a0,(t0)
    la t0,LOLO_POSITION_CURRENT_Y
    lhu a1,(t0)
    li a5,0
    print_sprite(a0,a1,lolo_n,DYN_BLOCK,a5)
    #la a3,lolo_n
    #jal PRINT_SPRITE

    la t0,INITIALIZE_LOLO_RETURN_ADDRESS
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


#====================================================================================================





MOVE_LOLO:
    # a0: x_base_pixel
    # a1: y_base_pixel
    mv s10,ra

    store_half(t0,a0,LOLO_POSITION_CURRENT_X)
    store_half(t0,a1,LOLO_POSITION_CURRENT_Y)
    load_half(a0,LOLO_POSITION_LAST_X)
    load_half(a1,LOLO_POSITION_LAST_Y)
    la a3,HIDDEN_SPRITE
    li a4,STC_BLOCK
    jal PRINT_SPRITE
    load_half(a0,LOLO_POSITION_CURRENT_X)
    load_half(a1,LOLO_POSITION_CURRENT_Y)
    store_half(t0,a0,LOLO_POSITION_LAST_X)
    store_half(t0,a1,LOLO_POSITION_LAST_Y)
    la a3,lolo_n
    li a4,DYN_BLOCK
    jal PRINT_SPRITE
    mv ra,s10
    ret

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
