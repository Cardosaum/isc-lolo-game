COPY_VECTOR:
    # a0: source vector
    # a1: dest vector
    # a2: size
    # copy src to dest. size must obey (size <= min(len(src), len(dest)))
COPY_VECTOR_EXIT_LOOP:
    blez a2,COPY_VECTOR_EXIT
    lb t0,(a0)
    sb t0,(a1)
    addi a0,a0,1
    addi a1,a1,1
    addi a2,a2,-1
    j COPY_VECTOR_EXIT_LOOP
COPY_VECTOR_EXIT:
    ret
