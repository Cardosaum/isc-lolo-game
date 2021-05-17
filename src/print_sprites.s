#====================================================================================================
PRINT_SPRITE:
    # used registers:
    # a0, a1, a3, a4, t0, t1, t2, t3, t4, t5, t6, s0, s1, s7, s8, s9

    # a0: x_base_pixel
    # a1: y_base_pixel
    # a3: sprite address
    # a4: is_dynamic
    # a5: array_struct index // if block is dynamic, we need to know it's index to update the array

    # save return address for later
    store_word(t0,ra,RETURN_ADDRESS_PRINT_SPRITE)

    # first of all, we need to get the
    # canvas width and the frame that
    # need to be used to print the pixels
    load_word(s0,SELECTED_FRAME)
    load_half(s1,CANVAS_WIDTH)

    # now we initialize some variables
    lw t1,0(a3) # t1 = image_width
    lw t2,4(a3) # t2 = image_height
    mul t3,t1,t2 # t3 = t1*t2 (image area)
    #srli t3,t3,2 # t3 /= 4
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
    lb t6,(t5) # load pixel from RAM
    sb t6,(t0) # print pixel to frame
    #addi t4,t4,4 # actual_column += 4
    addi t4,t4,1 # actual_column += 1
    addi t3,t3,-1 # image_area -= 1
    #addi t5,t5,4 # pixel_address += 4
    addi t5,t5,1 # pixel_address += 1
    beqz t3,PRINT_SPRITE_LOOP_EXIT # if thereis no more pixel to print, exit.
    bge t4,t1,PRINT_SPRITE_NEXT_LINE # if actual_column >= image_width: goto PRINT_SPRITE_NEXT_LINE
    #addi t0,t0,4 # frame_address += 4
    addi t0,t0,1 # frame_address += 1
    j PRINT_SPRITE_LOOP

PRINT_SPRITE_NEXT_LINE:
    addi a1,a1,1 # y_base_pixel += 1
    add t0,t0,s1 # frame_address += canvas_width
    mv t4,t1 # t4 = t1
    #addi t4,t4,-4 # t4 -= 4 (we ignore the last printed address)
    addi t4,t4,-1 # t4 -= 1 (we ignore the last printed address)
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
    #addi s8,s8,4
    addi s8,s8,1
    lb s9,(t0)
    sb s9,(s8)
    j PROCEED_SPRITE_LOOP

PRINT_SPRITE_LOOP_EXIT:
    # get return address
    load_word(ra,RETURN_ADDRESS_PRINT_SPRITE)
    ret
#====================================================================================================

#====================================================================================================
PRINT_RAW_SPRITE:
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
    bnez a4,STORE_RAW_SPRITE_HIDDEN_BY_DYN_BLOCK_INIT

PRINT_RAW_SPRITE_LOOP:
    bnez a4,STORE_RAW_SPRITE_HIDDEN_BY_DYN_BLOCK_LOOP
PROCEED_RAW_SPRITE_LOOP:
    lw t6,(t5) # load pixel from RAM
    sw t6,(t0) # print pixel to frame
    addi t4,t4,4 # actual_column += 4
    addi t3,t3,-1 # image_area -= 1
    addi t5,t5,4 # pixel_address += 4
    beqz t3,PRINT_RAW_SPRITE_LOOP_EXIT # if thereis no more pixel to print, exit.
    bge t4,t1,PRINT_RAW_SPRITE_NEXT_LINE # if actual_column >= image_width: goto PRINT_RAW_SPRITE_NEXT_LINE
    addi t0,t0,4 # frame_address += 4
    j PRINT_RAW_SPRITE_LOOP

PRINT_RAW_SPRITE_NEXT_LINE:
    addi a1,a1,1 # y_base_pixel += 1
    add t0,t0,s1 # frame_address += canvas_width
    mv t4,t1 # t4 = t1
    addi t4,t4,-4 # t4 -= 4 (we ignore the last printed address)
    sub t0,t0,t4 # t0 -= t4
    li t4,0 # actual_column = 0
    j PRINT_RAW_SPRITE_LOOP

STORE_RAW_SPRITE_HIDDEN_BY_DYN_BLOCK_INIT:
    la s8,DYN_VECT_STRUCT #HIDDEN_SPRITE
    lw s8,(s8) # go to actual address where array is stored
    li s7,SPRITE_STRUCT_SIZE
    mul s7,s7,a5
    add s8,s8,s7 # go to I'th struct in array
    # note that in this line we add only 8 rather than the expected 12 because
    # right in the first iteration we already add 4
    addi s8,s8,8 # go to 'hidden_sprite' field in struct
    j PRINT_RAW_SPRITE_LOOP

STORE_RAW_SPRITE_HIDDEN_BY_DYN_BLOCK_LOOP:
    addi s8,s8,4
    lw s9,(t0)
    sw s9,(s8)
    j PROCEED_RAW_SPRITE_LOOP

PRINT_RAW_SPRITE_LOOP_EXIT:
    ret
#====================================================================================================
