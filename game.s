.include "macros.s"

.data
    .include "LOLO16x16.data"
    .include "LOLOU16x16.data"
    .include "LOLOR16x16.data"
    .include "LOLOL16x16.data"
    .include "map.data"

.text
MAIN:
    init()
    print_sprite(0, 0, map)
    print_sprite(150, 100, LOLO16x16)
    print_sprite(166, 100, LOLOU16x16)
    print_sprite(182, 100, LOLOR16x16)
    print_sprite(198, 100, LOLOL16x16)
    #sleep(1000)

.eqv MMIO_set 0xff200000
.eqv MMIO_add 0xff200004

    li t0,MMIO_set
LOOP_POOL:
    lb t1,(t0)
    beqz t1,LOOP_POOL
    li a0,MMIO_add
    lw a0,(a0)
    li a7, 11
    ecall
    j LOOP_POOL
    exit()

.include "ui.s"
