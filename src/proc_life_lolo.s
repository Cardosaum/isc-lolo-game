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
    



