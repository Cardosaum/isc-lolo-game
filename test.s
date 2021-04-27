.data
.include "lolo.data"

.text
.macro render(%img_address,%coluna,%linha,%frame)
    li t1 0xFF0        # t1 = 0xFF0
    add t1 t1 %frame    # t1 = 0xFF0 + frame
    slli t1 t1 20        # seta t1 para o formato do endereço do bitmap display

    mv t0 %img_address    # carrega em t0 endereco imagem

    li t2 256        # t2 = 256 total de pixels
    li t3 0            # t3 = 0 contador imagem
    li t6 0            # t6 = 0 contador coluna
    li t5 320        # t5 = 320
    mul t5 %linha t5    # multiplica linha por 320 (põe linha correspondente ao endereco bitmap)
    add t5 t5 %coluna    # t5 = linha setada + coluna
    add t1 t1 t5        # soma t5 ao endereco display
    addi t0 t0 8        # soma 8 a endereco imagem
    li t5 16        # t5 = 16 pixels na coluna

LOOP:
    beq t3 t2 EXIT2        # if t3 = t2 go to EXIT2
    lw t4 0(t0)        # carrega em t4 4 pixels
    sw t4 0(t1)        # bota na tela 4 pixels
    addi t0 t0 4
    addi t1 t1 4        # t0, t1, t3 e t4 sao acrescidos de 4
    addi t3 t3 4
    addi t6 t6 4
    beq t6 t5 EXIT1        # if t4 = t5 go to EXIT1
    j LOOP

EXIT1:
    mv t6 zero        # t6 = 0
    addi t1 t1 0x130    # soma endereco display + 304
    j LOOP

EXIT2:

.end_macro
