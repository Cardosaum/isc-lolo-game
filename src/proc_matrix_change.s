#====================================================================================================
# procedimento para mudan�a dos valores nas matrizes do mapa
# a0 = x recebido, adiciona com endere�o base
# a1 = y reccebido, multiplica por 20
# a2 = endere�o base
# somar a1 e a0
# a3 = novo valor
MATRIX_MAP_CHANGE_VALUE:
    la t0,RETURN_ADDRESS_MATRIX_MAP_CHANGE_VALUE
    sw ra,(t0)
    
    li t1,WIDTH_MATRIX # = 20
    add t2,a0,a2 # x + EB
    mul t3,a1,t2 # (Y * 20)
    add a2,t2,t3 # Endere�o base novo
    sb a3,(a2) # Valor na posi��o (X,Y) que est� na matriz, e armazenando o novo valor
    
    la t0,RETURN_ADDRESS_MATRIX_MAP_CHANGE_VALUE
    lw ra,(t0)
    ret

#====================================================================================================
    