#====================================================================================================
######################################### MAPA 1 ####################################################
#procedimento para incrementar quantidade de corações
LOLO_MAP_1_HEART_RESET:
    la t0,LOLO_HEART_MAP_1
    li t1,MAP_1_INITIAL_TOTAL_HEART
    sw t1,(t0)
    ret
#====================================================================================================

#====================================================================================================
LOLO_MAP_1_HEART_COUNTER:
    la t0,LOLO_HEART_MAP_1
    lw t1,(t0)
    addi t1,t1,1
    sw t1,(t0)
    ret

LOLO_MAP_1_PRINT_TEST_HEART:
    la t0,LOLO_MAP_1_PRINT_TEST_HEART_RETURN_ADDRESS
    sw ra,(t0)
    li a0,LOLO_SHOT_X
    li a1,128
    la t1,LOLO_HEART_MAP_1
    lw t1,(t1)
    
    # Load SHOT constants
    li t2,LOLO_LIFE_TOTAL
    li t5,MAP_1_HEART_2
    li t6,MAP_1_HEART_1
       
    # check the number in the counter, LOLO_SHOT
    beq t1,t5,DOIS_HEART
    beq t1,t6,UM_HEART
    beqz t1,ZERO_HEART
    
DOIS_HEART:
    la a2,life_number_2
    j PRINT_NUMBER_SHOT
UM_HEART:
    la a2,life_number_1
    j PRINT_NUMBER_SHOT
ZERO_HEART:
    la a2,life_number_0
    j PRINT_NUMBER_SHOT
    
PRINT_NUMBER_HEART:
    li a5,0
    print_sprite(a0,a1,a2,STC_BLOCK,a5)
    la t0,RETURN_ADDRESS_LOLO_SHOT_PRINT
    lw ra,(t0)
    ret
######################################################################################################
