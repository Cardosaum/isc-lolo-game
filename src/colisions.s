#====================================================================================================
CAN_LOLO_MOVE:
    # parameters
    # a1: x_relative
    # a2: y_relative
    # a3: up_down_left_right // up: 0; left: 1; down: 2; right: 3;

    # outputs
    # a1: yes_or_no // return 0 if lolo can NOT move, 1 otherwise

    # save return address for later use
    la t0,RETURN_ADDRESS_CAN_LOLO_MOVE
    sw ra,(t0)

    li a0,0 # lolo index is always 0

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

    # get desired pixels
    # we will need two tuples of (x,y), that will be:
    # s6: x_1
    # s7: y_1
    # s8: x_2
    # s9: y_2

    # conditional get pixels
    beqz a3,CAN_LOLO_MOVE_GET_PIXELS_UP
    li t0, 1
    beq a3,t0,CAN_LOLO_MOVE_GET_PIXELS_LEFT
    li t0, 2
    beq a3,t0,CAN_LOLO_MOVE_GET_PIXELS_DOWN
    li t0, 3
    beq a3,t0,CAN_LOLO_MOVE_GET_PIXELS_RIGHT

    # get edge pixels
CAN_LOLO_MOVE_GET_PIXELS_UP:
    can_lolo_move_get_pixel_upper_left(s6,s7,t1)
    can_lolo_move_get_pixel_upper_right(s8,s9,t1)
    j CAN_LOLO_MOVE_PROCEED

CAN_LOLO_MOVE_GET_PIXELS_LEFT:
    can_lolo_move_get_pixel_upper_left(s6,s7,t1)
    can_lolo_move_get_pixel_lower_left(s8,s9,t1)
    j CAN_LOLO_MOVE_PROCEED

CAN_LOLO_MOVE_GET_PIXELS_DOWN:
    can_lolo_move_get_pixel_lower_left(s6,s7,t1)
    can_lolo_move_get_pixel_lower_right(s8,s9,t1)
    j CAN_LOLO_MOVE_PROCEED

CAN_LOLO_MOVE_GET_PIXELS_RIGHT:
    can_lolo_move_get_pixel_upper_right(s6,s7,t1)
    can_lolo_move_get_pixel_lower_right(s8,s9,t1)
    j CAN_LOLO_MOVE_PROCEED


CAN_LOLO_MOVE_PROCEED:
    # get value for (X,Y) coordinates in MAP_1_MATRIX
    # check for both (s6,s7) or (s8,s9)
    # we need to divide each coordinate by 16 in order to fit in the reduced mip matrix
    li t2,16
    div s6,s6,t2
    div s7,s7,t2
    div s8,s8,t2
    div s9,s9,t2
    load_word(t0,MAP_1_MATRIX)
    add t0,t0,s6
    li t1,20 # our map has width = 20
    mul t1,t1,s7
    add t0,t0,t1
    lb t0,(t0) # read value in (X,Y)
    beqz t0,CAN_LOLO_MOVE_RETURN_0
    load_word(t0,MAP_1_MATRIX)
    add t0,t0,s8
    li t1,20 # our map has width = 20
    mul t1,t1,s9
    add t0,t0,t1
    lb t0,(t0) # read value in (X,Y)
    beqz t0,CAN_LOLO_MOVE_RETURN_0
    j CAN_LOLO_MOVE_RETURN_1

CAN_LOLO_MOVE_RETURN_0:
    li a1,0
    j CAN_LOLO_MOVE_EXIT
CAN_LOLO_MOVE_RETURN_1:
    li a1,1
CAN_LOLO_MOVE_EXIT:
    la t0,RETURN_ADDRESS_CAN_LOLO_MOVE
    lw ra,(t0)
    ret
#====================================================================================================

#====================================================================================================
WILL_COLLIDE_WITH_DYNAMIC_SPRITE:
    # check if dynamic sprite with index 'a0' will collide with other dynamic sprite
    # return 0 if will not collide, 1 otherwise

    # a0: array_struct_index

    # save return address for later use
    la t0,RETURN_ADDRESS_WILL_COLLIDE_WITH_DYNAMIC_SPRITE
    sw ra,(t0)
    la t0,WILL_COLLIDE_WITH_DYNAMIC_SPRITE_A0
    sw a0,(t0)

    # get how many items thereis on array
    la t0,DYN_VECT_STRUCT
    lw s1,4(t0)

LOOP_THROUGH_DYNAMIC_SPRITES_LOOP:
    blez s1,LOOP_THROUGH_DYNAMIC_SPRITES_EXIT

LOOP_THROUGH_DYNAMIC_SPRITES_EXIT:
    la t0,RETURN_ADDRESS_LOOP_THROUGH_DYNAMIC_SPRITES
    lw ra,(t0)
    ret
#

    # jump necessary structs
    jal HOW_MANY_BYTES_SKIP_TO_REACH_ITH
    la t0,DYN_VECT_STRUCT
    lw t0,(t0)
    add t0,t0,a0

    # get struct's 'collide' field
    addi t0,t0,612 # jump necessary fields
    lw a0,(t0)


WILL_COLLIDE_WITH_DYNAMIC_SPRITE_EXIT:
    la t0,RETURN_ADDRESS_WILL_COLLIDE_WITH_DYNAMIC_SPRITE
    lw ra,(t0)
    ret
#====================================================================================================

#====================================================================================================
CAN_LOLO_MOVE_GLITCH:
    # parameters
    # a1: x_relative
    # a2: y_relative
    # a3: up_down_left_right // 0 if for up and right, 1 is for down and left

    # outputs
    # a1: yes_or_no // return 0 if lolo can NOT move, 1 otherwise

    # save return address for later use
    la t0,RETURN_ADDRESS_CAN_LOLO_MOVE_GLITCH
    sw ra,(t0)

    li a0,0 # lolo index is always 0

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

    # divide X and Y by 16 in order to compare with MAP_1_MATRIX
    li t0,16
    rem t2,a1,t0
    div a1,a1,t0
    bnez t2,CAN_LOLO_MOVE_GLITCH_ADD_ONE_TO_A1
CAN_LOLO_MOVE_GLITCH_CONTINUE_DIVISION:
    rem t2,a2,t0
    div a2,a2,t0
    bnez t2,CAN_LOLO_MOVE_GLITCH_ADD_ONE_TO_A2
    j CAN_LOLO_MOVE_GLITCH_PROCEED
CAN_LOLO_MOVE_GLITCH_ADD_ONE_TO_A1:
    add a1,a1,a3
    j CAN_LOLO_MOVE_GLITCH_CONTINUE_DIVISION
CAN_LOLO_MOVE_GLITCH_ADD_ONE_TO_A2:
    add a2,a2,a3

CAN_LOLO_MOVE_GLITCH_PROCEED:
    # get value for (X,Y) coordinates in MAP_1_MATRIX
    la t0,MAP_1_MATRIX
    add t0,t0,a1
    li t1,20 # our map has width = 20
    mul t1,t1,a2
    add t0,t0,t1
    lb t0,(t0) # read value in (X,Y)
    beqz t0,CAN_LOLO_MOVE_GLITCH_RETURN_0
    j CAN_LOLO_MOVE_GLITCH_RETURN_1

CAN_LOLO_MOVE_GLITCH_RETURN_0:
    li a1,0
    j CAN_LOLO_MOVE_GLITCH_EXIT
CAN_LOLO_MOVE_GLITCH_RETURN_1:
    li a1,1
CAN_LOLO_MOVE_GLITCH_EXIT:
    la t0,RETURN_ADDRESS_CAN_LOLO_MOVE_GLITCH
    lw ra,(t0)
    ret
#====================================================================================================
