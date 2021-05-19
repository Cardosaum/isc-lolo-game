#====================================================================================================
    # check if lolo collected all hearts for this level
    # if yes, a0 = 1, else a0 = 0
HEART_CHECK_COLLECTED_ALL:
    # store return address for later
    store_word(t0,ra,RETURN_ADDRESS_HEART_CHECK_COLLECTED_ALL)

    li t0,0 # counter
    li t1,0 # how many hearts thereis in this level
    li t2,0 # how many hearts does lolo collected until now
    la t3,DYN_VECT_STRUCT
    lw t4,4(t3) # how many structs thereis in the array of structs
    lw t3,(t3) # go to first array position
    li t5,SPRITE_STRUCT_SIZE # how big is the struct
    li s0,ID_SPRITE__HEART

HEART_CHECK_COLLECTED_ALL_LOOP:
    # check if we performed all needed loops
    bge t0,t4,HEART_CHECK_COLLECTED_ALL_CHECK_COLLECTED_ALL

    # check if current struct belongs to a heart
    lw t6,(t3) # read sprite_id
    bne t6,s0,HEART_CHECK_COLLECTED_ALL_LOOP_PREP_NEXT_LOOP

    # update how many hearts thereis in this level
    addi t1,t1,1

    # check if this heart was already collected
    lw t6,STRUCT_OFFSET__USED(t3) # read struct's field 'used'
    beqz t6,HEART_CHECK_COLLECTED_ALL_LOOP_PREP_NEXT_LOOP

    # update how many hearts lolo collected
    addi t2,t2,1

HEART_CHECK_COLLECTED_ALL_LOOP_PREP_NEXT_LOOP:
    addi t0,t0,1
    add t3,t3,t5
    j HEART_CHECK_COLLECTED_ALL_LOOP

HEART_CHECK_COLLECTED_ALL_CHECK_COLLECTED_ALL:
    beq t1,t2,HEART_CHECK_COLLECTED_ALL_DOES_COLLECTED_ALL
    li a0,0
    j HEART_CHECK_COLLECTED_ALL_EXIT

HEART_CHECK_COLLECTED_ALL_DOES_COLLECTED_ALL:
    # if lolo collected all needed hearts, set a0 to 1
    li a0,1

HEART_CHECK_COLLECTED_ALL_EXIT:
    # retrieve return address and return to caller
    load_word(ra,RETURN_ADDRESS_HEART_CHECK_COLLECTED_ALL)
    ret
#====================================================================================================
