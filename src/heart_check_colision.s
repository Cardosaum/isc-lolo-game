#====================================================================================================
    # check if lolo did colide with a heart
    # return 1 if lolo colide, 0 otherwise
HEART_CHECK_COLISION:
    # store return address for later
    store_word(t0,ra,RETURN_ADDRESS_HEART_CHECK_COLISION)

    # get how many iterations we will need to do in the array of structs
    la s0,DYN_VECT_STRUCT
    lw t1,4(s0) # get array length
    store_word(t0,t1,HEART_CHECK_COLISION_LOOP_COUNTER_TOTAL)

    # start counter at zero
    li t1,0
    store_word(t0,t1,HEART_CHECK_COLISION_LOOP_COUNTER_CURRENT)

    # init struct to 0
    lw s0,(s0)
    store_word(t0,s0,HEART_CHECK_COLISION_CURRENT_STRUCT)

HEART_CHECK_COLISION_LOOP:
    # check if we did all needed loops
    load_word(s0,HEART_CHECK_COLISION_LOOP_COUNTER_TOTAL)
    load_word(s1,HEART_CHECK_COLISION_LOOP_COUNTER_CURRENT)
    bge s1,s0,HEART_CHECK_COLISION_EXIT


    # check if the current struct is a heart. if not, just jump to next item
    load_word(s2,HEART_CHECK_COLISION_CURRENT_STRUCT)
    li t0,ID_SPRITE__HEART
    lw t1,(s2) # read sprite_id
    bne t0,t1,HEART_CHECK_COLISION_LOOP_PREP_NEXT

    # if it's a heart, print a debug
    lolo_map_1_heart_reset()
    lolo_map_1_heart_counter()
    jal LOLO_MAP_1_PRINT_TEST_HEART
    sleep(2000)

HEART_CHECK_COLISION_LOOP_PREP_NEXT:
    # update counter
    addi s1,s1,1
    store_word(t0,s1,HEART_CHECK_COLISION_LOOP_COUNTER_CURRENT)

    # update update struct position
    load_word(s0,HEART_CHECK_COLISION_CURRENT_STRUCT)
    li t0,SPRITE_STRUCT_SIZE
    add s0,s0,t0
    store_word(t0,s0,HEART_CHECK_COLISION_CURRENT_STRUCT)

    # loop again
    j HEART_CHECK_COLISION_LOOP


HEART_CHECK_COLISION_EXIT:
    # retrieve return address and return to caller
    load_word(ra,RETURN_ADDRESS_HEART_CHECK_COLISION)
    ret
#====================================================================================================
