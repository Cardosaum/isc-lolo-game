.data
    .include "lolo.data"
    .include "map.data"
    .include "macros.s"

.text
MAIN:
    init()
    #print_pixel(0, 0, 100)
    #print_pixel(100, 0, 100)
    #print_pixel(100, 100, 100)
    #print_pixel(101, 101, 100)
    #print_pixel(102, 102, 100)
    #print_pixel(320, 240, 100)
    #li a0,100
    #li a1,200
    #li a2,255
    #jal PRINT_PIXEL
    #li a1,220
    #jal PRINT_PIXEL
    #li a1,180
    #li a2,7
    #jal PRINT_PIXEL
    li a0,40
    li a1,40
    la a3,lolo
    jal PRINT_SPRITE
    exit()

PRINT_PIXEL:
    # (base_pixel := 0) + y*width + x
    # a0: x
    # a1: y
    # a2: color
    mul t1,s1,a1
    add t1,t1,a0
    add t1,t1,s0
    sw a2,(t1)
    ret

PRINT_SPRITE:
    # a0: x
    # a1: y
    # a3: sprite address
    lw t1,0(a3) # t1 = image_width
    lw t2,4(a3) # t2 = image_height
    mul t3,t1,t2 # t3 = t1*t2 (image area)
    srli t3,t3,2 # t3 /= 4
    li t4,0 # actual_column
    addi t5,a3,8 # t5 = first 4 pixels
    mv t0,s0 # frame address copy

PRINT_SPRITE_LOOP:
    lw t6,(t5) # load pixel from HD
    sw t6,(t0) # print pixel to frame
    addi t4,t4,1
    addi t5,t5,4 # pixel_address += 4
    addi t0,t0,4 # frame_address += 4
    addi t3,t3,-1 # image_area -= 1
    bge t4,t1,PRINT_SPRITE_NEXT_LINE # if a0 >= t1: goto PRINT_SPRITE_NEXT_LINE
    beqz t3,PRINT_SPRITE_LOOP_EXIT # if thereis no more pixel to print, exit.
    addi a0,a0,1 # x += 1
    j PRINT_SPRITE_LOOP

PRINT_SPRITE_NEXT_LINE:
    li a0,0
    li t4,0
    addi a1,a1,1
    j PRINT_SPRITE_LOOP

PRINT_SPRITE_LOOP_EXIT:
    ret
