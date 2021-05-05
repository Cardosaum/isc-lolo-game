#====================================================================================================
CAN_LOLO_MOVE:
    # parameters
    # a1: x_relative
    # a2: y_relative

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

    # divide X and Y by 16 in order to compare with MAP_1_MATRIX
    li t0,16
    div t1,a1,t0
    div t2,a2,t0

CAN_LOLO_MOVE_PROCEED:
    # get value for (X,Y) coordinates in MAP_1_MATRIX
    la t0,MAP_1_MATRIX
    add t0,t0,a1
    li t1,20 # our map has width = 20
    mul t1,t1,a2
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
