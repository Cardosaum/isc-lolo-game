#=====================================================================================================
PLAY_MUSIC:
    la s0,NUMBER_OF_NOTES
    lw s1,0(s0)         
    la s0,NOTE_AND_DURATION  #QNT DE NOTAS
    li t0,0                  #CONTADOR
    li a2,45                 #INSTRUMENTAL
    li a3,140                #VOLUME

PLAY_MUSIC_LOOP:
    beq t0,s1,PLAY_MUSIC_END
    lw a0,0(s0)          # VALOR DA NOTA
    lw a1,4(s0)          # DURACAO DA NOTA
    li a7,31             # SYSCALL
    ecall                # REPRODUZ A NOTA
    mv a0,a1             # DURACAO DA NOTA PRA PAUSA
    li a7,32
    ecall                # PAUSA DE a0 ms
    addi s0,s0,8         # INCREMENTA PARA O ENDEREÇO DA PROXIMA NOTA
    addi t0,t0,1         # ADICIONA MAIS UM AO CONTADOR DE NOTAS
    j PLAY_MUSIC_LOOP               # VOLTA AO LOOP
    
PLAY_MUSIC_END:
    ret
#=====================================================================================================