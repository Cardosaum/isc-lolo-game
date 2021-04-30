 #.eqv STC_BLOCK 0
 #.eqv DYN_BLOCK 1

PRINT_SPRITE:
    # a0: x_base_pixel
    # a1: y_base_pixel
    # a3: sprite address
    # a4: is_dynamic

    # first of all, we need to get the
    # canvas width and the frame that
    # need to be used to print the pixels
    load_word(s0,SELECTED_FRAME)
    load_half(s1,CANVAS_WIDTH)

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

PRINT_SPRITE_LOOP:
    lw t6,(t5) # load pixel from HD
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

PRINT_SPRITE_LOOP_EXIT:
    ret

GENERATE_MAP_MATRIX:
    # a0: map_matrix_address
    lh t0,0(a0) # t0 = map_width
    lh t1,2(a0) # t0 = map_height
    ret
