#====================================================================================================
#procedimento para incrementar quantidade de corações
LOLO_MAP_HEART_RESET:
    la t0,LOLO_HEART_MAP
    li t1,MAP_INITIAL_TOTAL_HEART
    sw t1,(t0)
    ret
#====================================================================================================

#====================================================================================================
LOLO_MAP_HEART_COUNTER:
    la t0,LOLO_HEART_MAP
    lw t1,(t0)
    addi t1,t1,1
    sw t1,(t0)
    ret

LOLO_MAP_PRINT_TEST_HEART:
    la t0,LOLO_MAP_PRINT_TEST_HEART_RETURN_ADDRESS
    sw ra,(t0)
    li a0,LOLO_SHOT_X # usar esse por enquanto
    li a1,128
    la t1,LOLO_HEART_MAP
    lw t1,(t1)
    
    # Load heart constants
    li t2,MAP_INITIAL_TOTAL_HEART
    li t5,MAP_HEART_2
    li t6,MAP_HEART_1
       
    # check the number in the counter, LOLO_SHOT
    beq t1,t5,DOIS_HEART
    beq t1,t6,UM_HEART
    beqz t1,ZERO_HEART
    
DOIS_HEART:
    la a2,life_number_2
    j PRINT_NUMBER_HEART
UM_HEART:
    la a2,life_number_1
    j PRINT_NUMBER_HEART
ZERO_HEART:
    la a2,life_number_0
    j PRINT_NUMBER_HEART
    
PRINT_NUMBER_HEART:
    li a5,0
    print_sprite(a0,a1,a2,STC_BLOCK,a5)
    la t0,LOLO_MAP_PRINT_TEST_HEART_RETURN_ADDRESS
    lw ra,(t0)
    ret
######################################################################################################
#====================================================================================================
