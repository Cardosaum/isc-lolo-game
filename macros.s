.macro init()
    # s0: frame selected
    # s1: canvas width
    # s2: canvas height
    li s0,0xFF000000
    li s1,320
    li s2,240
.end_macro

.macro exit()
    li a7,10
    ecall
.end_macro

.macro print_pixel(%x, %y, %color)
    addi t1,zero,%x
    li t2,%y
    mul t3,s1,t2
    add t1,t1,t3
    add t5,s0,t1
    li t4,%color
    sw t4,(t5)
.end_macro

.macro print_sprite(%x, %y, %sprite_address)
    li a0,%x
    li a1,%y
    la a3,%sprite_address
    jal PRINT_SPRITE
.end_macro
