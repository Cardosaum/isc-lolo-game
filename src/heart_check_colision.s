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

    # check if heart was already computed
    li t1,STRUCT_OFFSET__USED
    add t1,t1,s2
    lw t1,(t1)
    bnez t1,HEART_CHECK_COLISION_LOOP_PREP_NEXT

    # if it's a heart, check if lolo has the same (X,Y)
    lw t1,4(s2) # get current (X,Y) for the heart
    la t2,DYN_VECT_STRUCT # we assume Lolo will always be in index 0 of array
    lw t2,(t2) # go to index 0 of the array
    lw t3,4(t2) # get current (X,Y) for lolo
    bne t1,t3,HEART_CHECK_COLISION_LOOP_PREP_NEXT # if they are different, go to next iteration

    # they have the same (X,Y), so we now print heart's hidden sprite
    load_word(a0,HEART_CHECK_COLISION_LOOP_COUNTER_CURRENT)
    jal DYNAMIC_SPRITE_PRINT_HIDDEN_SPRITE
    lolo_map_heart_counter()
    jal LOLO_MAP_PRINT_TEST_HEART

    # and update 'used' struct field
    li t1,STRUCT_OFFSET__USED
    load_word(s2,HEART_CHECK_COLISION_CURRENT_STRUCT)
    add t1,s2,t1
    li t0,1
    sw t0,(t1)

    # update hidden sprite for lolo (we must replace the saved heart by a ground)
    # a1: address for lolo hidden_sprite
    la a1,DYN_VECT_STRUCT
    lw a1,(a1)
    addi a1,a1,STRUCT_OFFSET__HIDDEN_SPRITE
    # a0: address for heart hidden_sprite
    load_word(a0,HEART_CHECK_COLISION_CURRENT_STRUCT)
    addi a0,a0,STRUCT_OFFSET__HIDDEN_SPRITE
    li a2,SPRITE_IMAGE_SIZE_STRUCT_SIZE
    jal COPY_VECTOR

    # TODO:
    # variável pra mapa
    # procedimento de checagem de número de mapa
    # procedimento checagem coração para dar tiro
    # contadores

HEART_CHECK_COLISION_LOOP_PREP_NEXT:
    # update counter
    load_word(s1,HEART_CHECK_COLISION_LOOP_COUNTER_CURRENT)
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
