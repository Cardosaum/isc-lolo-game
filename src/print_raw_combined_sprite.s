#=====================================================================================================
PRINT_RAW_COMBINED_SPRITE:
    # print desired sprite to canvas and return
    # this procedure assume that the sprite is 16x16

    # a0: x
    # a1: y

    # first of all, we need to get the
    # canvas width and the frame that
    # need to be used to print the pixels
    load_word(s0,SELECTED_FRAME)
    load_half(s1,CANVAS_WIDTH)

    # now we initialize some variables
    load_word(s2,UPDATE_SPRITE_ANIMATION_CURRENT_DIRECTION)
    load_word(s3,UPDATE_SPRITE_ANIMATION_CURRENT_FRAME)
    li t1,16 # image_width

    # compute where in UPDATE_SPRITE_ANIMATION_NEXT_SPRITE_ADDRESS we need to go
    la t5,UPDATE_SPRITE_ANIMATION_NEXT_SPRITE_ADDRESS
    lw t5,(t5)
    li t2,64 # size of 4 sprites in width
    mul t2,t2,s2
    add t5,t5,t2
    mul t2,t1,s3
    add t5,t5,t2

    mul t2,t1,t1 # image area
    srli t2,t2,2 # t2 /= 4
    mv t0,s0 # frame address copy
    add t0,t0,a0 # frame_address + x_base_pixel
    mul t4,s1,a1 # t4 = canvas_width * y_base_pixel
    add t0,t0,t4 # frame_address += t4
    li t4,0 # (t4) actual_column = 0


PRINT_RAW_COMBINED_SPRITE_LOOP:
    lw t6,(t5) # load pixel from RAM
    sw t6,(t0) # print pixel to frame
    addi t4,t4,4 # actual_column += 4
    addi t2,t2,-1 # image_area -= 1
    beqz t2,PRINT_RAW_COMBINED_SPRITE_LOOP_EXIT # if thereis no more pixel to print, exit.
    bge t4,t1,PRINT_RAW_COMBINED_SPRITE_NEXT_LINE # if actual_column >= image_width: goto PRINT_RAW_COMBINED_SPRITE_NEXT_LINE
    addi t0,t0,4 # frame_address += 4
    addi t5,t5,4 # pixel_address += 4
    j PRINT_RAW_COMBINED_SPRITE_LOOP

PRINT_RAW_COMBINED_SPRITE_NEXT_LINE:
    add t0,t0,s1 # frame_address += canvas_width
    mv t4,t1 # t4 = t1
    addi t4,t4,-4 # t4 -= 4 (we ignore the last printed address)
    sub t0,t0,t4 # t0 -= t4

    li t6,256 # with of all animation sprites aligned
    add t5,t5,t6
    mv t4,t1
    addi t4,t4,-4
    sub t5,t5,t4

    li t4,0 # actual_column = 0

    j PRINT_RAW_COMBINED_SPRITE_LOOP

PRINT_RAW_COMBINED_SPRITE_LOOP_EXIT:
    ret
#====================================================================================================
