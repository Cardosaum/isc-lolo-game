.text
LOOP:
    li a7,30
    ecall
    mv t0,a0
    mv t1,a1
    li a7,32
    li a0,1000
    ecall
    j LOOP
