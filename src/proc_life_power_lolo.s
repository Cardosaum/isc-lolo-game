#====================================================================================================
#procedimento para resetar a qtd de vidas do lolo
LOLO_LIFE_RESET:
    la t0,LOLO_LIFE
    li t1,LOLO_LIFE_TOTAL
    sw t1,(t0)
    ret
#====================================================================================================

#====================================================================================================
# procedimento para decrementar a vida do lolo
LOLO_LIFE_DECOUNTER:
    la t0,LOLO_LIFE
    lw t1,(t0)
    addi t1,t1,-1
    sw t1,(t0)
    ret
#====================================================================================================

#====================================================================================================
# Procedimento Para Imprimir A Quantidade De Vidas Do Lolo
# precisamos do x e y do numero pra colocar no mapa, além dos numeros constantes de vidas
# x = 272
# y = 64

LOLO_LIFE_PRINT:
    la t0,RETURN_ADDRESS_LOLO_LIFE_PRINT
    sw ra,(t0)
    li a0,LOLO_LIFE_X
    li a1,LOLO_LIFE_Y
    la t1,LOLO_LIFE
    lw t1,(t1)
    # Load life constants
    li t2,LOLO_LIFE_TOTAL
    li t3,LOLO_LIFE_4
    li t4,LOLO_LIFE_3
    li t5,LOLO_LIFE_2
    li t6,LOLO_LIFE_1    
    # check the number in the counter, LOLO_LIFE
    beq t1,t2,CINCO
    beq t1,t3,QUATRO
    beq t1,t4,TRES
    beq t1,t5,DOIS
    beq t1,t6,UM
    beqz t1,ZERO
CINCO:
    la a2,life_number_5
    j PRINT_NUMBER
QUATRO:
    la a2,life_number_4
    j PRINT_NUMBER
TRES:
    la a2,life_number_3
    j PRINT_NUMBER
DOIS:
    la a2,life_number_2
    j PRINT_NUMBER
UM:
    la a2,life_number_1
    j PRINT_NUMBER
ZERO:
    la a2,life_number_0
    j PRINT_NUMBER
    
PRINT_NUMBER:
    li a5,0
    print_sprite(a0,a1,a2,STC_BLOCK,a5)
    la t0,RETURN_ADDRESS_LOLO_LIFE_PRINT
    lw ra,(t0)
    ret
#====================================================================================================
    
#====================================================================================================
#procedimento para resetar a qtd de tiros do lolo
LOLO_SHOT_RESET:
    la t0,LOLO_SHOT
    li t1,LOLO_SHOT_TOTAL
    sw t1,(t0)
    ret
#====================================================================================================

#====================================================================================================
# procedimento para decrementar a quantidade de tiros do lolo
LOLO_SHOT_DECOUNTER:
    la t0,LOLO_SHOT
    lw t1,(t0)
    addi t1,t1,-1
    sw t1,(t0)
    ret
#====================================================================================================

#====================================================================================================
# Procedimento Para Imprimir A Quantidade De tiros Do Lolo
# precisamos do x e y do numero pra colocar no mapa, além dos numeros constantes de tiros
# x = 272
# y = 112

LOLO_SHOT_PRINT:
    la t0,RETURN_ADDRESS_LOLO_SHOT_PRINT
    sw ra,(t0)
    li a0,LOLO_SHOT_X
    li a1,LOLO_SHOT_Y
    la t1,LOLO_SHOT
    lw t1,(t1)
    
    # Load SHOT constants
    li t2,LOLO_LIFE_TOTAL
    li t5,LOLO_SHOT_2
    li t6,LOLO_SHOT_1 
       
    # check the number in the counter, LOLO_SHOT
    beq t1,t5,DOIS_SHOT
    beq t1,t6,UM_SHOT
    beqz t1,ZERO_SHOT
    
DOIS_SHOT:
    la a2,life_number_2
    j PRINT_NUMBER_SHOT
UM_SHOT:
    la a2,life_number_1
    j PRINT_NUMBER_SHOT
ZERO_SHOT:
    la a2,life_number_0
    j PRINT_NUMBER_SHOT
    
PRINT_NUMBER_SHOT:
    li a5,0
    print_sprite(a0,a1,a2,STC_BLOCK,a5)
    la t0,RETURN_ADDRESS_LOLO_SHOT_PRINT
    lw ra,(t0)
    ret
#====================================================================================================


